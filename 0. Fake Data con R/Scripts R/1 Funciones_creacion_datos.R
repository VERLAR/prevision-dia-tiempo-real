#Cargar librerías siempre. Si no están isntaladas usar primero install.packages("nombreLibreria")
#(seguramente la primera vez y nunca más) y luego library("nombreLibreria")

library("polynom") #install.packages("polynom")
library("lavaan")
library('mixtools')
library("forecast")
library("tseries")
library("ggplot2")
library("dlm")
library("XML")
library("zoo")
library("xts")
library("fts")
library("tseries")
library("tis")
library("stats")
library("timeDate")
library("chron")
library("lubridate") 
library("openair")
library("KFAS")
library("lattice")
library("grid")
library("iClick")
library("dplyr")
library("rvest")
library("readr")
library("utils")

######################### CARGAR MODELOS POLINOMICOS DE LOS DIAS (REGRESIONES POLINOMICAS)###################
############################X<- HORA DEL DIA; Y<-VOLUMEN VENTAS (EUROS)######################################

##########################MODELO LUNES#######################################################################
modelo_poli_LUNES<-polynomial(c(9661.918 ,  67450.277, -117071.108 , -76755.208  ,  3893.312 , -57901.221,
                     -37708.624 ,  71855.779)) # Grado 0 a grado 7
modelo_poli_LUNES<-as.function(modelo_poli_LUNES) #hacerlo funcion


#########################MODELO MARTES#######################################################################
modelo_poli_Martes<-polynomial(c(8777,50096,-112312,-65509,12269,-51613,-44178,64711)) 
modelo_poli_Martes<-as.function(modelo_poli_Martes) 


#########################MODELO MIERCOLES#######################################################################
modelo_poli_Miercoles<-polynomial(c(8554.216,54039.564,-100973.684,-64745.406,12270.641,-50159.551,-38394.313,61898.142)) 
modelo_poli_Miercoles<-as.function(modelo_poli_Miercoles) 


#########################MODELO JUEVES#######################################################################
modelo_poli_Jueves<-polynomial(c(8568.122,50715.967,-117662.442,-63026.584,17423.574,-47468.077,-36817.887,65462.559)) 
modelo_poli_Jueves<-as.function(modelo_poli_Jueves) 


#########################MODELO VIERNES#######################################################################
modelo_poli_Viernes<-polynomial(c(11000.96,61000.80,-163353.52,-86308.08,16827.40,-62110.59,-41184.00,89236.49)) 
modelo_poli_Viernes<-as.function(modelo_poli_Viernes) 


#########################MODELO SABADO#######################################################################
modelo_poli_Sabado<-polynomial(c(13616.70,48417.32,-198669.12,-101125.22,74295.36,-67670.05,-113944.54,65710.47)) 
modelo_poli_Sabado<-as.function(modelo_poli_Sabado) 


#########################MODELO DOMINGO#######################################################################
modelo_poli_Domingo<-polynomial(c(607.8744,-1050.8554,-9613.3653,-2247.0703,5978.7437,-807.8674,-5821.5798,1620.7701)) 
modelo_poli_Domingo<-as.function(modelo_poli_Domingo) 


#########################MODELO Enero1#######################################################################
modelo_poli_Enero1<-polynomial(c(76.91196,434.26976,-331.91921,-438.66602,-64.00077,-62.96998,-53.83809,153.79254)) 
modelo_poli_Enero1<-as.function(modelo_poli_Enero1) 


#########################MODELO Diciembre24#######################################################################
modelo_poli_Diciembre24<-polynomial(c(23049.13,-124352.52,-391719.20,-48981.10,303394.38,-61837.39,-160648.63,112453.02)) 
modelo_poli_Diciembre24<-as.function(modelo_poli_Diciembre24) 


#####################CARGAR MODELO DE LA DISTRIBUCIÓN DEL TIEMPO A LO LARGO DEL DIA##############################
#####MODELO BIMODAL: FUNCIÓN DENSIDAD f(t1,t2)=f(t1)f(t2) cada una una función de densidad NORMAL o GAUSIANA#####
#Idea: dos campanas de gaus de media y desviación típica, distintas o iguales, puestas una a continuación de la otra 
#"dos jorobas" o equivalentemente dos valores cuya moda es superior y el resto de datos se distribuyen en torno a ellos

