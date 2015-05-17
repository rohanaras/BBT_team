import urllib, json 

all_stops_url = 'http://api.pugetsound.onebusaway.org/api/where/stop-ids-for-agency/1.json?key=f0d2025d-3221-4cb0-860c-4466ccc1b0b0'
stops_response = urllib.urlopen(all_stops_url)
all_stops = json.loads(stops_response.read())

stop = all_stops['data']['list'][0]

ad_url = 'http://api.pugetsound.onebusaway.org/api/where/arrivals-and-departures-for-stop/' + stop + '.json?key=f0d2025d-3221-4cb0-860c-4466ccc1b0b0'
ad_response = urllib.urlopen(ad_url)
ad = json.loads(ad_response.read())
print(ad)