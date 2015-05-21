# Pygeocoder main page: https://pypi.python.org/pypi/pygeocoder 
# Documentation: http://code.xster.net/pygeocoder/wiki/Home
# sudo pip install pygeocoder
from pygeocoder import Geocoder

results = Geocoder.reverse_geocode(40.714224, -73.961452)

print(results[0].postal_code)