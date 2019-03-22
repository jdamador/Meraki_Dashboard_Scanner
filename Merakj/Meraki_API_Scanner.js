// nodejs Meraki Presence receiver by Kris Linquist (klinquis@cisco.com)
//
// Prerequisite: the express node module.  Use 'sudo npm install express' to install, then start this script with 'nodejs merakiReceiver.js' (sudo required if port <1024)
//
// Meraki will send a HTTP GET request to test the URL and expect to see the validator as a response. 
// When it sends the presence information, it will also send the secret.  This script validates that the secret is correct prior to parsing the data.
//
// This script listens for the uri {request_uri}:port/meraki
//
var listenport = 9201; //TCP listening port
var secret = "secret"; //Secret that you chose in the Meraki dashboard
var validator = "fd93d6cc6e153143af37669a19c92d7c47337f92"; //Validator string that is shown in the Meraki dashboard

var express = require('express');
bodyParser = require('body-parser');
var app = express();
const fs = require('fs');

app.use(bodyParser.urlencoded({
	extended: true
}));
app.use(bodyParser.json());

content = []

app.get('/meraki', function (req, res) {
	res.send(validator);
	console.log("sending validation")
});


var table = [];
var contador = 0;

app.post('/meraki', function (req, res) {
	try {
		contador = contador + 1;
		console.log(contador + " - " + req.body.data.apMac);
		var json = req.body.data;
		table.push(json);
		var jsonC = JSON.stringify(table);
		fs.writeFile('data.json', jsonC, 'utf8', function (err) {
			if (err) {
				return console.log(err);
			}

		});
		//var jsoned = JSON.parse(req.body.data);
		//console.log("56565" + jsoned[0])
		/*
				console.log(jsoned);
				for (i = 0; i < jsoned.probing.length; i++) {
					console.log("client " + jsoned.probing[i].client_mac + " seen on ap " + jsoned.probing[i].ap_mac + " with rssi " + jsoned.probing[i].rssi + " at " + jsoned.probing[i].last_seen);
				}*/
	} catch (e) {
		// An error has occured, handle it, by e.g. logging it
		console.log("Error.  Likely caused by an invalid POST from " + req.connection.remoteAddress + ":");
		console.log(e);
		res.end();
	}
	res.end();
});

app.listen(listenport);
console.log("Meraki presence API receiver listening on port " + listenport);