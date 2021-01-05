# Fake Data con R

Se procede a generar los datos. Para ello, se cuenta con un
 archivo creado en Jupyter (como notebook de R),  dentro de la carpeta Scripts R:
 [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/VERLAR/prevision-dia-tiempo-real/blob/Colab/0.%20Pasos%20previos/1.%20Generando%20datos/Scripts%20R/Funciones_creacion_datos_y_mapeado.ipynb)

 -  _**Funciones_creacion_datos_y_mapeado.ipynb**_: Este archivo, primeramente carga las librerías de trabajo necesarias
  (la primera vez hay que instalarlas usando install.packages(name), luego basta usar library(name) ) y unos parámetros de
   _**0 - Modelos (a cargar)**_. A continuación se crean las
  siguientes funciones:
  
       - __Simulacion_Historico_movimientos_Ventas(FechaInicio,FechaFin)__: genera el
              histórico de movimientos de ventas en un periodo. Los datos resultantes se guardan en 
              **_1 - Creacion Historico_**. Ejemplo:
              Simulacion_Historico_movimientos_Ventas("2019-01-01","2019-12-31")
              
       - __Desglose_Tickets(date)__: Desglosa un día del histórico creado por Tickets. Los datos
             resultantes se guardan en _**2 - Creacion de Tickets tiempo real**_. Ejemplo: 
              Desglose_Tickets("2019-12-15")              
             
       - __MapaCalorAnual(año,direccionHistoricoAnual)__: Es necesario contar con el archivo 
              **_calendar - copia.R_**. Genera el mapa de calor a partir de la simulación anual
              inicial. La imagen resultante se guarda en _**3 - Mapas de calor**_.
               Ejemplo: MapaCalorAnual("2019")               
              El resultado muestra de forma visual la distribución del histórico:
              ![Ejemplo visualización Mapa calor 2019](../../Imagenes/MapaCalor2019.jpeg)
        

           
  Aunque dentro del script se explica brevemente las herramientas y razonamientos de creación de
    los datos, se recuerda que se han seguido modelos polinómicos de orden 7 para las ventas (en
     función de los días de la semana, fiestas y días de gran consumo) y un modelo
    bimodal (la función densidad es el producto de dos funciones de densidad normales o gaussianas)
    para simular el tiempo de toma de datos.
 
En resumen, se han generado en **1 - Creacion Historico** carpetas, datos en .txt de un periodo de fechas,
por ejemplo, Simulación_datos_2019-01-01_2019-12-31; en **2 - Creacion de Tickets tiempo real**, datos de 
los tickets de un día del histórico anterior, por ejemplo, Simulación_Tickets_2019-12-15; y opcionalmente
se puede observar la distribución de las ventas al dia, gracias a la generación de un mapa de calor 
en **3 - Mapas de calor**.