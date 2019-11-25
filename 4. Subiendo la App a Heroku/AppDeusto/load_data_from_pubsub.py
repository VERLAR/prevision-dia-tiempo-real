# -*- coding: utf-8 -*-

from google.cloud import pubsub_v1
from google.oauth2 import service_account
import pandas as pd
import numpy as np
import time
import json

# Despues de fijar las credenciales de Google,
# nos conectamos a la suscripción de PubSub
info = json.loads('credenciales/credentials.json')
credentials = service_account.Credentials.from_service_account_info(info)
client = pubsub_v1.SubscriberClient(credentials=credentials)

# TODO: insertar la 'id' del proyecto y la 'id' de las suscripción PubSub
project_id = ''
subscription_id = ''
subscription = client.subscription_path(project_id, subscription_id)

# #################################################
# Creamos un bucle para llamar a PubSub
# #################################################
while True:
    for i in range(10):
        try:
            # Llamada a PubSub
            response = client.pull(subscription, 1000)
            # Esperamos 5 segundos para que no salte un error de Google
            time.sleep(5)
            # Guardamos los registros de los mensajes recibidos
            ack_ids = []
            # Guardamos los mensajes en un DataFrame
            for msg in response.received_messages:
                # Guardamos los registros de los mensajes recibidos
                ack_ids += [msg.ack_id]
                # Guardamos los mensajes
                msg = msg.message.data.decode('utf-8').split('|')
                try:
                    am = float(msg[0])
                except ValueError:
                    am = np.nan
                msg = pd.DataFrame({'ticketDate': [pd.to_datetime(msg[2])], 'amount': [am]})
                df = pd.concat([df, msg], ignore_index=True, sort=False)
            # Confirmamos la recepción de los mensajes
            client.acknowledge(subscription, ack_ids)
        except Exception as e:
            # Si el Pipeline está vacío, muestra el siguiente mensaje
            print(e)
    # Eliminamos los valores nulos
    df = df[-pd.isnull(df.amount)]
    df = df.groupby('ticketDate').sum().reset_index()
    df.to_csv("data_from_pubsub.csv", index=False, sep=';')

    # Mostrar los datos para asegurar la recepción de PubSub
    print(df)
    df.info()
