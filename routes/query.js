var express = require('express');
var router = express.Router();

require('dotenv').load();



router.get('/', function(req, res, next) {
    res.send("this will be the json object");
});

module.exports = router;