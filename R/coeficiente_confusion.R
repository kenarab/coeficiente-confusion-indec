rm(list = ls())
export.dir<-"~/coeficiente-confusion/"
report.widthPNG<-1366
report.heightPNG<-768
source("lib_coeficiente_confusion.R")

#carga
PkgTest("RCurl")
url_data_ipc_originales<-"https://ckannet-storage.commondatastorage.googleapis.com/2015-02-12T21:44:16.558Z/ipc-indec-sl-2005-2014-oficiales.csv"
data<-read.csv(textConnection(getURL(url_data_ipc_originales)),stringsAsFactors=FALSE)
data$periodo<-as.POSIXct(substr(data$periodo,1,10))

#empalmes
#San Luis Base 2006/12
data[FiltrarPeriodos(data$periodo,"2005-10-01","2014-12-01"),"IPC.San.Luis"]<-
  CambiarBase(data,"IPC.San.Luis.B2003",periodo.base = "2006-12-01",
              periodo.min = "2005-10-01",periodo.max = "2014-12-01")

#INDEC
#IPC.GBA.B1999 Base 2006/12
data[FiltrarPeriodos(data$periodo,"2005-10-01","2008-04-01"),"IPC.INDEC"]<-
  CambiarBase(data,"IPC.GBA.B1999",periodo.base = "2006-12-01",
              periodo.min = "2005-10-01",periodo.max = "2008-04-01")
#Empalme IPC.GBA.B2008.abr IPC.GBA.B1999 en 2008/04
data[FiltrarPeriodos(data$periodo,"2008-04-01","2013-12-01"),"IPC.INDEC"]<-  
  Empalmar(data,indicador.empalmado="IPC.GBA.B2008.abr",indicador.empalme="IPC.INDEC",
           periodo.empalme="2008-04-01",periodo.min="2008-04-01",periodo.max="2013-12-01")
#Empalme IPCNu IPC.GBA.B2008.abr en 2013/12
data[FiltrarPeriodos(data$periodo,"2014-01-01","2014-12-01"),"IPC.INDEC"]<-  
  Empalmar(data,indicador.empalmado="IPCNu",indicador.empalme="IPC.INDEC",
           periodo.empalme="2013-12-01",periodo.min="2014-01-01",periodo.max="2014-12-01")

#procesamiento
data$anio<-format(data$periodo,"%Y")
data$mes<-format(data$periodo,"%m")
data$coeficiente.confusion<-(data$IPC.San.Luis-100)/(data$IPC.INDEC-100)


data$IPC.San.Luis.acumulado.anual<-unlist(sapply(data$periodo,FUN=function(x){GetAcumuladoAnual(data,x,"IPC.San.Luis",mes.base = 12)}))
data$IPC.INDEC.acumulado.anual<-unlist(sapply(data$periodo,FUN=function(x){GetAcumuladoAnual(data,x,"IPC.INDEC",mes.base = 12)}))
data$coeficiente.confusion.acumulado.anual<-(data$IPC.San.Luis.acumulado.anual)/(data$IPC.INDEC.acumulado.anual)

indicadores<-data.frame(indicador=character(),caption=character(),color=character(),stringsAsFactors = FALSE)
indicadores[4,]$indicador<-"dummy"
indicadores$indicador<-
  names(data)[c(7,6,12,11)]
indicadores[1,]$caption<-"INDEC"
indicadores[2,]$caption<-"San Luis"
indicadores[3,]$caption<-"Acum Anual INDEC"
indicadores[4,]$caption<-"Acum Anual San Luis"
indicadores$color<-rep(topo.colors(2),2)
indicadores$lty<-c("solid","solid","dotdash","dotdash")
indicadores$lwd<-c(2,2,3,3)

#Grafico Indices y variaciones
comienzo.intervencion<-as.POSIXct("2006/12/01")

dir.create(export.dir,showWarnings = FALSE)

#define donde van las lineas verticales en los gráficos
ultimos.meses<-data$mes=="12"

GrafIpcs(data,indicadores)
GrafCoeficienteConfusion(data,colores.coeficiente.confusion = topo.colors(2))
write.table(data,file=paste(export.dir,"ipc-2005-2014-coeficiente-confusion.csv",sep=""),row.names=FALSE,dec=".",sep=",",na="")
#exporta datos al directorio data de la aplicación web

write.table(data,file=paste("../data/ipc_2005_2014_coeficiente_confusion.csv",sep=""),row.names=FALSE,dec=".",sep=",",na="")
