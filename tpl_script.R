setwd("~/Téléchargements/tpl-scrape/TPL_Scrape")
maindir <- getwd()
source('constantes.R')
Sys.sleep(runif(1, 1.5, 5))

#Open Connection with displayed browse. Good for debugging
remDr <- remoteDriver(remoteServerAddr = "0.0.0.0"
                      , port = 4444
                      , browserName = "firefox"
                      )


# #Open Connection headless
# remDr <- remoteDriver(remoteServerAddr = "0.0.0.0"
#                       , port = 4444
#                       , browserName = "firefox"
#                       , extraCapabilities = list(
#                         "moz:firefoxOptions" = list(
#                           args = list('--headless')))
# )

remDr$open()
remDr$navigate(url_base)
Sys.sleep(runif(1, 1.5, 2))

#We create the original dataset based on the first page.
source('tpl_scrape_pages_urls.R')
purlvalue <-2
#At this step we collected all the information for the first page.
#Now we iterate the whole website by scraping the following URLs
datasetAll <- dataset_file

while (purlvalue < pmaxvalue){
  print(paste0('Je traite la page ',purlvalue))
  while(!testCon()){
    print('internet est Down, on fait une pause de 5s') 
    Sys.sleep(5)
  }
  nextpage <- remDr$findElement(using = "xpath", '//*[@class="page-link next"]') 
  nextpage$clickElement()
  Sys.sleep(runif(1, 1.5, 2))
  source('tpl_scrape_pages_urls.R')
  datasetAll <- rbind(datasetAll,dataset_file)
  gc()
  purlvalue <- purlvalue +1
}
write.csv(datasetAll,file = "datasetAll.csv")

#Let's prepare for mass download
#We create a directory called files
dir.create('files')
maindir_files <- paste0(maindir,'/files')
nbUrls <- nrow(datasetAll)
p <- 1
#Create a column year to order the directories
datasetAll['year'] = lapply(datasetAll['Document date'], function(x) str_extract(x, "[0-9]{4}"))
#We loop the dataset to get the document
#Before we check if the subdirectory year and the subdirectory language exist. If not we create them.

while (p < nbUrls+1){
  print(paste0('Je DL le fichier ',p,' sur ',nbUrls,' au total'))
  output_dir <- paste0(maindir_files,'/',datasetAll$year[p])
  file <-unlist(datasetAll['URL'][[1]][p])
  filename <- basename(file)
  #creation of the 1st level of subdir
  if (!dir.exists(output_dir)){
    dir.create(output_dir)
  }
  #creation of the second level of subdir
  output_dir <- paste0(output_dir,'/',unlist(datasetAll['Langue Document'][[1]][p]))
  if (!dir.exists(output_dir)){
    dir.create(output_dir)
  }
  filenamedir <-paste0(output_dir,'/',filename)
  download.file(file, destfile = filenamedir, method = "wget")
  #we pause more or less 1.5s between every DL
  Sys.sleep(runif(1, 1, 2))
  gc()
  p <-p+1
}



