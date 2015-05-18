# WARNING THIS CODE MAY SEND TOO MANY REQUESTS TO THE API
# I cant for the life of me figure out what the limit is though


import urllib, json, datetime

# get all stops from stop-ids-for-agency method
all_stops_url = 'http://api.pugetsound.onebusaway.org/api/where/stop-ids-for-agency/1.json?key=f0d2025d-3221-4cb0-860c-4466ccc1b0b0'
stops_response = urllib.urlopen(all_stops_url)
all_stops = json.loads(stops_response.read())['data']['list']

# grab specific stops
for stop in all_stops:

	print('Stop: ' + stop + ' {')

	# get all data from arrivals-and-departures-for-stop method for current stop
	ad_url = 'http://api.pugetsound.onebusaway.org/api/where/arrivals-and-departures-for-stop/' + stop + '.json?key=f0d2025d-3221-4cb0-860c-4466ccc1b0b0'
	ad_response = urllib.urlopen(ad_url)
	ad = json.loads(ad_response.read())

	# get a specific trip near the stop
	for ad_data in ad['data']['entry']['arrivalsAndDepartures']:
		route_ID = ad_data['routeId']
		route_name = ad_data['routeShortName']
		trip_sign = ad_data['tripHeadsign']
		trip_ID = ad_data['tripId']
		predicted_arrival = ad_data['predictedArrivalTime']
		scheduled_arrival = ad_data['scheduledArrivalTime']
		predicted_departure = ad_data['predictedDepartureTime']
		scheduled_departure = ad_data['scheduledDepartureTime']

		print('\t' + route_name + ': ' + trip_sign + ' {')
		# print('\tArrival Lateness: ')
		# print(predicted_arrival - scheduled_arrival)
		# print('\tArrival Lateness: ')
		# print(predicted_departure - scheduled_departure)
		print('\t}')

	print('}')
