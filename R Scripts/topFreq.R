# Script for calculating High Frequency words

#########################
## check onces! - if all libraries are present

# Needed <- c("tm", "SnowballCC", "RColorBrewer", "ggplot2", "wordcloud", "biclust", "cluster", "igraph", "fpc")   
# install.packages(Needed, dependencies=TRUE)   

# install.packages("Rcampdf", repos = "http://datacube.wu.ac.at/", type = "source")
#########################

library(tm)
library(SnowballC)
#library(RColorBrewer)
#library(ggplot2)
library(wordcloud)
#library(biclust)
#library(cluster)
#library(fpc)
#library(igraph)


getTop10 = function(input_data) {
# Create Corpus

docs <- Corpus(VectorSource(input_data))
# summary(docs)

#remove punctuations
docs <- tm_map(docs, removePunctuation)
#remove spl characters, numbers
for(j in seq(docs))   
{   
  docs[[j]]<-gsub("[^[:alnum:][:blank:]+?&/\\-]", "", docs[j])
}   

docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, tolower) 
docs <- tm_map(docs, removeWords, stopwords("english"))

# Combining words that should stay together

# remove commonwords
docs <- tm_map(docs, stemDocument)   
#docs <- tm_map(docs, stripWhitespace)   

docs <- tm_map(docs, PlainTextDocument)

#create document term matrix 
dtm <- DocumentTermMatrix(docs)   
tdm <- TermDocumentMatrix(docs)

# Exploring data
freq <- colSums(as.matrix(dtm))   
#length(freq)
#ord<-order(freq)

dtms <- removeSparseTerms(dtm, 0.1) # This makes a matrix that is 10% empty space, maximum.   
#inspect(dtms)

# Get rid of terms with frequncy > length of data table
top_10=head(sort(freq[sapply(freq, function(x) sum(x) < length(input_data))],decreasing = TRUE),10)
return(top_10)
}