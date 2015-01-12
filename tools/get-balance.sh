#!/bin/sh

USER="test%40example.com"
PASS="verysecretpassword"

URL1="https://ss.zadarma.com/auth/"
URL2="https://ss.zadarma.com/"

HEADERS="/tmp/zadarma.headers.$$"
COOKIES="/tmp/zadarma.cookies.$$"
touch $COOKIES
chmod 600 $COOKIES

CURL=$(which curl)

$CURL -s -D $HEADERS --insecure --cookie-jar $COOKIES --data "p=&email=$USER&password=$PASS&login_submit_btn=%D0%B2%D0%BE%D0%B9%D1%82%D0%B8" $URL1 > /dev/null

grep -q "^Location:" $HEADERS
if [ $? = 0 ]; then
  $CURL -s --insecure --cookie $COOKIES $URL2 | grep balance | sed -E 's/.*\$(.+)<\/a.*/\1/'
else
  echo "Unauthorized"
fi
