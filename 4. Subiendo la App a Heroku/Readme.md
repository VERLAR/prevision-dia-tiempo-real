# Poniendo todo en marcha

En esta última fase, vamos a tener 2 bloques principales:

 1. Subir datos a PubSub
 1. AppDeusto
 
Por una parte (Subir datos a PubSub), utilizaremos un notebook de Jupyter el cual estará funcionando
en bucle simulando la llegada de los tickets en tiempo real y por la otra parte tendremos la App que montaremos en Heroku.

Teniendo eso en cuenta, tendremos que activar ambas partes para que
nuestra App funcione. Es decir, si no activamos `Subir datos a PubSub`
podremos lanzar la App, pero no recibirá ningún dato y por lo tanto no
se dibujará nada en los gráficos. Por otro lado, si hacemos a la inversa,
estaremos subiendo los datos en tiempo real a Google Cloud pero no
tendremos nada que esté recibiendo/pintando esos datos.

En consecuencia, comenzamos subiendo los datos a Pubsub con el fin de simular la transmisión de tickets:

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/VERLAR/prevision-dia-tiempo-real/blob/Colab/4.%20Subiendo%20la%20App%20a%20Heroku/Subir%20datos%20a%20PubSub/Carga%20de%20datos%20a%20PubSub.ipynb)

Por último, falta ajustar y subir la App. En su sección esta detallado, pero adelantamos que lo que falta es:
 * recoger los tickets, 
 * aplicar el modelo correspondiente a los datos recibidos, 
  * visualizar los resultados. 
  
  Para efectuarlo basta ir a la carpeta AppDeusto o hacer click [aqui](https://github.com/VERLAR/prevision-dia-tiempo-real/tree/Colab/4.%20Subiendo%20la%20App%20a%20Heroku/AppDeusto)
