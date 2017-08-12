#!/bin/sh

courseCode=$1

undergrad=`wget -q -O- "http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr=$courseCode" | egrep -o "$courseCode[0-9]{4}.*</A>" | sed s/'.html">'/' '/g | sed s/'<\/A'//g | sed s/'>'//g | sort | uniq | uniq -w8 > ug`
postgrad=`wget -q -O- "http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Postgraduate&descr=$courseCode" | egrep -o "$courseCode[0-9]{4}.*</A>" | sed s/'.html">'/' '/g | sed s/'<\/A'//g | sed s/'>'//g | sort | uniq | uniq -w8 > pg`

merged=`cat ug pg | sort | uniq | uniq -w8`
rm ug pg
echo "$merged"