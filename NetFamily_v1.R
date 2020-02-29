rm(list=ls())
library(igraph)
library(htmlwidgets)
library(networkD3)
library(netplot)
library(tidyverse)
library(stringi)
library(plyr)

#
NameData=read_lines(file='C:/Users/Tobal/Google Drive/Github/NepotismCL/Names.txt', )
NameData=parse_character(x=NameData, locale=locale(encoding='Latin1'))
NameData=stri_trans_general(NameData, "Latin-ASCII")

#
Pinera=NameData[grep(pattern='pinera', x=NameData, ignore.case=TRUE)]

Pinera=unlist(combn(x=Pinera, m=2, simplify=FALSE, FUN=function(x){paste0(x,' Rel ', collapse='')}))
Pinera=unlist(lapply(Pinera, FUN=function(x){
  substr(x=x, start=1, stop=nchar(x)-4)
  }))
Pinera=strsplit(x=Pinera, split=' ')
MaxCol=max(unlist(lapply(Pinera, length)))

AllDF=lapply(seq_along(Pinera), function(x){
  
  DF=data.frame('V1'=NA)
  for(i in 1:MaxCol){
    DF[,i]=NA
  }
  
  InputDF=as.data.frame(t(Pinera[[x]]))
  DF[,1:ncol(InputDF)]=InputDF
  DF
})
AllDF=suppressWarnings(bind_rows(AllDF))
AllDF

#Relationship


######################
adjm <- matrix(sample(0:1, 100, replace=TRUE, prob=c(0.9,0.1)), nc=10)
adjm
g1 <- graph_from_adjacency_matrix( adjm )
plot(g1)

########################
actors <- data.frame(name=c("Alice", "Bob", "Cecil", "David",
                            "Esmeralda"),
                     age=c(48,33,45,34,21),
                     gender=c("F","M","F","M","F"))
relations <- data.frame(from=c("Bob", "Cecil", "Cecil", "David",
                               "David", "Esmeralda"),
                        to=c("Alice", "Bob", "Alice", "Alice", "Bob", "Alice"),
                        same.dept=c(FALSE,FALSE,TRUE,FALSE,FALSE,TRUE),
                        friendship=c(4,5,5,2,1,1), advice=c(4,5,5,4,2,3))


relations[,1:2]

g <- graph_from_data_frame(d=relations[,1:2], directed=TRUE)
plot(g)

AllDF

TEMP=data.frame('from'=unlist(lapply(strsplit(Pinera, split=' Rel '), FUN=function(x){x[1]})),
'to'=unlist(lapply(strsplit(Pinera, split=' Rel '), FUN=function(x){x[2]})))
g <- graph_from_data_frame(d=TEMP, directed=TRUE)
plot(g)
install.packages('diagram')

################
################
library(diagram)
par(mar = c(1, 1, 1, 1), mfrow = c(2, 2))
#
#
names <- c("A", "B", "C", "D")
M <- matrix(nrow = 4, ncol = 4, byrow = TRUE, data = 0)
plotmat(M, pos = c(1, 2, 1), name = names, lwd = 1,
 box.lwd = 2, cex.txt = 0.8, box.size = 0.1,
 box.type = "square", box.prop = 0.5)
#
M[2, 1] <- M[3, 1] <- M[4, 2] <- M[4, 3] <- "flow"
plotmat(M, pos = c(1, 2, 1), curve = 0, name = names, lwd = 1,
 box.lwd = 2, cex.txt = 0.8, box.type = "circle", box.prop = 1.0)
#
#
diag(M) <- "self"
plotmat(M, pos = c(2, 2), curve = 0, name = names, lwd = 1, box.lwd = 2,
 cex.txt = 0.8, self.cex = 0.5, self.shiftx = c(-0.1, 0.1, -0.1, 0.1),
 box.type = "diamond", box.prop = 0.5)
M <- matrix(nrow = 4, ncol = 4, data = 0)
M[2, 1] <- 1 ; M[4, 2] <- 2 ; M[3, 4] <- 3 ; M[1, 3] <- 4
Col <- M
Col[] <- "black"
Col[4, 2] <- "darkred"
pp <- plotmat(M, pos = c(1, 2, 1), curve = 0.2, name = names, lwd = 1,
 box.lwd = 2, cex.txt = 0.8, arr.type = "triangle",
 box.size = 0.1, box.type = "hexa", box.prop = 0.25,
 arr.col = Col, arr.len = 1)
mtext(outer = TRUE, side = 3, line = -1.5, cex = 1.5, "plotmat")
#
par(mfrow = c(1, 1))

#
M

plotmat(M, box.type='square', box.size=0.1, box.prop=0.5, box.lwd=2, lwd=1)
