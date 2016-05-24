#!/bin/bash/python
# 
# Author: Sten Matikainen
#
#

import urllib2
import os

# Check if parameters are given
if len(sys.argv) != 3:
    print("Usage:", sys.argv[0], "<Address> <Filename>")
    exit(2)

# Open files
if os.path.isfile(sys.argv[1]):
    fIn = open(sys.argv[1], 'r')
    fOut = open(sys.argv[2], 'w')
else:
    print("The file you are trying to read does not exist.")
    exit(2)
    
# Run the thing
for line in fIn:

	url = line.split(",")
    print(url)
	response = urllib2.urlopen(url[0])
	html = response.read()
