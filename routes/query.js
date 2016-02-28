var express = require('express');
var router = express.Router();

require('dotenv').load();
//var azureStorage = require('azure-storage');
//var tableService = azure.createTableService();
//
//queryTable(person, density)
//{
//    var query = new azure.TableQuery()
//        .top(5)//number of items to fetch
//        .where('PartionKey eq ?', person);
//
//    tableService.queryEntities('candidateTweets', query, null, function(error, result, response) {
//        if(!error) {
//            //do something
//        }
//    });
//
//}
router.get('/:candidate/:density', function(req, res) {
    res.send("this will be the json object with data density d");//note that density refers to how many days to get the data for.
                                                //1 is every day, 2 is every other, 3 is every third, etc.

});

module.exports = router;