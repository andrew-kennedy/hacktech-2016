# Script for calculating High Frequency words

#########################
## check onces! - if all libraries are present

# Needed <- c("tm", "SnowballCC", "RColorBrewer", "ggplot2", "wordcloud", "biclust", "cluster", "igraph", "fpc")   
# install.packages(Needed, dependencies=TRUE)   

# install.packages("Rcampdf", repos = "http://datacube.wu.ac.at/", type = "source")
#########################

library(tm)
library(SnowballCC)
library(RColorBrewer)
library(ggplot2)
library(wordcloud)
library(biclust)
library(cluster)
library(fpc)
library(igraph)

# Create Corpus

docs <- Corpus(VectorSource(tweet_x$status))
# summary(docs)

#remove punctuations
docs <- tm_map(docs, removePunctuation)
#remove spl characters, numbers
for(j in seq(docs))   
{   
  docs[[j]] <- gsub("/", " ", docs[[j]])   
  docs[[j]] <- gsub("@", " ", docs[[j]])   
  docs[[j]] <- gsub("\\|", " ", docs[[j]])   
}   

docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, tolower) 
docs <- tm_map(docs, removeWords, stopwords("english"))

# Combining words that should stay together
for (j in seq(docs))
{
  docs[[j]] <- gsub("qualitative research", "QDA", docs[[j]])
  docs[[j]] <- gsub("qualitative studies", "QDA", docs[[j]])
  docs[[j]] <- gsub("qualitative analysis", "QDA", docs[[j]])
  docs[[j]] <- gsub("research methods", "research_methods", docs[[j]])
}


