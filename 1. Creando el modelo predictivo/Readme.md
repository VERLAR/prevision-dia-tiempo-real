# Creando el modelo predictivo

Hasta ahora, hemos sentado las bases de lo que vamos a hacer y hemos construido la materia prima que vamos a usar, los datos fake.

Ahora, vamos a usar los datos históricos (*FakeData*)
para crear nuestros modelos predictivos. 

Se van a crear 12 modelos de regresión utilizando los modelos [SVR](https://scikit-learn.org/stable/modules/generated/sklearn.svm.SVR.html)
del módulo de [scikit-learn](https://scikit-learn.org/stable/index.html) de [Python](https://www.python.org/).
Un modelo para cada hora del día, empezando a las 10 de la mañana y acabando a las
21 horas. El objetivo de la previsión son las ventas totales al final de cada dia.

 
En `Modelo` encontramos un *notebook* o cuaderno de [Jupyter](https://jupyter.org/) con el
que se explica paso a paso la generación del modelo predictivo. 

Nuevamente usaremos Colab,  [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/VERLAR/prevision-dia-tiempo-real/blob/Colab/1.%20Creando%20el%20modelo%20predictivo/Modelo/Modelo.ipynb)

> Al finalizar, es importante descargarse la carpeta resultante **modelos** 

