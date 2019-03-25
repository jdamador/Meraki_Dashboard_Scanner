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
var validator = "73ba5fc6648d2fa733a364ec9c88679034136d5f"; //Validator string that is shown in the Meraki dashboard

var express = require('express');
bodyParser = require('body-parser');
var app = express();
const fs = require('fs');
// Config Postgre
const pg = require('pg');
const config = require('./config');
app.use(bodyParser.urlencoded({
	extended: true
}));
app.use(bodyParser.json());

content = []

app.get('/meraki', function (req, res) {
	res.send(validator);
	console.log("sending validation")
});



app.post('/meraki', function (req, res) {
	try {
        
        // Parsing data into JSON
		var jsoned = JSON.parse(req.body.data);
        
        // Insert data into DB
        insertDataDB(jsoned);
		
	} catch (e) {
		// An error has occured, handle it, by e.g. logging it
		console.log("Error.  Likely caused by an invalid POST from " + req.connection.remoteAddress + ":");
		console.log(e);
		res.end();
	}
	res.end();
});

// Insert data into database
function insertDataDB(data){
    for (i = 0; i < data.length; i++) {
        if(insertDevice(data[i].apMac,data[i].apFloors,data[i].apTags)){ 
            for(j = 0;j < data[i].observations.length; j++){
                _lat = data[i].observations.location.lat;
                _lng = data[i].observations.location.lng;
                _unc = data[i].observations.location.unc;
                _x = data[i].observations.location.x;
                _y = data[i].observations.location.y;
                _seenTime = data[i].observations.seenTime
                _ssid = data[i].observations.ssid.
                _os = data[i].observations.os
                _seenEpoch = data[i].observations.seenEpoch
                _rssi = data[i].observations.rssi
                _ipv6 = data[i].observations.ipv6
                _manufacturer = data[i].observations.manufacturer
                _mac = data[i].apMac
                _macDevice = data[i].observations.clientMac
                // Insert observation
                insertObservation(_lat,_lng,_unc,_x,_y,_seenTime,_ssid,_os,_seenEpoch,_rssi,_ipv6,_manufacturer,_mac,_macDevice)
            }
        }
    }
}

// Insert observation
async function insertObservation(_lat,_lng,_unc,_x,_y,_seenTime,_ssid,_os,_seenEpoch,_rssi,_ipv6,_manufacturer,_mac,_macDevice){
    return new Promise(r =>{
        var client = new pg.Client(config);
        client.connect(err => {
            if (err){client.end();console.log(err); r(false);   }
            else {
                const query = `SELECT insert_observation('${_lat}','${_lng}','${_unc}','${_x}','${_y}','${_seenTime}','${_ssid}'
                                ,'${_os}','${_seenEpoch}','${_rssi}','${_ipv6}','${_manufacturer}','${_mac}','${_macDevice}')`;
                client.
                query(query)
                .then(() => {
                    client.end();
                    r(true);
                })
                .catch(e =>{
                    console.error(e.stack);
                    client.end();
                    r(false);
                });
            }
        });
    });
}

// Insert device
async function insertDevice(_appMac,_appFloor,_apTag){
    return new Promise(r =>{
        var client = new pg.Client(config);
        client.connect(err => {
            if (err){client.end();console.log(err); r(false);   }
            else {
                const query = `SELECT insert_device('${_appMac}','${_appFloor}','${_apTag}')`;
                
                client.
                query(query)
                .then(() => {
                    client.end();
                    r(true);
                })
                .catch(e =>{
                    console.error(e.stack);
                    client.end();
                    r(false);
                });
            }
        });
    });
}

app.listen(listenport);
console.log("Meraki presence API receiver listening on port " + listenport);
