# Get all relevant libraries
library(twitteR)
library(ROAuth)
require(RCurl)
library(stringr)
library(tm)
library(ggmap)
library(dplyr)
library(plyr)
library(tm)
library(wordcloud)


# Setup ROauth

key<-"ujDcq1oEiz0N5fBEF8FKnyVCP"
secret<-"T9Yqbo9s3UM5JJzfQCFmDFLA3SBjLwXPGvNWcM1ttGFc4ULpnw"
setwd("data_dump/")

download.file(url="http://curl.haxx.se/ca/cacert.pem",destfile="cacert.pem",method="auto")
authenticate <- OAuthFactory$new(consumerKey=key,
                                 consumerSecret=secret,
                                 requestURL="https://api.twitter.com/oauth/request_token",
                                 accessURL="https://api.twitter.com/oauth/access_token",
                                 authURL="https://api.twitter.com/oauth/authorize")
setup_twitter_oauth(key, secret, access_token = NULL, access_secret = NULL)
save(authenticate, file="twitter authentication.Rdata")

N=2000
donald=do.call++(rbind,lapply(1:length(lats), function(i) searchTwitter('Donald+Trump',
                                                                      lang="en",n=N,resultType="recent",sep=",")))