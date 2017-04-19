#!/bin/bash
#drop database... remove later for original script implementation as it will only be called once
#rm "classes.db"

#numActs=1 #change later for while loop through activities links

#get curl link, parse, get activities link, parse html and store chopped down version to textfile
#curl 'http://apps.wcms.ecu.edu.au/semester-timetable/lookup?sq_content_src=%2BdXJsPWh0dHAlM0ElMkYlMkZvZnIwMi1hcHAtcDIub2ZyLmVjdS5lZHUuYXUlM0E3NzgwJTJGYXBwcyUyRnNtc2FwcHMlMkZzZW1lc3Rlcl90aW1ldGFibGUlMkZ2aWV3X3NlbV90YWJsZV9yYy5qc3AmYWxsPTE%3D' -H 'Cookie: sq-active-remote-session=1; SQ_SYSTEM_SESSION=dfonqboip9maegl0o2tmavpd8oeg8149fkatujgdcelon5udk0lff0kfn5fsdifhi87t50u3aae2c2bjtld6ol01fvn20tl4lt5j2r1; _baga=GA1.3.2131702218.1465388263; ecu_portal_type=null; ecu_portal=1; __utma=68087118.2131702218.1465388263.1466153712.1466747610.13; __utmc=68087118; __utmz=68087118.1465708615.7.3.utmcsr=ecu.edu.au|utmccn=(referral)|utmcmd=referral|utmcct=/; SSF_AUTH_SSOCID-17=991RFszArhwCZR4uP0l8u5wQfPnnZBZfxr2kKnfeRY0lv23ygDRMqhTGUPYUBDPbjL7FneywNKbjb/bpjh7ayMwUCpiWtrbXGlfRvo0bwARzZ47knAhhRaCZwgU4FAkBNqZ/YwgdiBYSmCEbNYw+aMLtQ1rt6se6QZ0yc7UqdMd9IkJjq7VPWc2oXDTLa+2N07hB7QPs3HelJQQUvG9Np+v3qH7R1hSGq+cb8jc9/3dbgiiqvMw0rN3ix23SxjyhNygpg9YBQ+7fpzxsn9f+u3daY1EFRdc+xD3p40IgTgG0zfQXJ/fLRjAjbBwMPqgwmT/; SSF_AUTH_LAST_COOKIE=sequence_number%3D17%3Bauth_type%3DSSOCID; optimizelyEndUserId=oeu1468808428113r0.7431712643224548; optimizelySegments=%7B%223327640794%22%3A%22gc%22%2C%223329040552%22%3A%22false%22%2C%223330841254%22%3A%22search%22%7D; optimizelyBuckets=%7B%7D; _ceg.s=obiqmp; _ceg.u=obiqmp; curFontSize=1.0em; _ga=GA1.3.2131702218.1465388263' -H 'Origin: http://apps.wcms.ecu.edu.au' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-GB,en-US;q=0.8,en;q=0.6' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: http://apps.wcms.ecu.edu.au/semester-timetable/overview' -H 'Connection: keep-alive' --data 'sq_content_src=%252BdXJsPWh0dHAlM0ElMkYlMkZvZnIwMi1hcHAtcDIub2ZyLmVjdS5lZHUuYXUlM0E3NzgwJTJGYXBwcyUyRnNtc2FwcHMlMkZzZW1lc3Rlcl90aW1ldGFibGUlMkZ2aWV3X3NlbV90YWJsZV9yYy5qc3AmYWxsPTE%253D&mode=&p_unit_cd=CSG6206&p_unit_title=&p_school=&p_ci_sequence_number=&p_ci_year=2016&p_campus=&p_mode=&cmdSubmit=Search' --compressed \
#| grep -i "Activities</a>" \
#| awk "NR==$numActs" \
#| awk 'BEGIN {FS="[\"]"}; {print $2}' \
#| xargs curl | grep -E "colspan|valign|strong" > activitieshtml2.txt

