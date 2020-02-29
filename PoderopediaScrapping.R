#
rm(list=ls())
library(RSelenium)

#
setwd(gsub(pattern='Documents', replacement='Google Drive/Github/NepotismCL/', x=getwd()))

#Set up driver
RunDriver=paste("java -Dwebdriver.chrome.driver=C:/Users/",Sys.info()["user"],"/Documents/chromedriver.exe -jar C:/Users/",
  Sys.info()["user"],"/Documents/",
  list.files(path = paste("C:/Users/",Sys.info()["user"],"/Documents/", sep=""), 
    pattern = "selenium-server-standalone")
  ," -port 4444", sep="")
writeLines(text=RunDriver, con=paste0("C:/Users/",Sys.info()["user"],"/Documents/RunSelenium.bat"))
shell.exec(file=paste0("C:/Users/",Sys.info()["user"],"/Documents/RunSelenium.bat"))

#Open page
remDr=remoteDriver(browserName = "chrome") #mozilla, chrome
remDr$open()

#Go to poderopedia
remDr$navigate("http://www.poderopedia.org/cl/directorio/general/persona")

#Child letter number
ChildNumber=remDr$findElements(using="css selector", value="#service_persona > ul > li")
ChildNumber=unlist(sapply(ChildNumber, function(x){
  x$getElementText()
}))
names(ChildNumber)=1:length(ChildNumber)
ChildNumber=ChildNumber[tolower(ChildNumber) %in% letters]

#Create element
LetterSelector=paste0("#service_persona > ul > li:nth-child(",names(ChildNumber),") > a")
NameList=list()
for(i in 1:length(LetterSelector)){
  print(paste0('Woring on letter ', i,'/',length(LetterSelector)))  
  
  #Go to poderopedia
  remDr$navigate("http://www.poderopedia.org/cl/directorio/general/persona")
  
  #Wait, for safe
  Sys.sleep(2)
  
  #Go to letter
  LetterChoose=remDr$findElement(using="css selector", value=LetterSelector[i])
  LetterChoose$clickElement()
  
  #Wait, for safe
  Sys.sleep(2)
  
  #Names list, temporal inside loop
  TempNameList=list()
  
  #Scrap names
  NamesPerson=remDr$findElements(using="css selector", value="#service_persona > div.row-division.directorio.clearfix > ul")
  TempNameList=append(x=strsplit(x=unlist(NamesPerson[[1]]$getElementText()), split='\n'), values=TempNameList)
  
  #Whie loop
  StopVar='Siguiente'
  while(StopVar=='Siguiente'){
    
    #If there is no next, then make while stop
    StopVar=unlist(tryCatch({
      #Go to next and repeat
      Next=remDr$findElement(using="css selector", value="#mainaddpageservice_persona > a")
      Next$getElementText()
      
    },
      error=function(e){
        return('stop')
      },
      message=function(m){
        return('stop')
      }
    ))
    
    #If there is no next button, go back to letters
    if(StopVar=='Siguiente'){
      #Click next button
      Next$clickElement()
      
      #Waint, for safe
      Sys.sleep(2)
      
      #Scrap names
      NamesPerson=remDr$findElements(using="css selector", value="#service_persona > div.row-division.directorio.clearfix > ul")
      TempNameList=append(x=strsplit(x=unlist(NamesPerson[[1]]$getElementText()), split='\n'), values=TempNameList)
    }
  }
  
  #End scrapping
  NameList=append(x=unlist(TempNameList), values=NameList)
  
}
writeLines(text=unlist(NameList), con='Names.txt')
#
remDr$close()

