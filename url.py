#!/usr/bin/python
# Author: Sten Matikainen
#
# The script will read lines from input text file (parameter 1), request the source code of url-s
# in the input file, then compare the requested source code and searchword. (Also from the input
# file.) If it finds a match, it will append the same url, searchword and now a confirmation
# ("Yes" or "No") into the output file. (parameter 2)
# Also allows to use a third parameter for selecting to write(w) or append(a) to output file.
#
# Version 1.1
#
#################################################################################################

import sys
import os
import urllib.request

# showProgress variable, change this if you want
showProgress = True

# Check if parameters are given
if len(sys.argv) < 3:
    print("Usage:", sys.argv[0], "<FileContainingURLs> <FileToWriteTo> [a / w]")
    print("\n<Mandatory> [optional]")
    exit(2)

# Set and check if extra argument is given (append or write)
option = 'a'
if len(sys.argv) == 4:
    if (sys.argv[3] == 'a') or (sys.argv[3] == 'w'):
        option = sys.argv[3]

# Check if input file exists, if it does, open both files, input in read and output in selected mode
if os.path.isfile(sys.argv[1]):
    fIn = open(sys.argv[1], 'r')
    fOut = open(sys.argv[2], option)
else:
    print("The file you are trying to read does not exist.")
    exit(2)

# Set numError variable for number of lines skipped and lines variable for total lines
numError = 0
lines = 0

# For every line, we check if the given URL has matching string
for line in fIn:

    if showProgress == True:
        print("*")
    lines += 1

    pair = (str.split(line))
    url = pair[0]

    # Prepend "http://" in case it is missing
    if not url.startswith('http://'):
        url = 'http://' + url

    # Check if search word is missing or not
    if len(pair) < 2:
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
        value = "No"
    else:
        value = "Yes"

    # If everything went well, write the line to output file
    fOut.write(url + " " + searchString + " " + value + "\n")

# Print the outcome and number of errors if there were any
if numError > 0:
    print("Checked", lines, "URL-s from", sys.argv[1])
    print("Wrote output to", sys.argv[2])
    print("#######################################")
    print("Finished with", numError, "errors.")
    exit(1)
else:
    print("Checked", lines, "URL-s from", sys.argv[1])
    print("Wrote output to", sys.argv[2])
    print("#######################################")
    print("Finished without errors.")

exit(0)
