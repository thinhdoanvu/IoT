datane = read.csv("C:/Users/Administrator/Desktop/R/R_shiny/IoT_Ver9/Login/data/admissions.csv",header = TRUE, sep = ",",) 
path_datarange<- setwd("C:/Users/Administrator/Desktop/R/R_shiny/IoT_Ver9/Login/")

library(scales)
library(dplyr)
library(plotly)
library(openssl)
library(shinydashboard)
library(shiny)
library(dplyr)
library(ggplot2)
library(stringr)
library(DT)
library(shinyBS)
library(shinyjs)
library(shinycssloaders)
options(spinner.color="#006272")

library(gmailr)

gm_auth_configure(path  = "data/SendMailR.json")
options(
  gargle_oauth_cache = ".secret",
  gargle_oauth_email = "itspider2022@gmail.com"
)
gm_auth(email = "itspider2022@gmail.com")


datane$Date <- as.Date(datane$Date,format="%d/%m/%Y")
#Giai thich: trong file csv minh ky hieu: 05/05/2021 <=> minh hieu la: D/M/Y
#Ep R hieu day la du lieu Date voi dinh dang: D/M/Y
#Tu do R se tra ve gia tri la: 2021-05-05 (Y-M-D)

datane_30 <- tail(datane,24) #30 line se bi lap du lieu o do thi trong TAB HOME
#Ly do: 1 ngay minh thu du lieu 24 lan. Neu lay so dong > so lan doc data se gay ra groups trong truc X
datane_top <- tail(datane,1)


#This is for Email
if(!file.exists("www/datarange.txt")){
  file.create("www/datarange.txt")
  write.table("itspider2018@gmail.com","www/datarange.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE )
  write.table(25,"www/datarange.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE)
  write.table(32,"www/datarange.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE)
  write.table(7,"www/datarange.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE)
  write.table(9.5,"www/datarange.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE)
  write.table(33,"www/datarange.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE)
}

#This is for Control Panel: history
if(!file.exists("www/log.txt")){
  file.create("www/log.txt")
  write.table(Sys.time(),"www/log.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE )#Time
  write.table("Lamp ON","www/log.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE)#bulb
  write.table("Humidity ON","www/log.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE)#humidity
  write.table("Pump ON","www/log.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE)#water
}

#Load 50 lines from log.txt
datalog = read.csv("C:/Users/Administrator/Desktop/R/R_shiny/IoT_Ver9/Login/www/log.txt",header = TRUE, sep = ",",)
log_top <- tail(datalog,50)

