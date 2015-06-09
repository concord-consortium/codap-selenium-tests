#! /bin/bash

RESULT_FILE="testrun.csv"
TRIALNUM=5
CASESNUM=20
TESTNUM=3
BROWSER=("chrome", "firefox")
i=1
b=1
printf "Browser\t Test No.\t Trials\t Cases\t Duration\t Duration(s)\n" >> $RESULT_FILE
tLen=${#BROWSER[@]}
while [ $i -le $TESTNUM ]
do
    while [ $b -le $tLen ]
        do
            START=$(date)
            START_SEC=$(date +"%s")
            ruby testPerformanceHarness.rb -t $TRIALNUM -c $CASESNUM -b ${BROWSER[$b]}
            END=$(date)
            END_SEC=$(date +"%s")
            DURATION=$(($END_SEC-$START_SEC))
            echo "$BROWSER Test $i Time end: $END    TrialNum: $TRIALNUM CasesNum: $CASESNUM Duration: $(($DURATION / 60))m $(($DURATION % 60))s $DURATION s"
            printf "$BROWSER\t $i\t $TRIALNUM\t $CASESNUM\t  $(($DURATION / 60))m $(($DURATION % 60))s\t $DURATION\n" >> $RESULT_FILE
            b=$(($b+1))
        done
    START=$(date)
    START_SEC=$(date +"%s")

    i=$(($i+1))
done