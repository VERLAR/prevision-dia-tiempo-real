# time_series.csv

El archivo `.csv` que aparece en esta carpeta *da forma* a la serie temporal
cuando se lanza la predicción. Ahora mismo se ha escogido una única serie temporal
pero se podrían añadir 7 series temporales para cada día de la semana, para ajustar
mejor la forma, ya que cada día de la semana tiene un comportamiento diferente.

Se deja la opción de añadir series temporales a los usuarios interesados. Esta 
serie temporal se carga en el script `prediction.py` en la parte: 

```python
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
```