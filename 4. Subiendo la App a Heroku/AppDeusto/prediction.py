#!/usr/bin/env python
# coding: utf-8

from apscheduler.schedulers.blocking import BlockingScheduler
from datetime import datetime, timedelta
import pandas as pd
import numpy as np
import json
import joblib
import redis
import traceback
import sys
import os

pd.options.mode.chained_assignment = None


def get_data():
    # Lectura de datos
    dataframe = r.get('dataframe')
    dataframe = pd.read_json(dataframe)
    dataframe['ticketDate'] = pd.to_datetime(dataframe['ticketDate'])

    idx = pd.DataFrame(data={'ticketDate': pd.date_range(today, periods=1440, freq='min')})
    dataframe = idx.merge(dataframe, on=['ticketDate'], how='left')
    dataframe = dataframe.fillna(0)

    dataframe.index = dataframe.pop('ticketDate')

    return dataframe


def prepare_data():
    """Preparar los datos en formato (X, y) para la regresión"""

    global df

    # Agrupar los datos en intervalos de 15 minutos
    df = df.resample('15T').sum()

    # Crear variables de 'ticketDay' y 'ticketHour'
    df['ticketDay'] = df.index.map(lambda x: x.strftime('%Y-%m-%d'))
    df['ticketHour'] = df.index.map(lambda x: x.strftime('%H:%M'))

    # Transformar la tabla a formato de modelos de regresión
    df = pd.crosstab(index=df.ticketDay, columns=[df.ticketHour], values=df.amount, aggfunc=sum).fillna(0).reset_index()
    df[df.columns[1:]] = df[df.columns[1:]].cumsum(axis=1)

    df.set_index('ticketDay', inplace=True)


def normalize_data():
    """Normalizar los datos respecto a las ventas más altas"""

    global df

    df /= max_value
    df.reset_index(inplace=True)


def add_day_of_week():
    """Añadir información del día de la semana"""

    df.ticketDay = pd.to_datetime(df.ticketDay)
    weekdays = [
        [0, 'monday'],
        [1, 'tuesday'],
        [2, 'wednesday'],
        [3, 'thursday'],
        [4, 'friday'],
        [5, 'saturday'],
        [6, 'sunday']
    ]
    for weekday, weekday_name in weekdays:
        df[weekday_name] = df.ticketDay.map(lambda x: x.weekday() == weekday)


def add_calendar_info():
    """Añadir información de los días festivos"""

    # TODO: preparar calendario
    calendario = ['2019-01-01', '2019-01-01', '2019-01-06', '2019-03-19',
                  '2019-04-28', '2019-05-15', '2019-07-25', '2019-08-15',
                  '2019-10-12', '2019-11-01', '2019-12-06', '2019-12-08', '2019-12-25', '2019-12-26']

    df['Festivo'] = df['ticketDay'].isin(calendario)


def drop_unused_hours(hour_now):
    """Eliminar las columnas que no se van a utilizar para el cálculo de las previsiones"""

    cols_drop = df.columns[(df.columns > hour_now) & (df.columns < '23:45')]
    for col in cols_drop:
        df.pop(col)

    df.pop('23:45')
    df.pop('ticketDay')


def load_minute_data_redis():
    minute_data = df[(df.index >= today + ' 09:00:00') & (df.index <= now)]
    minute_data['ticketDate'] = (minute_data.index.astype(np.int64) / 1000000)

    values = []
    for index, row in minute_data.iterrows():
        date = int(row['ticketDate'])
        amount = round(row['amount'], 2)
        values += [[date, amount]]

    print('ventas_minuto: ' + str(values))
    r.set('ventas_minuto', str(values))


def load_cumulate_data_redis(real_data=False):
    cumulate = df[['amount']].cumsum()
    cumulate = cumulate[(cumulate.index >= today + ' 09:00:00') & (cumulate.index <= now)]
    cumulate['ticketDate'] = (cumulate.index.astype(np.int64) / 1000000)

    print('ventas_acumuladas: ' + str(cumulate['amount'].max()))
    r.set('ventas_acumuladas', round(cumulate['amount'].max(), 2))

    if real_data:
        r.set('prediccion', round(cumulate['amount'].max(), 2))

    values = []
    for index, row in cumulate.iterrows():
        date = int(row['ticketDate'])
        amount = round(row['amount'], 2)
        values += [[date, amount]]

    print('ventas_acumuladas_minuto: ' + str(values))
    r.set('ventas_acumuladas_minuto', str(values))


