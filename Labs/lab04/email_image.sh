#!/bin/sh

for image in "$@"
do
	display "$image"
	echo "Address to e-mail this image to?"
	read email
	echo "Email subject line?"
	read subject
	echo "Message to accompany image?"
	read message
	echo "$message" | mutt -s "$subject" -e 'set copy=no' -a $image -- $email
	echo $image sent to $email
done