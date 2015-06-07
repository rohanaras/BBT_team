/// <reference path="typings/node/node.d.ts"/>
//This script was to convert and group by to make the map more interactive
var fs = require('fs');

var data = fs.readFileSync('./bData.json')
var JSONdata = JSON.parse(data);
var objectToReturn = {};
for(var i = 0; i < JSONdata.length; i++) {
	var currentData = JSONdata[i];
	if(!(currentData["blockid"] in objectToReturn)) {
		objectToReturn[currentData["blockid"]] = [];
	}
	objectToReturn[currentData["blockid"]].push({"hour": currentData["hour"], "avg_delay":currentData["avg_delay"], "std_delay":currentData["std_delay"]})
}
fs.writeFileSync('optimizedData.js', JSON.stringify(objectToReturn))