#!/bin/bash/python
#
# Author: Sten Matikainen
#

import time
import urllib2
import sys

# Check if parameters are given
if len(sys.argv) != 3:
    print("Usage:", sys.argv[0], "<Address> <Filename>")
    exit(2)

# Open files
try:
    fIn = open(sys.argv[2], "r")
except IOError:
    print "Error: File does not appear to exist."
    exit(2)

# Run the thing
for line in fIn:

    url = sys.argv[1] + line.split(",")[0]
    search_string = line.split(",")[1].split("\n")[0]

     # Prepend "http://" in case it is missing
    if not url.startswith('http://'):
        url = 'http://' + url

    # Try to get the source code, if it fails, skip iteration

    try:
        response = urllib2.urlopen(url)
        contents = response.read()
    except urllib2.URLError, error:
        contents = error.read()

    # Search for the search_string
    if str(contents).find(search_string) == -1:
        result = "NOK"
    else:
        result = "OK"

    # Print
    print(url + "," + search_string + "," + time.strftime("%Y-%m-%d_%H-%M-%S") + "," + result)

exit(1)