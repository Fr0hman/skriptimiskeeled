#!/usr/bin/python
# Author: Sten Matikainen
#
# The script will read lines from input text file (parameter 1), request the source code of url-s
# in the input file, then compare the requested source code and searchword. (Also from the input
# file.) If it finds a match, it will append the same url, searchword and now a confirmation
# ("Yes" or "No") into the output file. (parameter 2)
# Also allows to use a third parameter for selecting to write(w) or append(a) to output file.
#
#################################################################################################

import sys
import os
import urllib.request

# Check if parameters are given
if len(sys.argv) < 3:
    print("Usage:", sys.argv[0], "<FileContainingURLs> <FileToWriteTo> [a / w]")
    print("<Mandatory> [optional]")
    exit(2)

# Set and check if extra argument is given (append or write)
option = 'a'
if len(sys.argv) == 4:
    if (sys.argv[3] == 'a') or (sys.argv[3] == 'w'):
        option = sys.argv[3]

# Check if input file exists, if it does, open both files, input in read and output in append mode
if os.path.isfile(sys.argv[1]):
    fIn = open(sys.argv[1], 'r')
    fOut = open(sys.argv[2], option)
else:
    print("The file you are trying to read does not exist.")
    exit(2)

# Set numError variable for number of lines skipped
numError = 0

# For every line we check if the given URL has matching string
for line in fIn:

# Define variables for simpler code
    pair = (str.split(line))
    url = pair[0]
    if not url.startswith('http://'):   # Prepend "http://" in case it is missing
        url = 'http://' + url
    if len(pair) < 2:   # Check if search word is missing or not
        numError += 1
        continue
    searchString = pair[1]

# Try to get the source code, if it fails, skip iteration
    try:
        response = urllib.request.urlopen(url)
    except urllib.request.URLError:
        numError += 1
        continue
    source = response.read()

# If the source code has searchString in it, the value is "Yes", else "No"
    if str(source).find(searchString) == -1:
        value = "Yes"
    else:
        value = "No"

# If everything went well, write the line to output file
    fOut.write(url + " " + searchString + " " + value + "\n")

# Print the outcome and number of errors if there were any
if numError > 0:
    print("Finished with ", numError, " errors.")
    exit(1)
else:
    print("Finished without errors.")

exit(0)
