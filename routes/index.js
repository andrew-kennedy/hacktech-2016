var express = require('express');
//var twit = require('twit');
//loads the access tokens into the environment
require('dotenv').load();
var router = express.Router();
var azure = require('azure-storage');

//Todo: Find AZURE_STORAGE_ACCOUNT, AZURE_STORAGE_ACCESS_KEY, AZURE_STORAGE_CONNECTION_STRING
//From Azure, place into the .env
var tableSvc = azure.createTableService();


router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

module.exports = router;
