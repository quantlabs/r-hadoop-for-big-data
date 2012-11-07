#!/usr/bin/env Rscript

library(rmr)
library(plyr)
library(stringr)

rmr.options.set(backend = "hadoop") 
#debug rmr.options.set(backend = "local") 

# Load positive and negative words

projectDir = getwd()
dataDir = getwd()

# Jefrey Breen's sentiment analyis routine

hu.liu.pos = scan(file.path(dataDir, 'opinion-lexicon-English','positive-words.txt'), what='character', comment.char=';')
hu.liu.neg = scan(file.path(dataDir,'opinion-lexicon-English', 'negative-words.txt'), what='character', comment.char=';')

# add a few twitter and industry favorites
pos.words <- c(hu.liu.pos, 'upgrade')
neg.words <- c(hu.liu.neg, 'wtf', 'wait', 'waiting', 'epicfail', 'mechanical')

#' score.sentiment() implements a very simple algorithm to estimate
#' sentiment, assigning a integer score by subtracting the number 
#' of occurrences of negative words from that of positive words.
#' 
#' @param sentences of text to score
#' @param pos.words vector of words of postive sentiment
#' @param neg.words vector of words of negative sentiment
#' @return  sentiment scores
#' @ original author Jefrey Breen <jbreen@cambridge.aero>

score.sentiment = function(sentence, pos.words, neg.words) {
		
		# and convert to lower case:
		sentence = tolower(sentence)

		# split into words. str_split is in the stringr package
		word.list = str_split(sentence, '\\s+')
		# sometimes a list() is one level of hierarchy too much
		words = unlist(word.list)

		# compare our words to the dictionaries of positive & negative terms
		pos.matches = match(words, pos.words)
		neg.matches = match(words, neg.words)
	
		# match() returns the position of the matched term or NA
		# we just want a TRUE/FALSE:
		pos.matches = !is.na(pos.matches)
		neg.matches = !is.na(neg.matches)

		# and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
		score = sum(pos.matches) - sum(neg.matches)

		return(score)
}


# mapper function
# the mapper gets a key and a value vector 
# in our case, the key is NULL and all the tweet text comes in as val

mapper.score = function(key, val) {
      
# clean up tweets with R's regex-driven global substitute, gsub():
    val = gsub('[[:punct:]]', '', val)
    val = gsub('[[:cntrl:]]', '', val)
    val = gsub('\\d+', '', val)

# Key is the Airline we added as tag to the tweets
    airline = substr(val,1,2)

# Run the sentiment analysis
    output.key = c(as.character(airline), score.sentiment(val,pos.words,neg.words)) 

# our interest is in computing the counts by airlines and scores, so 'this' count is 1
    output.val = 1
    return( keyval(output.key, output.val) )
}


# reducer function
# the reducer gets all the values for a given key
# the values (which may be mult-valued as here) come in the form of a list()
#
reducer.score = function(key, val.list) {
		
	
	output.key = key   # same key we passed from mapper i.e airline + Score

# sum the counts for a given key

        output.val = sum(unlist(val.list)) 
	return( keyval(output.key, output.val) )
}



# Mapreduce function
mr.score= function (input, output=NULL) {
          	mapreduce(input = input,
			  output = output,
			  input.format = "text",
			  map = mapper.score,
			  reduce = reducer.score,
			  verbose=T)
}


# Run mapreduce and create the plots

out <- mr.score("/app/hadoop/tmp/inputs/dd/","/app/hadoop/tmp/outputs/dd/")
results.df <-  as.data.frame(from.dfs(out, structured=T)) 
colnames(results.df) = c('airline', 'score', 'count')
sink("airlines_scores.txt")
print(results.df)

