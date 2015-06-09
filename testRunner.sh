#! /bin/bash

RESULT_FILE="testrun.csv"
printf "Browser\t Test No.\t Trials\t Cases\t Duration\t Duration(s)\n" >> $RESULT_FILE
TRIALNUM=5
CASESNUM=20
BROWSER=("chrome", "firefox")

i=1

tLen=${#BROWSER[@]}
while [ $i -le 3 ]
do
    for ((b=0; b<${tLen}; b++));
        do
            START=$(date)
            START_SEC=$(date +"%s")
            ruby testLogin.rb -t $TRIALNUM -c $CASESNUM -b ${BROWSER[$b]}
            END=$(date)
            END_SEC=$(date +"%s")
            DURATION=$(($END_SEC-$START_SEC))
            echo "$BROWSER Test $i Time end: $END    TrialNum: $TRIALNUM CasesNum: $CASESNUM Duration: $(($DURATION / 60))m $(($DURATION % 60))s $DURATION s"
            printf "$BROWSER\t $i\t $TRIALNUM\t $CASESNUM\t  $(($DURATION / 60))m $(($DURATION % 60))s\t $DURATION\n" >> $RESULT_FILE
        done
    START=$(date)
    START_SEC=$(date +"%s")

    i=$(($i+1))
done