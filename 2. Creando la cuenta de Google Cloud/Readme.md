# Creando la cuenta de Google Cloud

En esta documentación se explicarán los pasos para crear y activar una cuenta
en Google Cloud, y cómo crear un *pipeline* en streaming mediante [PubSub](https://cloud.google.com/pubsub/docs/overview).

Por una parte vamos a crear un *tema* (*topic*) el cual va a estar *escuchando* todo el tiempo y le
podremos enviar los mensajes que queramos.

Por otro lado, vamos a tener una *suscripción* (*subscription*) en el que nos devolverá
todo aquello que nuestro *tema* haya *escuchado*.

1. [Creando la cuenta](#creando-la-cuenta)
1. [Activando un pipeline en streaming mediante PubSub](#activando-un-pipeline-en-streaming-mediante-pubsub)
    1. [Crear tema (topic)](#crear-tema-topic)
    1. [Crear suscripción (subscription)](#crear-suscripcin-subscription)
1. [Probando nuestro PubSub](#probando-nuestro-pubsub)
    1. [Creando credenciales](#creando-credenciales)
    1. [Comprobando mediante Python](#comprobando-mediante-python)
 
## Creando la cuenta

Para crear la cuenta en Google Cloud tenemos que acceder a la siguiente url y registrarnos:

[https://cloud.google.com/](https://cloud.google.com/)

 >- **Nota: Tendremos que dar un número de cuenta válido para esa activación, aunque
    sea para una versión gratuita**

![Version_gratuita_google](../Imagenes/Version_gratuita_google.png)

Una vez activada la cuenta, accederemos a una pantalla inicial similar a la siguiente:

![Pantalla_de_inicio](../Imagenes/Pantalla_de_inicio.png)

## Activando un pipeline en streaming mediante PubSub

Una vez estemos en la pantalla inicial, accederemos al apartado de PubSub
haciendo click en la parte superior izquierda:

![Entrando_en_PubSub](../Imagenes/Entrando_en_PubSub.png)

De esa forma accederemos a PubSub:

![PubSub](../Imagenes/PubSub.png)

### Crear tema (topic)

Empezaremos por crear un tema:

![Creando_tema](../Imagenes/Creando_tema.png)

### Crear suscripción (subscription)

Y continuaremos creando una suscripción para una aplicación personalizada:

![Crear_suscripcion](../Imagenes/Crear_suscripcion.png)

Para este ejemplo, elegiremos las siguientes opciones:

![Crear_suscripcion_2](../Imagenes/Crear_suscripcion_2.png)

Por lo que con esto ya tendríamos activado nuestro PubSub

## Probando nuestro PubSub

Para probar nuestro canal de PubSub, vamos a activar las credenciales para la API
de PubSub.

### Creando credenciales

![Activar_API](../Imagenes/Activar_API.png)

![Activar_API_2](../Imagenes/Activar_API_2.png)

![Activar_API_3](../Imagenes/Activar_API_3.png)

![Activar_API_4](../Imagenes/Activar_API_4.png)

![Activar_API_5](../Imagenes/Activar_API_5.png)

![Activar_API_6](../Imagenes/Activar_API_6.png)

![Activar_API_7](../Imagenes/Activar_API_7.png)

![Activar_API_8](../Imagenes/Activar_API_8.png)

![Activar_API_9](../Imagenes/Activar_API_9.png)

![Activar_API_10](../Imagenes/Activar_API_10.png)

Una vez finalizado, tendremos descargado un archivo JSON (las credenciales) con el
que podremos acceder mediante Python u otros lenguajes tanto al *tema* como a la 
*suscripción* que acabamos de crear. Para abrir este archivo se usa el bloc de notas.

### Comprobando mediante Python

Una vez se han activado las credenciales de la API, podemos utilizar el
*notebook*

```bash
Comprobando Funcionamiento PubSub.ipynb
``` 

para comprobar que todo funciona correctamente.
