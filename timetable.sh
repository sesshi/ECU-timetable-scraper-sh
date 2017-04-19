#!/bin/bash
#Delete database
rm classes.db

#Create Tables
sqlite3 classes.db "create table class(db_unitcode TEXT PRIMARY KEY, db_title TEXT, db_period TEXT, db_loc TEXT);"
sqlite3 classes.db "create table activity(db_classnum INTEGER PRIMARY KEY, db_unitcoderef TEXT, db_descr TEXT);"


#Loop through unitcodes
while read var
do
	if [ ! -z $var ]; then
		#Count number of Activities returned for unitcode
		numActs=$(curl "http://apps.wcms.ecu.edu.au/semester-timetable/lookup?sq_content_src="%"2BdXJsPWh0dHAlM0ElMkYlMkZvZnIwMi1hcHAtcDIub2ZyLmVjdS5lZHUuYXUlM0E3NzgwJTJGYXBwcyUyRnNtc2FwcHMlMkZzZW1lc3Rlcl90aW1ldGFibGUlMkZ2aWV3X3NlbV90YWJsZV9yYy5qc3AmYWxsPTE"%"3D" -H "Cookie: sq-active-remote-session=1; SQ_SYSTEM_SESSION=dfonqboip9maegl0o2tmavpd8oeg8149fkatujgdcelon5udk0lff0kfn5fsdifhi87t50u3aae2c2bjtld6ol01fvn20tl4lt5j2r1; _baga=GA1.3.2131702218.1465388263; ecu_portal_type=null; ecu_portal=1; __utma=68087118.2131702218.1465388263.1466153712.1466747610.13; __utmc=68087118; __utmz=68087118.1465708615.7.3.utmcsr=ecu.edu.au|utmccn=(referral)|utmcmd=referral|utmcct=/; SSF_AUTH_SSOCID-17=991RFszArhwCZR4uP0l8u5wQfPnnZBZfxr2kKnfeRY0lv23ygDRMqhTGUPYUBDPbjL7FneywNKbjb/bpjh7ayMwUCpiWtrbXGlfRvo0bwARzZ47knAhhRaCZwgU4FAkBNqZ/YwgdiBYSmCEbNYw+aMLtQ1rt6se6QZ0yc7UqdMd9IkJjq7VPWc2oXDTLa+2N07hB7QPs3HelJQQUvG9Np+v3qH7R1hSGq+cb8jc9/3dbgiiqvMw0rN3ix23SxjyhNygpg9YBQ+7fpzxsn9f+u3daY1EFRdc+xD3p40IgTgG0zfQXJ/fLRjAjbBwMPqgwmT/; SSF_AUTH_LAST_COOKIE=sequence_number"%"3D17"%"3Bauth_type"%"3DSSOCID; optimizelyEndUserId=oeu1468808428113r0.7431712643224548; optimizelySegments="%"7B"%"223327640794"%"22"%"3A"%"22gc"%"22"%"2C"%"223329040552"%"22"%"3A"%"22false"%"22"%"2C"%"223330841254"%"22"%"3A"%"22search"%"22"%"7D; optimizelyBuckets="%"7B"%"7D; _ceg.s=obiqmp; _ceg.u=obiqmp; curFontSize=1.0em; _gat=1; _ga=GA1.3.2131702218.1465388263" -H "Origin: http://apps.wcms.ecu.edu.au" -H "Accept-Encoding: gzip, deflate" -H "Accept-Language: en-GB,en-US;q=0.8,en;q=0.6" -H "Upgrade-Insecure-Requests: 1" -H "User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Cache-Control: max-age=0" -H "Referer: http://apps.wcms.ecu.edu.au/semester-timetable/lookup?sq_content_src="%"2BdXJsPWh0dHAlM0ElMkYlMkZvZnIwMi1hcHAtcDIub2ZyLmVjdS5lZHUuYXUlM0E3NzgwJTJGYXBwcyUyRnNtc2FwcHMlMkZzZW1lc3Rlcl90aW1ldGFibGUlMkZ2aWV3X3NlbV90YWJsZV9yYy5qc3AmYWxsPTE"%"3D" -H "Connection: keep-alive" --data "sq_content_src="%"252BdXJsPWh0dHAlM0ElMkYlMkZvZnIwMi1hcHAtcDIub2ZyLmVjdS5lZHUuYXUlM0E3NzgwJTJGYXBwcyUyRnNtc2FwcHMlMkZzZW1lc3Rlcl90aW1ldGFibGUlMkZ2aWV3X3NlbV90YWJsZV9yYy5qc3AmYWxsPTE"%"253D&mode=&p_unit_cd="${var}"&p_unit_title=&p_school=&p_ci_sequence_number=&p_ci_year="${1}"&p_campus=&p_mode=&cmdSubmit=Search" --compressed \
		| grep -i "Activities</a>" | wc -l)
	#	echo $numActs

		if [ ${numActs} -ne 0 ]; then
			#Grep Activities Links
			curl "http://apps.wcms.ecu.edu.au/semester-timetable/lookup?sq_content_src="%"2BdXJsPWh0dHAlM0ElMkYlMkZvZnIwMi1hcHAtcDIub2ZyLmVjdS5lZHUuYXUlM0E3NzgwJTJGYXBwcyUyRnNtc2FwcHMlMkZzZW1lc3Rlcl90aW1ldGFibGUlMkZ2aWV3X3NlbV90YWJsZV9yYy5qc3AmYWxsPTE"%"3D" -H "Cookie: sq-active-remote-session=1; SQ_SYSTEM_SESSION=dfonqboip9maegl0o2tmavpd8oeg8149fkatujgdcelon5udk0lff0kfn5fsdifhi87t50u3aae2c2bjtld6ol01fvn20tl4lt5j2r1; _baga=GA1.3.2131702218.1465388263; ecu_portal_type=null; ecu_portal=1; __utma=68087118.2131702218.1465388263.1466153712.1466747610.13; __utmc=68087118; __utmz=68087118.1465708615.7.3.utmcsr=ecu.edu.au|utmccn=(referral)|utmcmd=referral|utmcct=/; SSF_AUTH_SSOCID-17=991RFszArhwCZR4uP0l8u5wQfPnnZBZfxr2kKnfeRY0lv23ygDRMqhTGUPYUBDPbjL7FneywNKbjb/bpjh7ayMwUCpiWtrbXGlfRvo0bwARzZ47knAhhRaCZwgU4FAkBNqZ/YwgdiBYSmCEbNYw+aMLtQ1rt6se6QZ0yc7UqdMd9IkJjq7VPWc2oXDTLa+2N07hB7QPs3HelJQQUvG9Np+v3qH7R1hSGq+cb8jc9/3dbgiiqvMw0rN3ix23SxjyhNygpg9YBQ+7fpzxsn9f+u3daY1EFRdc+xD3p40IgTgG0zfQXJ/fLRjAjbBwMPqgwmT/; SSF_AUTH_LAST_COOKIE=sequence_number"%"3D17"%"3Bauth_type"%"3DSSOCID; optimizelyEndUserId=oeu1468808428113r0.7431712643224548; optimizelySegments="%"7B"%"223327640794"%"22"%"3A"%"22gc"%"22"%"2C"%"223329040552"%"22"%"3A"%"22false"%"22"%"2C"%"223330841254"%"22"%"3A"%"22search"%"22"%"7D; optimizelyBuckets="%"7B"%"7D; _ceg.s=obiqmp; _ceg.u=obiqmp; curFontSize=1.0em; _gat=1; _ga=GA1.3.2131702218.1465388263" -H "Origin: http://apps.wcms.ecu.edu.au" -H "Accept-Encoding: gzip, deflate" -H "Accept-Language: en-GB,en-US;q=0.8,en;q=0.6" -H "Upgrade-Insecure-Requests: 1" -H "User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Cache-Control: max-age=0" -H "Referer: http://apps.wcms.ecu.edu.au/semester-timetable/lookup?sq_content_src="%"2BdXJsPWh0dHAlM0ElMkYlMkZvZnIwMi1hcHAtcDIub2ZyLmVjdS5lZHUuYXUlM0E3NzgwJTJGYXBwcyUyRnNtc2FwcHMlMkZzZW1lc3Rlcl90aW1ldGFibGUlMkZ2aWV3X3NlbV90YWJsZV9yYy5qc3AmYWxsPTE"%"3D" -H "Connection: keep-alive" --data "sq_content_src="%"252BdXJsPWh0dHAlM0ElMkYlMkZvZnIwMi1hcHAtcDIub2ZyLmVjdS5lZHUuYXUlM0E3NzgwJTJGYXBwcyUyRnNtc2FwcHMlMkZzZW1lc3Rlcl90aW1ldGFibGUlMkZ2aWV3X3NlbV90YWJsZV9yYy5qc3AmYWxsPTE"%"253D&mode=&p_unit_cd="${var}"&p_unit_title=&p_school=&p_ci_sequence_number=&p_ci_year="${1}"&p_campus=&p_mode=&cmdSubmit=Search" --compressed \
			| grep -i "Activities</a>" \
			| awk "NR==$numActs" \
			| awk 'BEGIN {FS="[\"]"}; {print $2}' \
			| xargs curl | grep -E "colspan|valign|strong" > activitieshtml2.txt
	
			#Call Script to sculpt html from Semester Timetable Pages and store into database
			./timetableactivities.sh
		fi
	fi
done
