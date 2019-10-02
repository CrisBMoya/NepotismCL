library(GGally)
library(ggnet)
library(network)
library(sna)
library(ggplot2)


# random graph
net = rgraph(10, mode = "graph", tprob = 0.5)
net=net[,1:3]
rowSums(x=net)

Values=c(0,0,1,2)
netMat=matrix(Values, nrow=length(Values)/2)
rownames(netMat)=letters[1:(length(Values)/2)]
netMat
net = network(netMat, directed=TRUE)

# vertex names
network.vertex.names(net) = rownames(netMat)

ggnet2(net, label=TRUE,  arrow.size = 12, arrow.gap = 0.025)

#########
library(igraph)

mothers=familyTree[,c('id','id_mother','first_name', 'last_name')]
fathers=familyTree[,c('id','id_father','first_name', 'last_name')]
mothers$name=paste(mothers$first_name,mothers$last_name)
fathers$name=paste(fathers$first_name,fathers$last_name)
names(mothers)=c('parent','id','first_name','last_name','name')
names(fathers)=c('parent','id','first_name','last_name','name')
links=rbind(mothers,fathers)
links=links[!is.na(links$id),]
g=graph.data.frame(netMat)
co=layout.reingold.tilford(g, flip.y=F)
plot(g,layout=co)
netMat

#
DF=read.table(file="clipboard", header=TRUE, sep='\t')
DF
g=graph.data.frame(d=DF)
co=layout.reingold.tilford(g, flip.y=F)
plot(g,layout=co)
?graph.data.frame


actors <- data.frame(name=c("Alice", "Bob", "Cecil", "David",
                            "Esmeralda"),
                     age=c(48,33,45,34,21),
                     gender=c("F","M","F","M","F"))
relations <- data.frame(from=c("Bob", "Cecil", "Cecil", "David",
                               "David", "Esmeralda"),
                        to=c("Alice", "Bob", "Alice", "Alice", "Bob", "Alice"),
                        same.dept=c(FALSE,FALSE,TRUE,FALSE,FALSE,TRUE),
                        friendship=c(4,5,5,2,1,1), advice=c(4,5,5,4,2,3))
g <- graph_from_data_frame(relations, directed=TRUE, vertices=actors)
co=layout.auto(g)
plot(g,layout=co)

#
DF=read.table(file="clipboard", header=TRUE, sep='\t')
DF
g=graph.data.frame(d=DF)
co=layout.kamada.kawai(g)
plot(g,layout=co)

