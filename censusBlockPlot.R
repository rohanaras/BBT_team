# Plots all the census blocks with a stop in the KCM system
f = read.csv('geo_IDs.csv')
plot(f$max_x, f$max_y)