var express = require('express');
var twit = require('twit');
//loads the access tokens into the environment
require('dotenv').load();
var router = express.Router();

//var azure = require('azure-storage');

//Todo: Find AZURE_STORAGE_ACCOUNT, AZURE_STORAGE_ACCESS_KEY, AZURE_STORAGE_CONNECTION_STRING
//From Azure, place into the .env
//var tableSvc = azure.createTableService();
//
//tableSvc.createTableIfNotExists('mytable', function(error, result, response){
//  if(!error){
//    // Table exists or created
//  }
//});




var T = new twit({
  consumer_key: 'process.env.TWITTER_CONSUMER_KEY',
  consumer_secret: 'process.env.TWITTER_CONSUMER_SECRET',
  app_only_auth: true
});

/*
 * Wrapper function for making calls to twitter.
 * Params should be a json object, with a mandatory q= field
 * Returns data to the callback function.
 */
twitQuery = function (params, callback)
{
  T.get('search/tweets', { q: params, count: 100, lang: 'en' }, function(err, data, response) {
    if(err) console.log(err);
    callback(data);
  });
};


router.get('/', function(req, res, next) {
  res.render('index', { title: 'Polisense' });
});


router.post('/update', function(req, res, next) {
  //call an order
    // twitQuery();
});

module.exports = router;
