Hacktech 2016
-------------

A webapp for Sentiment Analysis based on Twitter feed
#Setup
##Installation
After downloading this through either git or wget, cd into the folder and run
``$ npm install``
##.env creation
You must also create a file called .env inside the folder hacktech-2016.
The file should have 3 fields:
TWITTER_CONSUMER_KEY
TWITTER_CONSUMER_SECRET
AZURE_STORAGE_CONNECTION_STRING

These files are required to get the twitter data and push to your own Azure server.

#Caveats
Please note that the update endpoint is extremely slow, it'll slow down your server greatly.

