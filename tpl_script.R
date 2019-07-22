setwd("~/Téléchargements/tpl-scrape/TPL_Scrape")
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

