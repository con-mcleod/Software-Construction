#!/bin/sh

# to run this script:
# ssh z5058240@cse.unsw.edu.au -> cd public_html
# add file to public_html
# open "cse.unsw.edu.au/~z5058240/file" on chrome
# chmod 700 file


echo Content-type: text/html
echo

cat <<eof
<!DOCTYPE html>
<html lang="en">
<head></head>
<body>
<h2>Execution Environment</h2>
<pre>
eof
#comp2041_var="$QUERY_STRING"
#echo $comp2041_var | egrep -o "comp2041=[^&]*"
for command in pwd hostname id 'uname -a'
do
	echo "$command: `$command`"
done
cat <<eof
</pre>
</body>
</html>
eof