#Create Tables for Database
#sqlite3 classes.db "create table class(db_unitcode TEXT PRIMARY KEY, db_title TEXT, db_period TEXT, db_loc TEXT);"
#sqlite3 classes.db "create table activity(db_classnum INTEGER PRIMARY KEY, db_unitcoderef TEXT, db_descr TEXT);"

#!!!!!!!!from here; anything above is for original script & while loop
#Unitcode
cat activitieshtml2.txt \
| grep -i "<p>" \
| awk -F'>|<' {'print $9'} \
| awk 'BEGIN {FS=" "}; {print $1}' > var1.txt    #Need to find a better way to read these outputs instead of storing into textfiles after awk
unitCode=$(sed -n '1p' var1.txt)

#Title
cat activitieshtml2.txt \
| grep -i "<p>" \
| awk -F'>|<' {'print $9'} \
| awk 'BEGIN {FS=" "};{$1=""};{print $0}' \
| sed 's/^ *//' > var2.txt
title=$(sed -n '1p' var2.txt)
#echo $title

#Period
cat activitieshtml2.txt \
| grep -i "<p>" \
| awk -F'>|<' {'print $11'} \
| awk -F'(' {'print $2'} | awk -F')' {'print $1'} > var3.txt
period=$(sed -n '1p' var3.txt)

#Location
cat activitieshtml2.txt \
| grep -i "Campus" \
| awk -F'>|<' {'print $5'} \
| awk 'BEGIN {FS=" "};{$1=""};{print $0}' \
| sed 's/^ *//' > var4.txt
loc=$(sed -n '1p' var4.txt)


#Activities
cat activitieshtml2.txt \
| grep -E 'valign|strong' \
| sed 's/^ *//' \
| awk -F'>|<' {'print $3 $7 $5'} \
| grep -E 'LECTURE|LAB|SEMINAR|MON|TUE|WED|THU|FRI|:|JO|ML|BU' \
| sed '/LECTURE/i *' | sed '/LAB/i *' | sed '/SEMINAR/i *' > activities.txt

#To SEGMENT by Class type i.e. LAB/LECT/SEM and their referenced classes; is concatenated with commas for division later
paste -d, -s activities.txt \
| awk -F'*' '{printf "%s\n%s", $2,$3 }' > activities2.txt 


#Reading segmented classes line by line and remove commas between words
oldIFS="$IFS"
IFS=$'\n' arr=($(<activities2.txt))
IFS="$oldIFS"
for i in "${arr[@]}"
do
	printf "%s\n" "$i" | awk -F',' '{$1=""; print $0}' 
done > activities3.txt

#Open and read activities again to store into db because of awk-ing :(
oldIFS="$IFS"
IFS=$'\n' db_act=($(<activities3.txt))
IFS="$oldIFS"
for i in "${db_act[@]}"
do
	#activity table INSERT statements
	sqlite3 classes.db "INSERT INTO activity (db_unitcoderef,db_descr) VALUES ('$unitCode','$i');"
done

#class table INSERT statements 
sqlite3 classes.db "INSERT INTO class (db_unitcode,db_title,db_period,db_loc) VALUES ('$unitCode','$title','$period','$loc');"



#SELECT statements
#sqlite3 classes.db "select * from class;"
#sqlite3 classes.db "select * from activity;"
#Output to file in human readable format
sqlite3 -column -header classes.db "SELECT db_unitcode AS 'Unit Code', db_title AS 'Title', db_period AS 'Period', db_loc AS 'Location', db_descr AS 'Description' FROM class LEFT OUTER JOIN activity ON db_unitcode=db_unitcoderef"  > Timetable.txt


#Remove variable files
rm var1.txt | rm var2.txt | rm var3.txt | rm var4.txt | rm activities.txt | rm activities2.txt |rm activities3.txt |rm activitieshtml2.txt

