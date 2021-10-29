#https://www.r-bloggers.com/copulas-and-financial-time-series/

rm(list=ls())

#Librerias
library(xlsx)
library(fGarch)
library(mgarchBEKK)
library(vars)
library(mgarch)



#Cargo los datos
diario=read.xlsx("C:/Users/lcaravaggio_mecon/Desktop/Doctorado/Lanac/datos.xls",sheetName="datos",dec=",")
# Salida de la Convertibilidad: 2572 (15 de Febrero de 2002)
# Inicio cepo cambiario: 6117 (31 de octubre de 2011)
# Salida del cepo cambiario: 7624 (16 de diciembre de 2015)
# Fin de muestra: 8521 (31 de Mayo de 2018)
diario <- diario[2572:8521,]

Time=as.Date(diario$fecha,"%Y-%m-%d")

diario$NA.=NULL
diario$dec=NULL

# ENDÓGENAS
#8 Dólar
#9 Dólar Blue
#11 Euro
#13 Euro Blue

#17 WSJ
#18 FAZ
#19 La Nación
#21 Ámbito

end<-cbind(diario[,13],diario[,21],diario[,18])
exo<-cbind(diario[,15],diario[,16])

#Corro el VAR
modelo <- VAR(end,p=1,type = c("const","trend", "both", "none"),season = NULL, exogen = exo, lag.max = NULL,ic = c("AIC", "HQ", "SC", "FPE"))

restrict <- matrix(c(1, 1, 1, 1, 1, 1 , 
                     0, 1, 0, 1, 0, 0 ,
                     0, 0, 1, 1, 0, 0),
                   nrow=3, ncol=6, byrow=TRUE)
modelo2 <- restrict(modelo, method = "man", resmat = restrict)
summary(modelo2)

#Corro el BEKK
ep <- data.frame(resid(modelo2))
est=mvBEKK.est(ep,order=c(1,1),fixed=array(c(10, 0, 12, 0, 13, 0, 14, 0, 19, 0, 21, 0, 22, 0, 23, 0), dim=c(2,24)),method = "BFGS",verbose=F)
mvBEKK.diag(est)

Box.test(ep[1],lag=1,type="Ljung-Box",fitdf=0)
Box.test(ep[2],lag=1,type="Ljung-Box",fitdf=0)
Box.test(ep[3],lag=1,type="Ljung-Box",fitdf=0)

plot(diario$fecha, diario$ambito)