def load_shape_time_series(sales, pred):
    """ Obtenemos la 'forma' de la serie temporal """

    ts = pd.read_csv('no_django/forma_serie_temporal/time_series.csv', sep=';')

    ts['ticketDate'] = ts['ticketDate'].map(lambda x: pd.to_datetime(today + ' ' + x))
    ts = ts[(ts['ticketDate'] > now)]
    ts['ticketDate'] = ts['ticketDate'].astype(np.int64) / 1000000
    ts.reset_index(inplace=True)

    ts['amount'] -= ts['amount'].min()
    ts['amount'] /= ts['amount'].max()
    ts['amount'] *= (pred - sales)
    ts['amount'] += sales

    values = []
    for index, row in ts.iterrows():
        date = int(row['ticketDate'])
        amount = round(row['amount'], 2)
        values += [[date, amount]]

    r.set('prediccion_minuto', str(values))


def run():
    global r, calendar, df, today, now, pg, aa, max_value

    # Day info
    now = datetime.now()
    today = now.strftime('%Y-%m-%d')

    file = open('no_django/modelos/max_value.txt', 'r')
    for line in file:
        max_value = float(line)
    file.close()

    r = redis.from_url(os.environ.get("REDIS_URL"))

    # Si todavía no son las 09:02 mostramos los datos del día anterior (o los datos guardados la última vez)
    if now >= datetime.strptime(today + ' 09:02', '%Y-%m-%d %H:%M'):
        # Cargamos los datos
        df = get_data()
        total_sales = df['amount'].sum()

        # Ventas por minuto
        load_minute_data_redis()

        # Ventas acumuladas
        load_cumulate_data_redis()

        # Si estamos entre las 10:16 y las 22:00 calculamos la predicción
        if (now >= datetime.strptime(today + ' 10:16', '%Y-%m-%d %H:%M')) & (now.hour < 22):
            # #################
            # Prediction
            # #################

            # Preparamos los datos para que tengan la misma forma que cuando se ha creado el modelo
            prepare_data()
            normalize_data()
            add_day_of_week()
            add_calendar_info()

            # Metemos un 'lag' de 15 minutos para que los datos se estabilicen
            hour = (now - timedelta(minutes=15)).strftime('%H')
            drop_unused_hours(hour + ':00')

            # Cargamos el modelo correspondiente
            # TODO: se pueden cambiar los modelos para hacer diferentes pruebas
            loaded_model = joblib.load('no_django/modelos/all_data_model_{}00.sav'.format(str(hour)))

            # Calculamos la predicción
            prediction = loaded_model.predict(df)[0] * max_value
            r.set('prediccion', round(prediction, 2))

            # Obtenemos la forma de la serie temporal
            load_shape_time_series(total_sales, prediction)

        # Si estamos entre las 09:00 y las 10:16 todavía no lanzamos una predicción
        elif now < datetime.strptime(today + ' 10:16', '%Y-%m-%d %H:%M'):
            r.set('prediccion_minuto', '[]')

        # A partir de las 22:00 mostramos los datos reales de ventas
        elif now.hour >= 22:
            # Cumulate/Total amount
            load_cumulate_data_redis(real_data=True)


if __name__ == '__main__':
    # Define global variables
    df, r, calendar, today, now, pg, aa, max_value = [None] * 8

    sched = BlockingScheduler()
    sched.add_job(run, 'interval', seconds=60)

    try:
        sched.start()
    except Exception as e:
        exc_type, exc_value, exc_traceback = sys.exc_info()
        subject_email = "Error en prediction.py"
        text_email = "Unexpected error:\n" + \
                     str(sys.exc_info()) + "\n" + \
                     traceback.format_exc() + "\n" + \
                     str(e)
        print(text_email)
