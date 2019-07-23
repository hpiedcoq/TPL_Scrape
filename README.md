# TPL_Scrape
A R script using Selenium to scrape data from the Special Tribunal for Lebanon.

##What's the purpose of the script

The TPL offers all its decisions concerning a case to be browsed and downloaded.
The main issue is that for some cases, a lot of documents is available : many pages on the website, each page containing 20 decisions which contains themselves between 1 and 20 or more documents.

##What do we need

We need to mass download the documents and create an index of theses docs containing all their metadata, especially the date of publication, the language, etc...

##Caveats

The website is coded with a lot of javascript and has many protections against scraping.
Using xpath to select elements on this kind of website can really be a pain in the ass. So I use css elements. 

##Solution 

I wrote this script using R and Selenium.
You need to have the Selenium server working in the background.

##Enhancement

This code should be optimized by scraping the xhr json on every page, and justin parsing it.
This done, you don't have to render anything in a browser. 
But I didn't manage to do it.




