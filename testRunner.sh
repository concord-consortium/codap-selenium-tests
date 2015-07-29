#! /bin/bash
RESULT_FILE="testruntests.csv"
TRIALNUM=5
CASESNUM=10
TESTNUM=5
BROWSER=("chrome" "firefox")
i=0
b=0
printf "Time\t Browser\t Test No.\t Trials\t Cases\t Duration\t Duration(s)\n" >> $RESULT_FILE
tLen=${#BROWSER[@]}
printf "tLen is ${tLen}"
while [ $i -le $TESTNUM ];
do
   for  $b -le $tLen ];
    do
        START=$(date)
        START_SEC=$(date +"%s")
        ruby testPerformanceHarness.rb -t $TRIALNUM -c $CASESNUM -b ${BROWSER[$b]} -r codap.concord.org/releases/ -v latest
        END=$(date)
        END_SEC=$(date +"%s")
        DURATION=$(($END_SEC-$START_SEC))
        echo " Time end: $END    ${BROWSER[$b]} Test $i TrialNum: $TRIALNUM CaseNum; $CASESNUM Duration: $(($DURATION / 60))m $((DURATION % 60))s $DURATION s"
        printf "$END\t ${BROWSER[$b]}\t $i\t $TRIALNUM\t $CASESNUM\t  $(($DURATION / 60))m $((DURATION % 60))s\t $DURATION\n" >> $RESULT_FILE
        ((b++))
        printf "b=${b}"
    done
((i++))
printf "i=${i}"
done
