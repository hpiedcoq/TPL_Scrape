#For each page we grab the links to the pdf documents as a Rlist of x element.
while(!testCon()){
  print('internet est Down, on fait une pause de 5s') 
  Sys.sleep(5)
}
url_pdf <- remDr$findElements(using = "xpath", ".//*[@class='file-details btn-default trsp-btn']")
url_pdf_temp <- url_pdf
#We count the number of files to be downloaded on this page
plist <- length(url_pdf)
dataFile <- list()
title_temp <- list()
language_temp <- list()

#we start a loop to get the url ans the metadata for each files.
urlpdfloop <- 1
metadataFile <- data.frame(matrix(ncol=0,nrow=0))
urlList <- data.frame(matrix(ncol=0,nrow=0))
title <- data.frame(matrix(ncol=1,nrow=0))
colnames(title) <- c('Titre')
langue <- data.frame(matrix(ncol=1,nrow=0))
colnames(langue) <- c('Langue Document')

while (urlpdfloop < plist + 1) {
  print(paste0('Je traite le document ',urlpdfloop,' sur ',plist,' - de la page ', purlvalue,' sur ', pmaxvalue,' au total.'))
  
  while(!testCon()){
    print('internet est Down, on fait une pause de 5s') 
    Sys.sleep(5)
  }
  
  url_pdf_temp <- unlist(sapply(url_pdf[urlpdfloop], function(x) {x$clickElement()})) #we click on the documents
  Sys.sleep(runif(1, 1.5, 3))
  #find all interesting elements first.
  url_pdf_temp1 <- remDr$findElement(using = "xpath", ".//*[@class='btn fileURL']") #we get and store the URL
  #dataFile <- remDr$findElements(using = "xpath", ".//*[@class='listingItemLI detailListingItem']")
  dataFile <- remDr$findElements(using = "xpath", ".//*[@class='listingItemLI detailListingItem']")
  Sys.sleep(1)
  dataFile_temp <- dataFile
  dataFile_temp <- unlist(sapply(dataFile_temp, function(x) {x$getElementText()}))
  #we split the string in two using the /n as separator
  dataFile_temp <- str_split_fixed(dataFile_temp, "\n", 2)
  dataFile_temp <- as.data.frame(t(dataFile_temp))
  
  title_temp <-remDr$findElements(using = "xpath", ".//*[@class='itemTitle']")
  Sys.sleep(1)
  title_temp <- (unlist(sapply(title_temp, function(x) {x$getElementText()})))[1]
  title_temp <- as.data.frame(title_temp)
  colnames(title_temp) <- c('Titre')
  title <- rbind(title,title_temp)
  
  language_temp <- remDr$findElement(using = "xpath", ".//*[@class='file-details btn-default trsp-btn active']")
  Sys.sleep(1)
  language_temp <- language_temp$getElementText()
  language_temp <- as.data.frame(language_temp)
  colnames(language_temp) <- c('Langue Document')
  langue <- rbind(langue,language_temp)
  
  url_pdf_temp <- url_pdf
  url_pdf_temp <- unlist(sapply(url_pdf[urlpdfloop], function(x) {x$clickElement()}))
  closeButton <- remDr$findElement(using = "xpath", ".//*[@class='modalClose']")
  #start the collection of data
  url_pdf_temp1 <- url_pdf_temp1$getElementAttribute('href')
  url_pdf_temp <- as.data.frame(url_pdf_temp1)
  colnames(url_pdf_temp) <-c('URL')
  urlList <- rbind(urlList,url_pdf_temp)
 
  #we get the metadata as dataframe then rename the column using the first row as header.
  dataFile_temp[] <- lapply(dataFile_temp, as.character)
  colnames(dataFile_temp) <- dataFile_temp[1,]
  dataFile_temp <- dataFile_temp[-1,]
  metadataFile <- bind_rows(metadataFile,dataFile_temp)
  Sys.sleep(runif(1, 2, 3))
closeButton$clickElement()
urlpdfloop <- urlpdfloop +1
Sys.sleep(runif(1, 2, 3))
}

dataset_file <- cbind(metadataFile,langue,title,urlList)
