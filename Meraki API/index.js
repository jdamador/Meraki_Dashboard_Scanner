/* Scanner API from Meraki Dashboard.
- Comunidad Data Science.
- Author: Jose Daniel Amador Salas.
- Created: 01-03-2019.*/

// Import libraries required.
var express = require("express");
var bodyParser = require("body-parser");
const FS = require('fs');
var app = express();

// Valitadation credentials
const LISTEN_PORT = 9201;
const API_KEY = "511c40271fbead284e859697874724ff2060a337";
const SECRET = "secret";

app.use(bodyParser.urlencoded({
    extended: true
}));
app.use(bodyParser.json());

content = [];

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
        var jsoned = JSON.parse(req.body.data);
        console.log("56565" + jsoned[0])

        console.log(jsoned);
        for (i = 0; i < jsoned.probing.length; i++) {
            console.log("client " + jsoned.probing[i].client_mac + " seen on ap " + jsoned.probing[i].ap_mac + " with rssi " + jsoned.probing[i].rssi + " at " + jsoned.probing[i].last_seen);
        }
    } catch (e) {
        // An error has occured, handle it, by e.g. logging it
        console.log("Error.  Likely caused by an invalid POST from " + req.connection.remoteAddress + ":");
        console.log(e);
        res.end();
    }
    res.end();
});

app.listen(3000, () => {
    console.log('Server running on port 3000');
});