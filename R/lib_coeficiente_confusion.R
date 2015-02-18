#packages
PkgTest <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}


#preprocessing
FiltrarPeriodos<-function(periodos,fecha.min=NULL,fecha.max=NULL){
  ret<-rep(TRUE,length(periodos))
  if (!is.null(fecha.min))
    ret<-ret&periodos>=fecha.min
  if (!is.null(fecha.max))
    ret<-ret&periodos<=fecha.max
  ret
}

CambiarBase<-function(data,indicador,periodo.base,periodo.min,periodo.max){
  data[FiltrarPeriodos(data$periodo,periodo.min,periodo.max),indicador]/
  data[data$periodo==periodo.base,indicador]*100
}

Empalmar<-function(data,indicador.empalmado,indicador.empalme,
         periodo.empalme,periodo.min=periodo.empalme,periodo.max=periodo.empalme){
  data[FiltrarPeriodos(data$periodo,periodo.min,periodo.max),indicador.empalmado]*
    data[data$periodo==periodo.empalme,indicador.empalme]/
    data[data$periodo==periodo.empalme,indicador.empalmado]
}


#funcion para generar Indices con base anual
GetBaseAnual<-function(data,periodo,indicador,mes.base=12){
  anio<-as.numeric(data[data$periodo==periodo,"anio"])
  mes<-as.numeric(data[data$periodo==periodo,"mes"])
  anio.base<-anio+ifelse(mes<=as.numeric(mes.base),-1,0)
  periodo.base<-as.POSIXct(paste(anio.base,mes.base,"01",sep="/"))
  indicador.base<-data[data$periodo==periodo.base,indicador]
  ret<-data[data$periodo==periodo,indicador]/indicador.base*100
  if (length(ret)==0)
    ret<-NA
  ret
}



GetAcumuladoAnual<-function(data,periodo,indicador,mes.base=12){
  GetBaseAnual(data,periodo,indicador,mes.base)-100
}

ultimos.meses<-12
GrafIpcs<-function(ipc,indicadores){
  max.indice<-max(ipc[,c("IPC.INDEC","IPC.San.Luis")])
  min.indice<-min(ipc[,c("IPC.INDEC","IPC.San.Luis")])
  #empieza gráfico
  png(paste(export.dir,"ipc-indec-sanluis-variaciones.png",sep=""), height=report.heightPNG, width=report.widthPNG, bg="white")   
  par(mar=c(5, 4, 4, 8) + 0.1)
  par(new=FALSE)
  ind<-1
  plot(ipc$periodo,ipc$IPC.INDEC, type="l",col=indicadores[ind,]$color,xlab="Período",ylab="Indice",xaxt="n",lty=indicadores[ind,]$lty,lwd=indicadores[ind,]$lwd,ylim=c(min.indice,max.indice))
  axis(1,at=ipc[ultimos.meses,]$periodo,labels=format(ipc[ultimos.meses,]$periodo,"%m/%y"),las=2)
  for (periodo.act in ipc[ultimos.meses,]$periodo)
    segments(periodo.act,min.indice,periodo.act,max.indice,col="gray",lty = "solid",lwd=1)
  segments(comienzo.intervencion,min.indice,comienzo.intervencion,max.indice,col="red",lty = "dotted",lwd=2)
  par(new=TRUE)
  ind<-2
  plot(ipc$periodo,ipc$IPC.San.Luis, type="l",col=indicadores[ind,]$color,xaxt="n",yaxt="n",xlab="",ylab="",lty=indicadores[ind,]$lty,lwd=indicadores[ind,]$lwd)
  
  #Variaciones acumuladas anuales
  max.var.anual<-max(ipc[,c("IPC.INDEC.acumulado.anual","IPC.San.Luis.acumulado.anual")],na.rm = TRUE)
  min.var.anual<-min(ipc[,c("IPC.INDEC.acumulado.anual","IPC.San.Luis.acumulado.anual")],na.rm = TRUE)
  par(new=TRUE)
  ind<-3
  plot(ipc$periodo,ipc$IPC.INDEC.acumulado.anual, type="l",col=indicadores[ind,]$color,xaxt="n",yaxt="n",xlab="",ylab="",lwd=4,ylim=c(min.var.anual,max.var.anual),lty = indicadores[ind,]$lty)
  ticks.var.anual<-seq(from=round(min.var.anual,-1),to=round(max.var.anual,-1),length.out = 6)
  axis(side = 4,at=ticks.var.anual,labels=paste(ticks.var.anual,"%",sep=""))
  mtext("variación anual \n acumulada",padj = 0, side=4, line=3, cex.lab=1,
        las=3, col="black")
  par(new=TRUE)
  ind<-4
  plot(ipc$periodo,ipc$IPC.San.Luis.acumulado.anual, type="l",col=indicadores[ind,]$color,xaxt="n",yaxt="n",xlab="",ylab="",lwd=4,ylim=c(min.var.anual,max.var.anual),lty = indicadores[ind,]$lty)
  legend(ipc[1,]$periodo, max.var.anual,legend=indicadores$caption,col=indicadores$color,lty=indicadores$lty,lwd=4)
  title(paste("Evolución IPC y acumulados anuales. San Luis vs INDEC.\n Base Dic-2006=100. Oct/2005 - Dic/2014 "))
  dev.off()  
}

GrafCoeficienteConfusion<-function(ipc,colores.coeficiente.confusion){
  max.coefconfusion<-max(ipc[,c("coeficiente.confusion")],na.rm = TRUE)
  min.coefconfusion<-min(ipc[,c("coeficiente.confusion")],na.rm = TRUE)
  #empieza gráfico
  png(paste(export.dir,"ipc-indec-sanluis-coeficiente.confusion.png",sep=""), height=report.heightPNG, width=report.widthPNG, bg="white")   
  par(mar=c(5, 4, 4, 8) + 0.1)
  par(new=FALSE)
  ind<-1
  plot(ipc$periodo,ipc$coeficiente.confusion, type="l",col=colores.coeficiente.confusion[1],xlab="Período",ylab="Coeficiente confusion",xaxt="n",lty=indicadores[ind,]$lty,lwd=indicadores[ind,]$lwd,ylim=c(min.coefconfusion,max.coefconfusion))
  axis(1,at=ipc[ultimos.meses,]$periodo,labels=format(ipc[ultimos.meses,]$periodo,"%m/%y"),las=2)
  for (periodo.act in ipc[ultimos.meses,]$periodo)
    segments(periodo.act,min.coefconfusion,periodo.act,max.coefconfusion,col="gray",lty = "solid",lwd=1)
  segments(comienzo.intervencion,min.coefconfusion,comienzo.intervencion,max.coefconfusion,col="red",lty = "dotted",lwd=2)
  par(new=TRUE)
  plot(ipc$periodo,ipc$coeficiente.confusion.acumulado.anual, type="l",col=colores.coeficiente.confusion[2],xaxt="n",yaxt="n",xlab="",ylab="",lty=indicadores[ind,]$lty,lwd=indicadores[ind,]$lwd,ylim=c(min.coefconfusion,max.coefconfusion))
  
  legend(ipc[1,]$periodo,max.coefconfusion,legend=c("total","acumulado anual"),col=colores.coeficiente.confusion,lty=indicadores[c(1,2),]$lty,lwd=4)
  title(paste("Evolución de coeficiente de confusión (San Luis/INDEC).\n Acumulados anuales y total.\n Oct/2005 - Dic/2014"))
  dev.off()  
}
