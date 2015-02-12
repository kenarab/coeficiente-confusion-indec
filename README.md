# Coeficiente de Confusión- Indec

El proyecto consta de
* scripts en R para procesar los datos y gráficos.
* aplicación web en JS para producir gráficos interactivos

# R: instrucciones para reproducir ejercicio 

```
cd R
Rscript coeficiente_confusion.R
```
El programa descarga los datos oficiales del sitio datahub.io y realiza el procesamiento del coeficiente de confusión

se crea un directorio indicado en la variable export.dir ( el valor por defecto es ~/coeficiente-confusion) donde se guardan los archivos:
ipc-indec-sanluis-variaciones.png
ipc-indec-sanluis-coeficiente.confusion.png
ipc-2005-2014-coeficiente-confusion.csv

y se reemplaza el archivo de datos de la aplicación web
data/ipc_2005_2014_coeficiente_confusion.csv

## Dependencias 
Para descargar los datos, el programa usa el paquete RCurl, implementación en R de Curl. Si bien la instalación del paquete es automática, la instalación de la librería Curl tiene que realizarla el usuario. 

En Ubuntu, el comando para instalar la librería Curl es:
```
sudo apt-get install libcurl4-openssl-dev 
```

## Aplicación Web.

### Instalar las dependencias

```bash
bower install
```

### Correr un server local

```bash
python -m SimpleHTTPServer
```

Abrir el navegador en http://0.0.0.0:8000



## Créditos

- [Alejandro Baranek]   - Análisis y producción de datos.
- [Cristian Bertelegni] - Desarrollo web


[Alejandro Baranek]:https://twitter.com/ken4rab  
[Cristian Bertelegni]:http://twitter.com/cbertelegni

Copyright (C) 2014 Alejandro Baranek — Released under the MIT License