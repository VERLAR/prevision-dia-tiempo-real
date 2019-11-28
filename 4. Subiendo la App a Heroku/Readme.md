# Poniendo todo en marcha

En esta última fase, vamos a tener 2 bloques principales:

 1. Subir datos a PubSub
 1. AppDeusto
 
Por una parte (Subir datos a PubSub), utilizaremos un notebook de Jupyter el cual estará funcionando
en bucle simulando los tickets en tiempo real y por la otra parte tendremos la App que montaremos en Heroku.

Teniendo eso en cuenta, tendremos que activar ambas partes para que
nuestra App funcione. Es decir, si no activamos `Subir datos a PubSub`
podremos lanzar la App, pero no recibirá ningún dato y por lo tanto no
se dibujará nada en los gráficos. Por otro lado, si hacemos a la inversa,
estaremos subiendo los datos en tiempo real a Google Cloud pero no
tendremos nada que esté recibiendo/pintando esos datos.
