#!/bin/sh


# print HTTP header
# its best to print the header ASAP because 
# debugging is hard if an error stops a valid header being printed

echo Content-type: text/html
echo

# print page content

cat <<eof
<!DOCTYPE html>
<html lang="en">
<head>
<title>Browser IP, Host and User Agent</title>
</head>
<body>
<pre>
eof

browserIP=`env | sed 's/&/\&amp;/;s/</\&lt;/g;s/>/\&gt;/g' | egrep "REMOTE_ADDR" | egrep -o "[0-9\.]*"`
browserHostName=`host "$browserIP" | egrep -o "crawl.*com"`
browserID=`env | sed 's/&/\&amp;/;s/</\&lt;/g;s/>/\&gt;/g' | egrep "HTTP_USER_AGENT" | egrep -o "Mozilla.*"`


echo -n "Your browser is running at IP address: $browserIP"
echo "<br>"
echo -n "Your browser is running on hostname: $browserHostName"
echo "<br>"
echo -n "Your browser identifies as: $browserID"

cat <<eof
</pre>
</body>
</html>
eof