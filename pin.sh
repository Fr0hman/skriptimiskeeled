#!/bin/bash
#autor: Sten Matikainen

SLEEPTIME=1

#Loeb PIN numbri
if [ $# -eq 1 ]
  then
    PIN=$1
else
  
  for i in $( seq 0 9999 )
    do
      printf "%04d\n" "$i"
  done
  
  exit 1
fi

#Väljastab PIN-e kuni etteantud PIN-ini
for i in $( seq 0 $PIN )
  do
    printf "%04d\n" "$i"
done

#Loob kausta
echo "Loon kausta!"
sleep $SLEEPTIME
test -d $PIN || mkdir -p $PIN

#Loob faili, kui on juba olemas, lisab numbri
FAILINIMI=koodid.txt
if [[ -e $PIN/$FAILINIMI.txt ]] ; then
    j=0
    while [[ -e $PIN/$FAILINIMI-$j.txt ]] ; do
        let j++
    done
    FAILINIMI=$FAILINIMI-$j.txt
fi
echo "Loon faili!"
sleep $SLEEPTIME
touch $PIN/$FAILINIMI

#Väljastab ja kirjutab faili PIN-id alates etteantud PIN-ist
for i in $( seq $PIN 9999 )
  do
    printf "%04d\n" "$i"
    printf "%04d\n" "$i" >> $PIN/$FAILINIMI
done


exit 0