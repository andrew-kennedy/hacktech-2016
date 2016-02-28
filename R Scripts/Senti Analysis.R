
all_tweets <- read.delim("~/GitHub/hacktech-2016/R Scripts/all_tweets.txt", header=FALSE)
View(all_tweets)
colnames(all_tweets) <- c("Candidate", "Tweet_text","Tstamp")




d<-all_tweets
d<-d[!(d$Candidate==""),]
d$Tstamp<-(strsplit(as.character(d$Tstamp), " "))
for(i in length(d$Tstamp))   
{   
  time[i]<-unlist(as.character(d$Tstamp[i]), " ")[3]
}   



col=brewer.pal(6,"Dark2")
wordcloud(corpus, min.freq=25, scale=c(5,2),rot.per = 0.25,
          random.color=T, max.word=45, random.order=F,colors=col)