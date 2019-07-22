library(tidyverse)
library(RSelenium)
library(stringr)


mainDir <- "~/Téléchargements/tpl-scrape/TPL_Scrape"
setwd(mainDir)
pvalue = 0
purlvalue = 1
pmaxvalue = 169 #max number of pages

#urls & paths
url_base <- 'https://www.stl-tsl.org/en/the-cases/stl-11-01/filings-and-decisions?&case=2&dtype=1'

#Creating a function to test connexion internet UP
testCon = function(){!is.null(curl::nslookup('qwant.com', error= FALSE))}



#If the script gets stalled, this helps to restart from the good clicked page

# purlvalue <-2
# while (purlvalue < 80) {print(paste0('Je traite la page ',purlvalue))
#   nextpage <- remDr$findElement(using = "xpath", '//*[@class="page-link next"]')
#   nextpage$clickElement()
#   Sys.sleep(runif(1, 1, 1.5))
#   purlvalue <- purlvalue +1}
