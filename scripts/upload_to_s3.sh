#!/bin/bash

S3KEY=$S3KEY
S3SECRET=$S3SECRET

#continuous video monitoring and storing images to s3
while sleep 0.25; do

screencapture -r -x ~/Desktop/images/1.jpg

#Reduce screen size
sips -Z 1800 ~/Desktop/images/1.jpg

path="/Users/j.doshi/Desktop/images"
file="1.jpg"
aws_path='/'
bucket='atthack'
date=$(date +"%a, %d %b %Y %T %z")
acl="x-amz-acl:public-read"
content_type='image/jpg'
string="PUT\n\n$content_type\n$date\n$acl\n/$bucket$aws_path$file"
signature=$(echo -en "${string}" | openssl sha1 -hmac "${S3SECRET}" -binary | base64)
curl -X PUT -T "$path/$file" \
    -H "Host: $bucket.s3-us-west-2.amazonaws.com" \
    -H "Date: $date" \
    -H "Content-Type: $content_type" \
    -H "$acl" \
    -H "Authorization: AWS ${S3KEY}:$signature" \
    "https://$bucket.s3.amazonaws.com$aws_path$file"

done;
