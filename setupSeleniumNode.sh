#! /bin/bash

SELENIUM_SERVER_MAC="selenium-server-standalone-2.53.0.jar"

cd $HOME/Applications
java -jar $SELENIUM_SERVER_MAC -role node -hub http://$1:4444/grid/register -host $1