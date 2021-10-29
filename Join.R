rm(list=ls())

la1 <- read_delim("C:/data/lanacionecon1.csv", ";", escape_double = FALSE, col_names = FALSE, locale = locale(), trim_ws = TRUE)
la2 <- read_delim("C:/data/lanacionecon2.csv", ";", escape_double = FALSE, col_names = FALSE, locale = locale(), trim_ws = TRUE)
la3 <- read_delim("C:/data/lanacionecon3.csv", ";", escape_double = FALSE, col_names = FALSE, locale = locale(), trim_ws = TRUE)
lanacion <- rbind (la1,la2,la3)

write.csv2(lanacion, file = "C:/data/lanacionecon.csv",row.names=FALSE, sep=";" , fileEncoding="UTF-8")

