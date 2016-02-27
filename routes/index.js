var express = require('express');
//var twit = require('twit');
//loads the access tokens into the environment
require('dotenv').load();

var router = express.Router();
//
//var T = new twit({
//  consumer_key: 'process.env.TWITTER_CONSUMER_KEY',
//  consumer_secret: 'process.env.TWITTER_CONSUMER_SECRET',
//  app_only_auth: true
//});

/*
 * Wrapper function for making calls to twitter.
 * Params should be a json object, with a mandatory q= field
 * Returns data to the callback function.
 */
//twitQuery = function (params, callback)
//{
//  T.get('search/tweets', params, function(err, reply) {
//    if(!err) return callback(reply);
//
//  });
//}


function returnError() {

}
/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

module.exports = router;
