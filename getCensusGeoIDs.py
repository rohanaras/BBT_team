import urllib, json

output = open('geo_IDs.csv', 'w')
output.write('Stop_ID,FIPS,mix_x,max_x,min_y,max_y\n')

key = 'f0d2025d-3221-4cb0-860c-4466ccc1b0b0'

all_stops_url = 'http://api.pugetsound.onebusaway.org/api/where/stop-ids-for-agency/1.json?key=' + key
stops_response = urllib.urlopen(all_stops_url)
all_stops = json.loads(stops_response.read())['data']['list']
print('number of stops: ' + str(len(all_stops)) + '\n')

count = 0
for stop in all_stops:
	count = count + 1
	print(count)
	print('Stop: ' + stop + ' {')

	output.write(stop + ',')

	stop_url = 'http://api.pugetsound.onebusaway.org/api/where/stop/' + stop + '.json?key=' + key
	s_stop_response = urllib.urlopen(stop_url)
	stop_data = json.loads(s_stop_response.read())['data']['entry']
	latitude = stop_data['lat']
	print('\t' + str(latitude))
	longitude = stop_data['lon']
	print('\t' + str(longitude))

	geo_ID_url = 'http://www.broadbandmap.gov/broadbandmap/census/block?latitude=' + str(latitude) + '&longitude=' + str(longitude) + '&format=json'
	geo_ID_response = urllib.urlopen(geo_ID_url)
	geo_ID_object = json.loads(geo_ID_response.read())['Results']['block'][0]

	FIPS = geo_ID_object['FIPS']
	print('\t' + FIPS)
	output.write(FIPS + ',')

	min_x = geo_ID_object['envelope']['minx']
	print('\t' + str(min_x))
	output.write(str(min_x) + ',')

	max_x = geo_ID_object['envelope']['maxx']
	print('\t' + str(max_x))
	output.write(str(max_x) + ',')

	min_y = geo_ID_object['envelope']['miny']
	print('\t' + str(min_y))
	output.write(str(min_y) + ',')

	max_y = geo_ID_object['envelope']['maxy']
	print('\t' + str(max_y))
	output.write(str(max_y) + '\n')
	print('}')