#indicar la dirección donde se guardan los archivos con los parámetros

setwd("C:/Users/alberto.irusta/Desktop/Deusto Generacion Historico/0 - Modelos (a cargar)")

load(file="LunesOrdinalModeloTIEMPOS.R")
load(file="MartesOrdinalModeloTIEMPOS.R")
load(file="MiercolesOrdinalModeloTIEMPOS.R")
load(file="JuevesOrdinalModeloTIEMPOS.R")
load(file="ViernesOrdinalModeloTIEMPOS.R")
load(file="SabadoOrdinalModeloTIEMPOS.R")
load(file="DomingoOrdinalModeloTIEMPOS.R")
load(file="FestivosModeloTIEMPOS.R")
load(file="NavidadTIEMPOS.R")

###################################################################################################################
#############FUNCION QUE GENERA EL HISTORICO DE MOVIMIENTOS DE VENTAS EN UN PERIODO, POR EJEMPLO UN AÑO############
###################################################################################################################


Simulacion_Historico_movimientos_Ventas<-function(FechaInicio,FechaFin){
  
  ###########################crear tabla con calendario, dia y mes##################################
  date.form = "%Y-%m-%d"
  if (class(FechaInicio) == "character" | class(FechaInicio) == "factor" ) {
    FechaInicio <- strptime(FechaInicio, date.form)
  }
  if (class(FechaFin) == "character" | class(FechaFin) == "factor" ) {
    FechaFin <- strptime(FechaFin, date.form)
  }
  
  dates.f <- data.frame(date.seq = seq(FechaInicio, FechaFin, by="days"))
  
  dtFechaB = (gsub("-","",dates.f$date.seq))
  day=paste(substr(dtFechaB,7,8),"/",sep="")
  month=paste(day,substr(dtFechaB,5,6),sep="")
  year=paste("/",substr(dtFechaB,1,4),sep="")
  final<-paste(month,year,sep="")
  FechaFinal = as.Date(final, '%d/%m/%Y')
  Fecha <- as.Date(FechaFinal,format="%d-%m-%Y")
  temp.xts <- xts(FechaFinal,order.by=Fecha)
  dates.f$nameDay<-weekdays(index(temp.xts))
  #print(dates.f)
  ##################################################################################################
  
  ####rellenar el dataframe con el volumen de ventas total del dia y usando los modelos según el dia del calendario##
  BBDD<-data.frame(row.names = c("date","ticketDate","amount"))
  for (i in 1:dim(dates.f)[1]){
    
    #FESTIVOS
    
    if (substr(Fecha[i],6,10)=="01-01" | substr(Fecha[i],6,10)=="01-06" | substr(Fecha[i],6,10)=="03-19" |
        substr(Fecha[i],6,10)=="04-28" | substr(Fecha[i],6,10)=="05-15" | substr(Fecha[i],6,10)=="07-25" | 
        substr(Fecha[i],6,10)=="08-15" | substr(Fecha[i],6,10)=="10-12" | substr(Fecha[i],6,10)=="11-01" | 
        substr(Fecha[i],6,10)=="12-06" | substr(Fecha[i],6,10)=="12-08" | substr(Fecha[i],6,10)=="12-25" | 
        substr(Fecha[i],6,10)=="12-26" |
        as.character(  PalmSunday(year = as.numeric(substr(Fecha[i],1,4))) )==Fecha[i] |
        as.character(  GoodFriday(year = as.numeric(substr(Fecha[i],1,4))) )==Fecha[i] |
        as.character(  EasterSunday(year = as.numeric(substr(Fecha[i],1,4))) )==Fecha[i] |
        as.character(  EasterMonday(year = as.numeric(substr(Fecha[i],1,4))) )==Fecha[i]  ){
      
      #####Generacion de tiempos el Enero1
      x<-unique(round(rnormmix(runif(1,820,880),probsEnero1,mEnero1,sEnero1),2))#bimodal y quitando repetidos
      x<-x[x>0 & x<23.59 & x%%1<0.59]
      #hist(x)
      
      #####Generacion de amount el Enero1
      TiempoEnero1 <- data.frame(x = x )
      valores<-modelo_poli_Enero1(TiempoEnero1$x)
      values<-valores+rnorm(length(x),mean=-50,sd=50)#añado ruido
      #plot(x,values)
      #elimino negativos y los pongo con numero euros bajo
      correcion<-which(values<=0 & TiempoEnero1$x<=8)
      correcionx<-x[correcion]
      correcionValue<-abs(rnorm(length(correcionx),20,5))
      
      selec<-which(values>0 & TiempoEnero1$x>8)
      selecx<-x[selec]
      selecxValue<-values[selec]
      #plot(c(selecx,correcionx),c(selecxValue, correcionValue))
      
      BBDD<-rbind(BBDD,
                  arrange(data.frame(date= rep(Fecha[i],length(c(selecx,correcionx)) ) ,
                                     ticketDate=   c(selecx,correcionx) ,
                                     amount=round(c(selecxValue, correcionValue),2)),ticketDate))
      
    } else {
      
      
      if(substr(Fecha[i],6,10)=="12-22" | substr(Fecha[i],6,10)=="12-24" | substr(Fecha[i],6,10)=="12-31" ){
        x<-unique(round(rnormmix(runif(1,800,950),probsDiciembre24,mDiciembre24,sDiciembre24),2))#bimodal y quitando repetidos
        x<-x[x>0 & x<23.59 & x%%1<0.6]
        #hist(x)
        
        #####Generacion de amount el Diciembre24
        TiempoDiciembre24 <- data.frame(x = x )
        valores<-modelo_poli_Diciembre24(TiempoDiciembre24$x)
        values<-valores+rnorm(length(x),mean=-10000,sd=5000)#añado ruido
        #plot(x,values)
        #elimino negativos y los pongo con numero euros bajo
        correcion<-which(values<=0 & TiempoDiciembre24$x<=8)
        correcionx<-x[correcion]
        correcionValue<-abs(rnorm(length(correcionx),20,5))
        
        selec<-which(values>0 & TiempoDiciembre24$x>8)
        selecx<-x[selec]
        selecxValue<-values[selec]
        #plot(c(selecx,correcionx),c(selecxValue, correcionValue))
        
        BBDD<-rbind(BBDD,
                    arrange(data.frame(date= rep(Fecha[i],length(c(selecx,correcionx)) ) ,
                                       ticketDate=   c(selecx,correcionx) ,
                                       amount=round(c(selecxValue, correcionValue),2)),ticketDate))
        
        
      } else{
        
        
        if(dates.f$nameDay[i]=="lunes"){
          #####Generacion de tiempos el Lunes
          x<-unique(round(rnormmix(runif(1,1000,1050),probsLunes,mLunes,sLunes),2))#bimodal y quitando repetidos
          x<-x[x>0 & x<23.59 & x%%1<0.6]
          #hist(x)
          
          #####Generacion de amount el Lunes
          TiempoLunes <- data.frame(x = x )
          valores<-modelo_poli_LUNES(TiempoLunes$x)
          values<-valores+rnorm(length(x),mean=runif(1,0,400),sd=runif(1,1,100) )#añado ruido
          #plot(x,values)
          #elimino negativos y los pongo con numero euros bajo
          correcion<-which(values<=0 & TiempoLunes$x<=8)
          correcionx<-x[correcion]
          correcionValue<-abs(rnorm(length(correcionx),20,5))
          
          selec<-which(values>0 & TiempoLunes$x>8)
          selecx<-x[selec]
          selecxValue<-values[selec]
          #plot(c(selecx,correcionx),c(selecxValue, correcionValue))
          
          BBDD<-rbind(BBDD,
                      arrange(data.frame(date= rep(Fecha[i],length(c(selecx,correcionx)) ) ,
                                         ticketDate=   c(selecx,correcionx) ,
                                         amount=round(c(selecxValue, correcionValue),2)),ticketDate))
          
          
        }
        
        
        if(dates.f$nameDay[i]=="martes"){
          #####Generacion de tiempos el Martes
          x<-unique(round(rnormmix(runif(1,850,1050),probsMartes,mMartes,sMartes),2))#bimodal y quitando repetidos
          x<-x[x>0 & x<23.59 & x%%1<0.6]
          #hist(x)
          
          #####Generacion de amount el Martes
          TiempoMartes <- data.frame(x = x )
          valores<-modelo_poli_Martes(TiempoMartes$x)
          values<-valores+rnorm(length(x),mean=runif(1,0,200),sd=runif(1,1,100) )#añado ruido
          #plot(x,values)
          #elimino negativos y los pongo con numero euros bajo
          correcion<-which(values<=0 & TiempoMartes$x<=8)
          correcionx<-x[correcion]
          correcionValue<-abs(rnorm(length(correcionx),20,5))
          
          selec<-which(values>0 & TiempoMartes$x>8)
          selecx<-x[selec]
          selecxValue<-values[selec]
          #plot(c(selecx,correcionx),c(selecxValue, correcionValue))
          
          BBDD<-rbind(BBDD,
                      arrange(data.frame(date= rep(Fecha[i],length(c(selecx,correcionx)) ) ,
                                         ticketDate=   c(selecx,correcionx) ,
                                         amount=round(c(selecxValue, correcionValue),2)),ticketDate))
          
        }
        
        
        if(dates.f$nameDay[i]=="miércoles"){
          #####Generacion de tiempos el Miercoles
          x<-unique(round(rnormmix(runif(1,850,1000),probsMiercoles,mMiercoles,sMiercoles),2))#bimodal y quitando repetidos
          x<-x[x>0 & x<23.59 & x%%1<0.6]
          #hist(x)
          
          #####Generacion de amount el Miercoles
          TiempoMiercoles <- data.frame(x = x )
          valores<-modelo_poli_Miercoles(TiempoMiercoles$x)
          values<-valores+rnorm(length(x),mean=runif(1,0,200),sd=runif(1,1,100) )#añado ruido
          #plot(x,values)
          #elimino negativos y los pongo con numero euros bajo
          correcion<-which(values<=0 & TiempoMiercoles$x<=8)
          correcionx<-x[correcion]
          correcionValue<-abs(rnorm(length(correcionx),20,5))
          
          selec<-which(values>0 & TiempoMiercoles$x>8)
          selecx<-x[selec]
          selecxValue<-values[selec]
          #plot(c(selecx,correcionx),c(selecxValue, correcionValue))
          
          BBDD<-rbind(BBDD,
                      arrange(data.frame(date= rep(Fecha[i],length(c(selecx,correcionx)) ) ,
                                         ticketDate=   c(selecx,correcionx) ,
                                         amount=round(c(selecxValue, correcionValue),2)),ticketDate))
          
        }
        
        
        if(dates.f$nameDay[i]=="jueves"){
          #####Generacion de tiempos el Jueves
          x<-unique(round(rnormmix(runif(1,850,1050),probsJueves,mJueves,sJueves),2))#bimodal y quitando repetidos
          x<-x[x>0 & x<23.59 & x%%1<0.6]
          #hist(x)
          
          #####Generacion de amount el Jueves
          TiempoJueves <- data.frame(x = x )
          valores<-modelo_poli_Jueves(TiempoJueves$x)
          values<-valores+rnorm(length(x),mean=runif(1,0,200),sd=runif(1,1,100) )#añado ruido
          #plot(x,values)
          #elimino negativos y los pongo con numero euros bajo
          correcion<-which(values<=0 & TiempoJueves$x<=8)
          correcionx<-x[correcion]
          correcionValue<-abs(rnorm(length(correcionx),20,5))
          
          selec<-which(values>0 & TiempoJueves$x>8)
          selecx<-x[selec]
          selecxValue<-values[selec]
          #plot(c(selecx,correcionx),c(selecxValue, correcionValue))
          
          BBDD<-rbind(BBDD,
                      arrange(data.frame(date= rep(Fecha[i],length(c(selecx,correcionx)) ) ,
                                         ticketDate=   c(selecx,correcionx) ,
                                         amount=round(c(selecxValue, correcionValue),2)),ticketDate))
          
        }
        
        
        if(dates.f$nameDay[i]=="viernes"){
          #####Generacion de tiempos el Viernes
          x<-unique(round(rnormmix(runif(1,1000,1100),probsViernes,mViernes,sViernes),2))#bimodal y quitando repetidos
          x<-x[x>0 & x<23.59 & x%%1<0.6]
          #hist(x)
          
          #####Generacion de amount el Viernes
          TiempoViernes <- data.frame(x = x )
          valores<-modelo_poli_Viernes(TiempoViernes$x)
          values<-valores+rnorm(length(x),mean=500,sd=500)#añado ruido
          #plot(x,values)
          #elimino negativos y los pongo con numero euros bajo
          correcion<-which(values<=0 & TiempoViernes$x<=8)
          correcionx<-x[correcion]
          correcionValue<-abs(rnorm(length(correcionx),20,5))
          
          selec<-which(values>0 & TiempoViernes$x>8)
          selecx<-x[selec]
          selecxValue<-values[selec]
          #plot(c(selecx,correcionx),c(selecxValue, correcionValue))
          
          BBDD<-rbind(BBDD,
                      arrange(data.frame(date= rep(Fecha[i],length(c(selecx,correcionx)) ) ,
                                         ticketDate=   c(selecx,correcionx) ,
                                         amount=round(c(selecxValue, correcionValue),2)),ticketDate))
          
        }
        
        
        if(dates.f$nameDay[i]=="sábado"){
          #####Generacion de tiempos el Sabado
          x<-unique(round(rnormmix(runif(1,1000,1100),probsSabado,mSabado,sSabado),2))#bimodal y quitando repetidos
          x<-x[x>0 & x<23.59 & x%%1<0.6]
          #hist(x)
          
          #####Generacion de amount el Sabado
          TiempoSabado <- data.frame(x = x )
          valores<-modelo_poli_Sabado(TiempoSabado$x)
          values<-valores+rnorm(length(x),mean=500,sd=500)#añado ruido
          #plot(x,values)
          #elimino negativos y los pongo con numero euros bajo
          correcion<-which(values<=0 & TiempoSabado$x<=8)
          correcionx<-x[correcion]
          correcionValue<-abs(rnorm(length(correcionx),20,5))
          
          selec<-which(values>0 & TiempoSabado$x>8)
          selecx<-x[selec]
          selecxValue<-values[selec]
          #plot(c(selecx,correcionx),c(selecxValue, correcionValue))
          
          BBDD<-rbind(BBDD,
                      arrange(data.frame(date= rep(Fecha[i],length(c(selecx,correcionx)) ) ,
                                         ticketDate=   c(selecx,correcionx) ,
                                         amount=round(c(selecxValue, correcionValue),2)),ticketDate))
          
        }
        
        
        if(dates.f$nameDay[i]=="domingo"){
          #####Generacion de tiempos el Domingo
          x<-unique(round(rnormmix(runif(1,900,1000),probsDomingo,mDomingo,sDomingo),2))#bimodal y quitando repetidos
          x<-x[x>0 & x<23.59 & x%%1<0.6]
          #hist(x)
          
          #####Generacion de amount el Domingo
          TiempoDomingo <- data.frame(x = x )
          valores<-modelo_poli_Domingo(TiempoDomingo$x)
          values<-valores+rnorm(length(x),mean=0,sd=20)#añado ruido
          #plot(x,values)
          #elimino negativos y los pongo con numero euros bajo
          correcion<-which(values<=0 & TiempoDomingo$x<=8)
          correcionx<-x[correcion]
          correcionValue<-abs(rnorm(length(correcionx),20,5))
          
          selec<-which(values>0 & TiempoDomingo$x>8)
          selecx<-x[selec]
          selecxValue<-values[selec]
          #plot(c(selecx,correcionx),c(selecxValue, correcionValue))
          
          BBDD<-rbind(BBDD,
                      arrange(data.frame(date= rep(Fecha[i],length(c(selecx,correcionx)) ) ,
                                         ticketDate=   c(selecx,correcionx) ,
                                         amount=round(c(selecxValue, correcionValue),2)),ticketDate))
          
        }
      }
    }
    
  }
  
  ##############con todo el data frame, le refinamos algunos detalles, para ponerle en la forma que se busca#######
  ############# "ticketdate<-aaaa-mm-dd HH:MM:00"  "amount<-1900.29"
  
  
  BBDD<-na.omit(BBDD)
  BBDD$ticketDate<-paste(BBDD$date,BBDD$ticketDate ,sep=" ")
  BBDD<-BBDD[,-1]
  
  BBDD$ticketDate<-paste(gsub("[:.:]",":",as.character(BBDD$ticketDate) ),":00",sep="")
  
  BBDD$ticketDate[which(substr(BBDD$ticketDate,13,13)==":")]=gsub(" "," 0",BBDD$ticketDate[which(substr(BBDD$ticketDate,13,13)==":")])
  BBDD$ticketDate[which(substr(BBDD$ticketDate,16,16)==":")]=gsub(":00","0:00",BBDD$ticketDate[which(substr(BBDD$ticketDate,16,16)==":")])
  BBDD$ticketDate[which(substr(BBDD$ticketDate,15,16)=="00")]=paste(BBDD$ticketDate[which(substr(BBDD$ticketDate,15,16)=="00")],":00",sep="")
  BBDD<-BBDD[-(which(substr(BBDD$ticketDate,15,16)=="60")),]
  
  ##################################################################################################################
  ################# LO VAMOS A GUARDAR EN UN DIRECTORIO, PONER EL QUE SE QUIERA#####################################
  ##################################################################################################################
  rutaHistorico<-"C:/Users/alberto.irusta/Desktop/Deusto Generacion Historico/1 - Creacion Historico/"
  setwd(rutaHistorico)
  ##################################################################################################################
  dir.create(paste(rutaHistorico,"/","Simulación_datos_",as.character(FechaInicio),"_",as.character(FechaFin),sep=""),showWarnings=FALSE)
  setwd(paste(rutaHistorico,"/","Simulación_datos_",as.character(FechaInicio),"_",as.character(FechaFin),sep=""))
  write.table(BBDD, file=paste("TXT_Simulación_datos_",as.character(FechaInicio),"_",as.character(FechaFin),".txt",sep = ""),row.names=F,sep = ",")
}

