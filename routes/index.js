var express = require('express');
var twit = require('twit');
//loads the access tokens into the environment
require('dotenv').load();
var router = express.Router();



var fs = require('fs');
var azure = require('azure-storage');
require('dotenv').load();

var blobService = azure.createBlobService();
var T = new twit({
  consumer_key: process.env.TWITTER_CONSUMER_KEY,
  consumer_secret: process.env.TWITTER_CONSUMER_SECRET,
  app_only_auth: true
});

var tableService = azure.createTableService();
tableService.createTableIfNotExists('candidateTweets', function(error, result, response) {
  if (!error) {
    // result contains true if created; false if already exists
  }
});


var entGen = azure.TableUtilities.entityGenerator;


//initialize the last read id.
//democrats
var sanders_since_id = 0;
var clinton_since_id = 0;
//republicans
var trump_since_id = 0;
var rubio_since_id = 0;
var cruz_since_id = 0;
var kasich_since_id = 0;
var carson_since_id = 0;

//democrats
var sanders = 'Bernie Sanders';
var clinton = 'Hillary Clinton';
//republicans
var trump = 'Donald Trump';
var rubio = 'Mark Rubio';
var cruz = 'Ted Cruz';
var kasich = 'John Kasich';
var carson = 'Ben Carson';



processData =  function (params, data) {
  max_id = data['search_metadata']['max_id'];
  count = data['search_metadata']['count'];
  if(params == sanders)
    sanders_since_id = max_id;
  else if(params == clinton)
    clinton_since_id = max_id;
  else if(params == trump)
    trump_since_id = max_id;
  else if(params == rubio)
    rubio_since_id = max_id;
  else if(params == cruz)
    cruz_since_id = max_id;
  else if(params == kasich)
    kasich_since_id = max_id;
  else if(params == carson)
    carson_since_id = max_id;
  var i = 0;
  for (i = 0; i < count; i++) {
    if(data['statuses'][i] != undefined) {
      text = data['statuses'][i]['text'];
      id = data['statuses'][i]['id_str'];
      time = data['statuses'][i]['created_at'];


      text = text.replace(/(\r\n|\n|\r)/gm, " ");
      var entity = {
        PartitionKey: entGen.String(params),
        RowKey: entGen.String(id),
        tweetText: entGen.String(text),
        timeOfTweet: entGen.String(time),
      };
      //console.log(entity);
      tableService.insertEntity('candidateTweets', entity, function (error, result, response) {
        if (!error) {
        }

      });
    }
  }

};


twitQuery = function (params)
{
  T.get('search/tweets', { q: params, count: 100, lang: 'en' }, function(err, data, response) {
    if(err) console.log("err: ", err);
    processData(params, data);
  });
}


checkRemainingSearches = function(callback)
{
  T.get('application/rate_limit_status', {resources: 'search'}, function(err, data, response) {
    if(err) console.log(err);
    callback(data);
  });
};

 updateDatabase = function(data) {
  var limit = data['resources']['search']['/search/tweets']['limit'];
  var remaining = data['resources']['search']['/search/tweets']['remaining'];
  var reset = data['resources']['search']['/search/tweets']['reset'];
  for(var i = remaining; remaining >= 7; remaining -= 7)
  {
    twitQuery(clinton);
    twitQuery(sanders);

    twitQuery(trump);
    twitQuery(rubio);
    twitQuery(cruz);
    twitQuery(kasich);
    twitQuery(carson);

  }
  console.log("limit: ",limit, " remaining: ", remaining, " reset: ", reset);
}

router.get('/', function(req, res, next) {
  res.render('index', { title: 'Polisense' });
});


router.post('/update', function(req, res, next) {
  //call an order
  checkRemainingSearches(updateDatabase);
});



module.exports = router;
