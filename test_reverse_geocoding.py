# Pygeocoder main page: https://pypi.python.org/pypi/pygeocoder 
# Documentation: http://code.xster.net/pygeocoder/wiki/Home
# sudo pip install pygeocoder
import urllib, json, datetime

from pygeocoder import Geocoder

results = Geocoder.reverse_geocode(40.714224, -73.961452)

print results[0].postal_code

# get all stops from stop-ids-for-agency method
all_stops_url = 'http://api.pugetsound.onebusaway.org/api/where/stop-ids-for-agency/1.json?key=f0d2025d-3221-4cb0-860c-4466ccc1b0b0'

stops_response = urllib.urlopen(all_stops_url)
all_stops = json.loads(stops_response.read())['data']['list']
print 'number of stops: ' + str(len(all_stops)) + '\n'

for stop in all_stops[0:10]:
    print 'Stop: ' + stop
    # get all data from arrivals-and-departures-for-stop method for current stop
    ad_url = 'http://api.pugetsound.onebusaway.org/api/where/arrivals-and-departures-for-stop/' + stop + '.json?key=f0d2025d-3221-4cb0-860c-4466ccc1b0b0'
    ad_response = urllib.urlopen(ad_url)
    ad = json.loads(ad_response.read())
    for ad_stop in ad['data']['references']['stops']:
        # get stop's latitude
        lat = ad_stop['lat']
        # get stop's longitude
        lon = ad_stop['lon']
        zipcode = Geocoder.reverse_geocode(lat, lon)[0].postal_code
        print "{"
        print stop
        print lat
        print lon
        print zipcode
        print "}"
