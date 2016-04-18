#! /bin/bash

SELENIUM_SERVER_MAC="selenium-server-standalone-2.53.0.jar"
IP=$(ipconfig getifaddr en1)

cd $HOME/Applications
java -jar $SELENIUM_SERVER_MAC -role hub -host $IP