####EJEMPLO#####
#Simulacion_Historico_movimientos_Ventas("2019-01-01","2019-12-31")



########################################PARA VER LA "FORMA" DE LOS DATOS SE PUEDE CREAR ######################
######################################## DE FORMA AUXILIAR UN  MAPA DE CALOR #################################
######################################## PARA VER LA DISTRIBUCION DE LAS VENTAS POR DIA EN TOTAL##############

MapaCalorAnual(año,direccionHistoricoAnual){
  
  #######################################################################################################
  BBDD<- read_csv(direccionHistoricoAnual)
  
  #########IMPORTANTE!!!!!!!!!! SE NECESITA TENER EL ARCHIVO calendar - copia.R EN LA DIRECCION SIGUIENTE
  setwd("C:/Users/alberto.irusta/Desktop/Deusto Generacion Historico/")

  BBDD<-na.omit(BBDD)
  Dias<-(substr(gsub(" ","",gsub("/","-",BBDD$ticketDate)),1,10))
  BBDD$Dias<-Dias
  AgruparDias<-unique(Dias)
  VolumenEurosVentasDia<-rep(0,(length(AgruparDias)))
  for (i in 1:length(AgruparDias)){
    seleccion<-filter(BBDD,BBDD$Dias %in% AgruparDias[i])
    VolumenEurosVentasDia[i]<-sum(as.numeric(seleccion$amount))
  }
  dt<-data.frame(Fecha=AgruparDias,VentasEurosDia=VolumenEurosVentasDia)
  
  dtFechaB = (gsub("-","",dt$Fecha))
  day=paste(substr(dtFechaB,7,8),"/",sep="")
  month=paste(day,substr(dtFechaB,5,6),sep="")
  year=paste("/",substr(dtFechaB,1,4),sep="")
  final<-paste(month,year,sep="")
  FechaFinal = as.Date(final, '%d/%m/%Y')
  Fecha <- as.Date(FechaFinal,format="%d-%m-%Y")
  temp.xts <- xts(FechaFinal,order.by=Fecha)
  dt$dia<-weekdays(index(temp.xts))
  dt$mes<-months(index(temp.xts))
  dt$año<-year(index(temp.xts))
  datoscont<-dt
  datoscont$date<-FechaFinal
  datoscont<-cutData(datoscont, type="season")
  temp.zoo <- zoo(datoscont[,2],order.by=Fecha)
  temp.xts <- xts(datoscont[,2],order.by=Fecha)
  source("calendar - copia.R")
  calendarHeat(dates=as.Date(index(temp.zoo)),
               values=coredata(temp.zoo),
               color="r2b")
}

