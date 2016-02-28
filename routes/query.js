var express = require('express');
var router = express.Router();

require('dotenv').load();
var azure = require('azure-storage');
var tableService = azure.createTableService();

queryTable = function(person, callback)
{
    var query = new azure.TableQuery()
        //.top(50000)//number of items to fetch
        .where('PartitionKey eq ?', person);

    tableService.queryEntities('rawCandidateTweets', query, null, function(error, result, response) {
        if(!error) {
            var table = [];
            for(i = 0; i < result.entries.length; i++) {
                var c = result.entries[i];
                var pkey = c.PartitionKey._;
                var rkey = c.RowKey._;
                var text = c.tweetText._;
                var time = c.timeOfTweet;
                //console.log(JSON.parse(JSON.stringify(c)));
                if(time == undefined)
                    continue;

                //console.log(c.tweetText._ , ',', c.timeOfTweet._, ',', c.PartitionKey._);
                table.push ({ tweetText: c.tweetText._, time: c.timeOfTweet._, candidate: c.PartitionKey._  });
                //console.log("no error ", result.entries[1].PartitionKey);
            }


            callback(error, table);
        }
        else {
            callback(error, undefined);
            console.log("error", error);
        }
    });

}
router.get('/:candidate', function(req, res) {
    //console.log(req.params.candidate);
    //console.log(req.params.density);

    queryTable(req.params.candidate, function(err, table) {
        if(!err)
        {
            console.log("table: ", table);
            res.send(table);
        }
        else
        {
            res.send("error: call failed");
        }
    });
});


module.exports = router;