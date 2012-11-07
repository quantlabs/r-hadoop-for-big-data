#!/usr/bin/env Rscript


library(rmr)

rmr.options.set(backend = "hadoop") 

mapper.wordcount = function(key, val) {
	
                      lapply(
                         strsplit( x = val, split = " ")[[1]],
                         function(w) keyval(w,1)
                      )
}

#
# the reducer gets all the values for a given key
# the values come in the form of a list()
#
reducer.wordcount = function(key, val.list) {
                  output.key = key
                  output.val = sum(unlist(val.list))
	          return( keyval(output.key, output.val) )
}


mr.wordcount = function (input, output) {
	mapreduce(input = input,
			  output = output,
			  input.format = "text",
			  map = mapper.wordcount,
			  reduce = reducer.wordcount )
}

out <- mr.wordcount("/app/hadoop/tmp/inputs/wc/","/app/hadoop/tmp/outputs/wc/")
results.df =  as.data.frame(from.dfs(out, structured=T)) 
colnames(results.df) = c('Word', 'Count')
sink("wordcount.txt")
print(results.df)
