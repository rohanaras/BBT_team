var map;
var infoWindow;


var mapOptions = {
    zoom: 9,
    center: new google.maps.LatLng(47.60, -122.3331)
  };

map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
var elements = [];
var hour = 0;
function initialize() {
  var colorArray = [];
  var zipsForThisHour = [];
  var red = 0;
  var green = 255;
  for(var i = 0; i <= 256; i = i + 32) {
    colorArray.push("rgb(" + red + "," + green + ", 0" + ")");
    red = red + 32;
    if(red > 255)
      red = 255; 
  }
  for(var i = 0; i <= 256; i = i + 32) {
    colorArray.push("rgb(" + red + "," + green + ", 0" + ")");
    green = green - 32;
    if(green < 0)
      green = 0;
  }

  polys.forEach(function(poly) {
    var triangleCoords = [];
    var zip = poly["zip"];
    var color = "";
    var triangleInformation = {};
    zipsOverTime.forEach(function(zipcode) {
      if(zipcode["zip"] == zip && zipcode["hour"] == hour) {
        zipsForThisHour.push(zipcode["zip"]);
        triangleInformation["zip"] = zip;
        triangleInformation["delay"] = zipcode["avg_delay"];
        triangleInformation["std_delay"] = zipcode["std_delay"];
        var delay = zipcode["avg_delay"];
        if(delay.indexOf("-") != -1) {
          color = "rgb(0, 0, 255)";
        }
        else {
          var minutes = parseFloat(delay.substring(3, 5));
          var seconds = parseFloat(delay.substring(6));
          var totalSeconds = minutes * 60 + seconds;
          //Change later
          var tempWeight = totalSeconds / 400;
          color = colorArray[Math.floor(tempWeight * colorArray.length)]; 
        }
      }
    })
    if(color != "") {
      for (var i = 0; i < poly["points"].length; i++) {
        triangleCoords.push(new google.maps.LatLng(poly["points"][i][0], poly["points"][i][1]));
      }
      // Write Poly
      zipZone = new google.maps.Polygon({
        paths: triangleCoords,
        strokeColor: color,
        strokeOpacity: 1,
        strokeWeight: 1,
        fillColor: color,
        fillOpacity: 0.4
      });
      zipZone["addedInfo"] = triangleInformation;
      zipZone.setMap(map);
      elements.push(zipZone);

      google.maps.event.addListener(zipZone, 'click', showArrays);
    }

  })

  infoWindow = new google.maps.InfoWindow();
}

function showArrays(event) {

  var vertices = this.getPath();
  console.log(this);
  var contentString = "<div>" + "<h3>" + this["addedInfo"]["zip"] +"</h3>" + "<p>Average Delay: " + this["addedInfo"]["delay"] + "</p>" + "<p>Standard Dev: " + this["addedInfo"]["std_delay"] + "</p>"
  "</div>"

  infoWindow.setContent(contentString);
  infoWindow.setPosition(event.latLng);

  infoWindow.open(map);
}

google.maps.event.addDomListener(window, 'load', initialize);

document.getElementById("range").addEventListener("input", function() {
  elements.forEach(function(thing){
    thing.setMap(null);
  })
  elements = [];
  hour = parseInt(this.value);
  if(hour >= 12) {
    if(hour == 12) {
      document.getElementById("current-value").innerHTML = hour + " pm";
    }
    else {
      document.getElementById("current-value").innerHTML = hour % 12 + " pm";
    }
  }
  else {
    document.getElementById("current-value").innerHTML = "" + hour + " am";
  }
  initialize();
})
