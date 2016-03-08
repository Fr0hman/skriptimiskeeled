#!/bin/bash
#Autor: Sten Matikainen
#
#Script jagab etteantud grupile kasutamiseks uue kausta.
#
# V0.1

export LC_ALL=C

#Kontrollib, kas skript on käivitatud juurkasutajana
if [ $UID -ne 0 ]
then
  echo "käivita skript juurkasutaja õigustes"
  exit 1
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
    exit 1
  fi
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

#Kontrollib, kas grupp on olemas (vajadusel loob)
getent group $GRUPP > /dev/null 2>&1 || echo "Gruppi pole. Loon grupi!" && addgroup $GRUPP > /dev/null 2>&1

#Kas selline share on juba olemas?
grep $SHARE /etc/samba/smb.conf > /dev/null && echo "Selline share ($SHARE) juba on olemas!" && exit 0

#Teeb konfifailist varukoopia
echo "Teen /etc/samba/smb.conf failist varukoopia"
cp /etc/samba/smb.conf /etc/samba/smb.conf.old

#Uus rida konfifaili
cat >> /etc/samba/smb.conf <<EOF

[$SHARE]
 path=$KAUST
 writable=yes
 valid users=@$GRUPP
 force group=$GRUPP
 browsable=yes
 create mask=0664
 directory mask=0775
EOF
echo "Read konfifaili lisatud."

#Reload sambale
echo "Teen sambale reloadi."
/etc/init.d/smbd reload || echo "Reloadi ei toimunud, midagi läks valesti." && exit 1

echo "All Done!"