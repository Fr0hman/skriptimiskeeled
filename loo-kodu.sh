#!/bin/bash
#Autor: Sten Matikainen
#
#Script loob uue veebikodu
#
# V0.18

export LC_ALL=C

#Muuda ooteaega käskude vahel siin sekundites
SLEEPTIME="0"

#Kontrollib, kas skript on käivitatud juurkasutajana
if [ $UID -ne 0 ]
then
  echo "käivita skript juurkasutaja õigustes"
  exit 1
fi

#Kontrollib, kas on ette antud õige arv muutujaid
if [ $# -eq 1 ]
then
  AADRESS=$1
else 
  echo "kasuta skripti nii: $(basename $0) www.minuveebisait.ee"
  exit 1
fi
sleep $SLEEPTIME

#Kontrollib, kas selline veebikodu on juba olemas
grep $AADRESS /etc/hosts > /dev/null 2>&1 && echo "Aga selline veebikodu on juba olemas" && exit 1

#Kontrollib, kas apache on paigaldatud (vajadusel paigaldab)
type apache2 > /dev/null 2>&1
if [ $? -ne 0 ]
then
  echo "Apache2 pole paigaldatud. Paigaldan Apache2-e."
  apt-get update > /dev/null 2>&1 && apt-get install apache2 -y > /dev/null 2>&1 || exit 1
fi
sleep $SLEEPTIME

#Nimelahendus
echo "Loon nimelahenduse /etc/hosts faili."
sleep $SLEEPTIME
echo "127.0.0.1     $AADRESS" >> /etc/hosts

#Confifaili koopia
echo "Confifailist teen koopia"
sleep $SLEEPTIME
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$AADRESS.conf

#Confifaili muutmine
echo "Now time for sed. I hope this works!"
sleep $SLEEPTIME
sed -i "s-#ServerName www.example.com-ServerName $AADRESS-g" /etc/apache2/sites-available/$AADRESS.conf
sed -i "s-/var/www/html-/var/www/$AADRESS-g" /etc/apache2/sites-available/$AADRESS.conf

#Veebisaidi füüsiline kodu
echo "Loon veebisaidi kataloogi: /var/www/$AADRESS"
sleep $SLEEPTIME
mkdir -p /var/www/$AADRESS

#Default index faili kopeerimine
echo "Lisan vaikimisi index faili."
sleep $SLEEPTIME
cp /var/www/html/index.html /var/www/$AADRESS/index.html

#Index faili muutmine
echo "Muudan index.html-i sisu"
sleep $SLEEPTIME
echo "<html><head><title>$AADRESS</title></head><body><h1>$AADRESS</h1></body></html>" > /var/www/$AADRESS/index.html

#Luban virtuaalserveri kasutuse
echo "Luban saidi"
a2ensite $AADRESS

#Reload apachele
echo "Teen sambale reloadi."
sleep $SLEEPTIME
service apache2 reload > /dev/null

exit 0
