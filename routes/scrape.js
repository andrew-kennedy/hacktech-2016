

var fs = require('fs');
var twit = require('twit');
var azure = require('azure-storage');
require('dotenv').load();

var blobService = azure.createBlobService();
var T = new twit({
    consumer_key: process.env.TWITTER_CONSUMER_KEY,
    consumer_secret: process.env.TWITTER_CONSUMER_SECRET,
    app_only_auth: true
});


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

    for (var i = 0; i < count; i++) {
        text = data['statuses'][i]['text'];
        id = data['statuses'][i]['id'];
        time = data['statuses'][i]['created_at'];


        text = text.replace(/(\r\n|\n|\r)/gm," ");



        //TODO: send this data somewhere useful
    }

    //console.log(data);
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
}

checkRemainingSearches(function(data) {
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
});