var express = require('express');
var Twitter = require('Twitter');
//loads the access tokens into the environment
require('dotenv').load();

var router = express.Router();

var client = new Twitter({
  consumer_key: 'process.env.TWITTER_CONSUMER_KEY',
  consumer_secret: 'process.env.TWITTER_CONSUMER_SECRET',
  bearer_token: 'process.env.TWITTER_BEARER_ACCESS_TOKEN'
});


client.get('search/tweets', {q: "bernie sanders"}, function(error, tweets, response){
  console.log("error");
  //if(error) throw error;
  //console.log(tweets);  // The favorites.
  console.log(response);  // Raw response object.
});


/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

module.exports = router;
