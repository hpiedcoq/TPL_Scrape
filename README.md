# TPL_Scrape
A R script using Selenium to scrape data from the Special Tribunal for Lebanon.

## What's the purpose of the script

The STL offers all its decisions concerning a case to be browsed and downloaded.
The main issue is that for some cases, a lot of documents is available : many pages on the website, each page containing 20 decisions which contains themselves between 1 and 20 or more documents.

## What do we need

We need to mass download the documents and create an index of theses docs containing all their metadata, especially the date of publication, the language, etc...

## Caveats

The website is coded with a lot of javascript and has many protections against scraping.
Using xpath to select elements on this kind of website can really be a pain in the ass. So I use css elements. 

## Solution 

I wrote this script using R and Selenium.
You need to have the Selenium server working in the background.
File are downloaded in a subdirectory calle 'files', by year of issue and by language.

## Some comments

Apart from the xpath/css trick, some more comments : 

- It's a good idea to use basename() to get the name of the file. Seems trivial, but...
- download.file() can use several methods (curl, wget, libcurl, etc...). the best way is to pass the 'auto' parameter
- But most important, download.file() has a user-agent spoofing hability. 
Just pass the "options(HTTPUserAgent='Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0) Gecko/20100101 Firefox/68.0')" option before. Otherwise, it won't work, as the STL server detects the non-standard user-agents.
- Do behave with server requests. Tempos between two downloads are useful.
- R doesn't automatically deal with the garbage collector, that's why I often do a gc() (... at every loop).
- I also always use a testcon() function on my scraping scripts, in order to only send a request if the internet connexion is up.

## Enhancement

This code should be optimized by scraping the xhr json on every page, and justin parsing it.
This done, you don't have to render anything in a browser. 
But I didn't manage to do it.