#EJEMPLO
MapaCalorAnual("2019",
               "C:/Users/alberto.irusta/Desktop/Deusto Generacion Historico/1 - Creacion Historico/Simulación_datos_2019-01-01_2019-12-31/TXT_Simulación_datos_2019-01-01_2019-12-31.txt")






###################AHORA SE DESGLOSA EN TICKETS LA INFORMACIÓN CREADA ANTERIORMENTE################################
#######¿COMO? GENERANDO A PARTIR DE LOS VALORES ANTERIORES (DATE,AMOUNT) UNA SECUENCIA DE NÚMEROS##################
####### QUE SUMEN TAL CANTIDAD#####################################################################################
######DEBIDO A LA CANTIDAD DE DATOS QUE SE GENERAN SE HACE AL DIA##################################################

Desglose_Tickets<-function(date){
  
  #####################Introducir el directorio donde se guarda el txt del historico, por ejemplo anual,##########
  #####################donde se encuentra el dia que se introduce como argumento##################################
  #####################y se lee dicho fichero#####################################################################
  setwd<-paste(c("C:/Users/alberto.irusta/Desktop/Deusto Generacion Historico/1 - Creacion Historico/Simulación_datos_",substr(date,1,4),"-01-01_",substr(date,1,4),"-12-31/"),sep="")
  Historico <- read_csv(paste("C:/Users/alberto.irusta/Desktop/Deusto Generacion Historico/1 - Creacion Historico/Simulación_datos_",substr(date,1,4),"-01-01_",substr(date,1,4),"-12-31/TXT_Simulación_datos_",substr(date,1,4),"-01-01_",substr(date,1,4),"-12-31.txt",sep="")) 
  Selection<-filter(Historico, substr(Historico$ticketDate,1,10) ==date)
  fechas=length(Selection$ticketDate)
  
  ####################se crea una barra de carga para ver la velocidad de creación y con el fin de ver si#########
  #################### no se bloquea el ordenador#################################################################
  pb <- tkProgressBar(title = "progress bar", min = 0,
                      max = fechas, width = 300)
  
  ###################Se crea el conjunto vacio de datos y se le van añadiendo los tickets#########################
  BBDDTickets <- data.frame(ticketDate=character(),
                            amount=numeric(), 
                            stringsAsFactors=FALSE) 
  
  for (i in 1: fechas){
    
    ticketDate<-Selection$ticketDate[i]
    amount<-Selection$amount[i]
    
          ############particion=numero de tickets a generar en funcion de la cantidad de dicha hora########
    if (amount>0 & amount <=100){particion<-1}
    if (amount<=1000 & amount>100){particion<-floor(runif(1,1,10))}   
    if (amount>1000 & amount <=10000) {particion<-floor(runif(1,10,100))} 
    if (amount>10000) {particion<-floor(runif(1,100,1000))}
    if (amount>10000 & amount <=100000) {particion<-runif(1,100,1000)} 
    if (amount >100000) {particion<-runif(1,1000,10000)} 
    
    ############generacion de las cantidades que sumen la amount del historico########    
    x<-runif(particion)
    x.new <- x*amount/sum(x)
    
    BBDDTicketsMIN <- data.frame(ticketDate=rep(substr(ticketDate,1,19),length(x.new)),
                                 amount=round(x.new,2), 
                                 stringsAsFactors=FALSE) 
    
    #Insercion de datos
    BBDDTickets<-rbind(BBDDTickets, BBDDTicketsMIN)
    
    #actualizacion de la barra de carga
    setTkProgressBar(pb, i, label=paste( round(i/fechas*100, 0),
                                         "% done"))
    
  }
  
  ################################################################################################################
  ############ruta donde se van a guardar los tickets del dia elegido#############################################
  ################################################################################################################
  
  rutaTickets<-"C:/Users/alberto.irusta/Desktop/Deusto Generacion Historico/2 - Creacion de Tickets tiempo real/"
  setwd(rutaTickets)
  
  dir.create(paste(rutaTickets,"/","Simulación_Tickets_",as.character(date),sep=""),showWarnings=FALSE)
  setwd(paste(rutaTickets,"/","Simulación_Tickets_",as.character(date),sep=""))
  write.table(BBDDTickets, file=paste("TXT_Simulación_TICKETS_",as.character(date),".txt",sep=""),row.names=F,sep = ",")
  
  close(pb)
  return(BBDDTickets) #lo devolvemos por que es necesario a futuro (llamar a otra funcion que requiere este valor)
}

#EJEMPLO
Desglose_Tickets("2019-12-15")


