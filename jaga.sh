#!/bin/bash
#Autor: Sten Matikainen
#
#Script jagab etteantud grupile kasutamiseks uue kausta.
#
# V0.2

export LC_ALL=C

#Kontrollib, kas skript on käivitatud juurkasutajana
if [ $UID -ne 0 ]
then
  echo "käivita skript juurkasutaja õigustes"
  exit 0
fi

#Kontrollib, kas on ette antud õige arv muutujaid
if [ $# -eq 2 ]
then
  KAUST=$1
  GRUPP=$2
  SHARE=$1
else 
  if [ $# -eq 3 ]
  then
    KAUST=$1
    GRUPP=$2
    SHARE=$3
  else
    echo "kasuta sktipti nii: $(basename $0) KAUST GRUPP [SHARE]"
    exit 0
  fi
fi

#Kontrollib, kas kausta muutujas on mingi imelik asi või mitte ( / või . )
if [ $KAUST == "." ] || [ $KAUST == "/" ]
then
  echo "Kausta parameeter valesti sisestatud."
  exit 0
fi

#Kontrollib, kas samba on paigaldatud (vajadusel paigaldab)
type smbd > /dev/null 2>&1 

if [ $? -ne 0 ]
then
  echo "Paigaldan samba."
  apt-get update > /dev/null 2>&1 && apt-get install samba -y > /dev/null 2>&1 || exit 1 
fi

#Kontrollib, kas kaust on olemas (vajadusel loob)
test -d $KAUST || echo "Kausta pole. Loon kausta!" && mkdir -p $KAUST
sleep 0.1

#Kontrollib, kas grupp on olemas (vajadusel loob)
getent group $GRUPP > /dev/null 2>&1 || echo "Gruppi pole. Loon grupi!" && addgroup $GRUPP > /dev/null 2>&1
sleep 0.1

#Kas selline share on juba olemas?
grep $SHARE /etc/samba/smb.conf > /dev/null && echo "Selline share ($SHARE) juba on olemas!" && exit 0

#Teeb konfifailist varukoopia
echo "Teen /etc/samba/smb.conf failist varukoopia"
cp /etc/samba/smb.conf /etc/samba/smb.conf.old
sleep 0.1

#Uus rida testkonfifaili
echo "Lisan read testkonfifaili"
sleep 0.1
cat >> /etc/samba/smb.conf.test <<EOF

[$SHARE]
 path=$KAUST
 writable=yes
 valid users=@$GRUPP
 force group=$GRUPP
 browsable=yes
 create mask=0664
 directory mask=0775
EOF

#Testi, kas conf on okei
testparm -s /etc/samba/smb.conf.test > /dev/null 2>&1
if [ $? -eq 0 ]
  then
    echo "Conf OK!"
  else
    echo "Conf ERROR!"
    exit 0
fi
sleep 0.1

#Testfail live keskkonda
cp /etc/samba/smb.conf.test /etc/samba/smb.conf
echo "Read konfifaili lisatud."
sleep 0.1

#Reload sambale
echo "Teen sambale reloadi."
sleep 0.1
/etc/init.d/smbd reload > /dev/null 2>&1 || echo "Reloadi ei toimunud, midagi läks valesti." && exit 0