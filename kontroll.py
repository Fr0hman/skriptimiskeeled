#!/usr/bin/python
# Author: Sten Matikainen
#
# Pythoni kontrolltöö
#
# Ver 1.0
#
######################################################################

import sys
import os
import random
import string

# Kontrolli parameetrite arvu
if len(sys.argv) < 3:
    print("Kasutamine:", sys.argv[0], "<FileContainingURLs> <FileToWriteTo>")
    exit(1)

# Kontrolli, kas sisendfail eksisteerib, kui jah, ava see
if os.path.isfile(sys.argv[1]):
    try:
        fIn = open(sys.argv[1], 'r')
        fOut = open(sys.argv[2], 'a')
    except IOError:
        print("Ei saanud faili avada/luua")
        exit(1)
else:
    print("Sellist sisendfaili ei ole olemas!")
    exit(1)

# Loe sisendfaili
next(fIn)
for line in fIn:

    # Ignoreerin tühje ridu
    if line == "\n":
        continue
    if line == " \n":
        continue

    varTab = line.split('\t')
    varNoTab = varTab[1]

    kasutajanimi = varNoTab.split(" ")
    kasutajanimi = kasutajanimi[0][0].lower() + kasutajanimi[1].lower()

    nimi = varNoTab.split(" ")[0] + " " + varNoTab.split(" ")[1]

    email = varNoTab.split(" ")[0].lower() + "." + varNoTab.split(" ")[1].lower()
    email = email + "@itcollege.ee"

    token = varNoTab.split(" ")[2] + ''.join(random.SystemRandom().choice("-_" + string.digits+ string.ascii_letters) for _ in range(20))

    try:
        fOut.write(kasutajanimi[:8] + "," + nimi + "," + email + "," + token[:20] + "\n")
    except IOError:
        print("Midagi läks valesti.")
        exit(1)

exit(0)