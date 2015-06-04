/// <reference path="typings/node/node.d.ts"/>
var fs = require('fs');
var zips = require('./zips.js');
var results = require('./results.js')["data"];
var mad = [];
var zip;
var points;
results.forEach(function(data) {
	zip = data[data.length - 6];
	var contains = false;
	for (var i = 0; i < zips.length; i++) {
		if(zips[i]["zip"] == zip){
			contains = true;
			break;	
		}
	}
	if(contains) {
		points = data[9][data[9].length - 1]["rings"][0];
		points.map(function(data) {
			return data.reverse();
		})
		if(!aContains(mad, zip)) {
			mad.push({"zip" : zip, "points": points});	
		}
	}
})

function aContains(mArray, zZip) {
	for(var i = 0; i < mArray.length; i++) {
		if(mArray[i]["zip"] == zZip)
			return true;
	}
	return false;
}

fs.writeFile('output.json', JSON.stringify(mad));