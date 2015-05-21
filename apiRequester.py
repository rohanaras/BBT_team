# WARNING THIS CODE MAY SEND TOO MANY REQUESTS TO THE API
# I cant for the life of me figure out what the limit is though

import urllib, json, datetime, pyowm, time

#Open weather map API key
owm = pyowm.OWM('0f115000897f3bb486fb0cbda58d8056')

#OneBusAway API
all_stops_url = 'http://api.pugetsound.onebusaway.org/api/where/stop-ids-for-agency/1.json?key=f0d2025d-3221-4cb0-860c-4466ccc1b0b0'

#Executes script. Waits a hour before re-executing
while True:
	# Search for current weather in Seattle
	observation = owm.weather_at_place('Seattle,US')
	w = observation.get_weather()
	print(w)

	# Weather details
	print(w.get_wind())
	print(w.get_humidity())
	print(w.get_temperature('fahrenheit'))

	# break in the printed text
	print('\n-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-\n')

	# get all stops from stop-ids-for-agency method
	stops_response = urllib.urlopen(all_stops_url)
	all_stops = json.loads(stops_response.read())['data']['list']
	print('number of stops: ' + str(len(all_stops)) + '\n')

	# grab specific stops
	# for stop in all_stops[0:5]:
	for stop in all_stops[0:10]:
		print('Stop: ' + stop + ' {')
		# get all data from arrivals-and-departures-for-stop method for current stop
		ad_url = 'http://api.pugetsound.onebusaway.org/api/where/arrivals-and-departures-for-stop/ ' + stop + '.json?key=f0d2025d-3221-4cb0-860c-4466ccc1b0b0'
		ad_response = urllib.urlopen(ad_url)
		ad = json.loads(ad_response.read())
		# get system time as timestamp
		current_time = ad['currentTime']
		# get a specific trip near the stop
		for ad_data in ad['data']['entry']['arrivalsAndDepartures']:
			if ad_data['tripStatus']['predicted']:
				route_ID = ad_data['routeId']
				route_name = ad_data['routeShortName']
				trip_sign = ad_data['tripHeadsign']
				trip_ID = ad_data['tripId']
				predicted_arrival = ad_data['predictedArrivalTime']
				scheduled_arrival = ad_data['scheduledArrivalTime']
				predicted_departure = ad_data['predictedDepartureTime']
				scheduled_departure = ad_data['scheduledDepartureTime']
				print('\t' + route_name + ': ' + trip_sign + ' {')
				print('\tPredicted arrival: ' + str(predicted_arrival))
				print('\tScheduled arrival: ' + str(scheduled_arrival))
				# predicted - sheduled gives positive lateness and negative for being early
				print('\t}')
		print('}')
	time.sleep(3600)