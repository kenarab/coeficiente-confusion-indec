# Coeficiente de Confusión- Indec

El proyecto consta de
* Un programa en R que procesa el coeficiente de confusión y genera salidas.
* aplicación web en JS para generar los gráficos interactivos

# R: instrucciones para reproducir ejercicio 

```
cd R
Rscript coeficiente_confusion.R
```
El programa descarga los datos oficiales recopilados en el sitio datahub.io y a partir de esa información, empalma las series correspondientes, calcula los coeficientes, grafica y exporta los archivos.

La exportación se realiza en un directorio definido en la variable export.dir ( el valor por defecto es ~/coeficiente-confusion):
* ipc-indec-sanluis-variaciones.png
* ipc-indec-sanluis-coeficiente.confusion.png
* ipc-2005-2014-coeficiente-confusion.csv

Se reemplaza el archivo de datos de la aplicación web data/ipc_2005_2014_coeficiente_confusion.csv

## Dependencias 
Para correr el proceso, debe tener el lenguaje de estadística computacional [R](http://www.r-project.org/) instalado en su computadora.
Además, para descargar los datos, el programa usa el paquete RCurl, implementación en R de Curl. Si bien la instalación del paquete en R es automática, la instalación de la librería Curl tiene que realizarla el usuario. 

En Ubuntu, el comando para instalar R y la librería Curl es:
```
sudo apt-get install r-base libcurl4-openssl-dev 
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
