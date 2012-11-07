#!/usr/bin/env Rscript

#
# mscrape.R - scrape twitter data and store it
#
#

dataDir = getwd()


library("twitteR")
library(XML)

# Twitter search and saving the CSV files

twitter.search = function(tag,tweetcount,srch) {
		
 tweets = searchTwitter(srch, n=tweetcount)
 df <- twListToDF(tweets)
 # we are writing the query string of our interest (airlines) along with the twitter, space de-limiter is good enough for the current tag.
 write.table(paste(tag," ",df[[1]]),file = filename, append = TRUE, quote = TRUE, sep = "",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = FALSE, qmethod = "double")
	
}

# number of tweets for the query and filename
tweetcount =1500
filename= "tweets.txt"

# variables for AA
airline="AA"
srch='@americanair'
twitter.search(airline,tweetcount,srch)


# variables for DL
airline="DL"
srch='@delta'
twitter.search(airline,tweetcount,srch)


# variables for JB
airline="JB"
srch='@jetblue'
twitter.search(airline,tweetcount,srch)


# variables for SW
airline="SW"
srch='@southwestair'
twitter.search(airline,tweetcount,srch)


# variables for United
airline="UN"
srch='@united'
twitter.search(airline,tweetcount,srch)


# variables for US Airways
airline="US"
srch='@usairways'
twitter.search(airline,tweetcount,srch)

