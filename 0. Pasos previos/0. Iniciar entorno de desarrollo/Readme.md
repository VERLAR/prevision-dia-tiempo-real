# Google Colab  
Colab es un servicio cloud, basado en los Notebooks de Jupyter, que permite el uso gratuito de las GPUs y TPUs de Google. Por defecto solo puede usare Python, pero más adelante veremos que también puede usarse R.

Para acceder a Google Colab: https://colab.research.google.com/notebooks/welcome.ipynb

### 1. Conectar con Google Drive

Basta ejecutar el siguiente código y seguir las instrucciones:
```bash
from google.colab import drive
drive.mount(‘/content/gdrive’)
```

Ahora en la sección de directorios (icono carpeta) nos aparecerá nuestro Google Drive. Podría tardar unos minutos en sincronizarse y también puede que sea necesario actualizar el directorio de carpetas.

### 2. Descargar proyecto de GitHub con Git

Si abrimos Google Drive en local, y clickamos en botón derecho y luego, Git bash here, abriremos una ventana de terminal de git, en el directorio donde nos encontramos.
A continuación, nos descargamos el proyecto:
```bash
$ git clone https://github.com/VERLAR/prevision-dia-tiempo-real.git
```




