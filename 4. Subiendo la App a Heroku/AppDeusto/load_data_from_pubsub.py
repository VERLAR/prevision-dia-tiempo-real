# -*- coding: utf-8 -*-

from google.cloud import pubsub_v1
from google.oauth2 import service_account
import json
import redis
import pandas as pd
from apscheduler.schedulers.blocking import BlockingScheduler


def run():
    global df

    try:
        # Llamada a PubSub
        response = client.pull(subscription, 1000)
        # Guardamos los registros de los mensajes recibidos
        ack_ids = []
        # Guardamos los mensajes en un DataFrame
        for msg in response.received_messages:
            # Guardamos los registros de los mensajes recibidos
            ack_ids += [msg.ack_id]
            # Guardamos los mensajes
            msg = msg.message.data.decode('utf-8')
            msg = json.loads(msg)

            msg = pd.DataFrame({'ticketDate': [msg['ticketDate']], 'amount': [msg['amount']]})
            df = pd.concat([df, msg], ignore_index=True, sort=False)

        # Confirmamos la recepción de los mensajes
        client.acknowledge(subscription, ack_ids)
    except Exception as e:
        # Si el Pipeline está vacío, muestra el siguiente mensaje
        print(e)

    df = df.groupby('ticketDate').sum().reset_index().sort_values('ticketDate')

    # Mostrar los datos para asegurar la recepción de PubSub
    df_json = df.to_dict(orient='records')
    df_json = json.dumps(df_json)

    r.set('dataframe', df_json)


if __name__ == '__main__':
    # TODO: Cambiar url Redis
    r = redis.from_url(
        'redis://h:pf73262bbe920a3cc6f8660cd17d8e42a97985a22d4fd7b8785d8aa421ea24b92@ec2-52-200-153-234.compute-1.amazonaws.com:26799')

    # TODO: Poner las datos del proyecto y de la suscripción
    project_id = ''
    subscription_name = ''

    # Despues de fijar las credenciales de Google,
    # nos conectamos a la suscripción de PubSub
    # TODO: Poner las credenciales en la carpeta adecuada
    info = json.loads('credenciales/credentials.json')
    credentials = service_account.Credentials.from_service_account_info(info)
    client = pubsub_v1.SubscriberClient(credentials=credentials)
    subscription = client.subscription_path(project_id, subscription_name)

    # Inicializar los datos
    df = pd.DataFrame({'ticketDate': [], 'amount': []})

    # Creamos nuestras tareas 'cron'
    sched = BlockingScheduler()
    sched.add_job(run, 'interval', seconds=10)

    sched.start()
