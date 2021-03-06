#! /bin/bash

    . $HOME/.testRunnerrc
    i=0
    #TESTNUM=1
    RESULT_FILE="testPerformanceInflectionResult.csv"
    echo "TRIALNUM IS $TRIALNUM"
    echo "CASENUM IS $CASENUM"
    echo "GOOGLE_PATH IS $GOOGLE_PATH"
    printf "Browser\t Test No.\t Trials\t Cases\t Duration\t Duration(s)\n" >> $RESULT_FILE
    tLen=${#BROWSER[@]}
    echo "$tLen number of browsers"
   # while [ $i -lt $TESTNUM ]
   # do
    #    echo "begin i = $i"
        b=0
        while [ $b -lt $tLen ]
            do
                echo "begin b = $b"
                START=$(date)
                START_SEC=$(date +"%s")
                echo "Call testPerformanceInflection.rb"
                ruby testPerformanceInflection.rb -t $TRIALNUM -c $CASESNUM -b ${BROWSER[$b]} -r $CODAP_ROOT -v $CODAP_VERSION -p "$GOOGLE_PATH"
                echo "End testPerformanceHarness.rb"
                END=$(date)
                END_SEC=$(date +"%s")
                DURATION=$(($END_SEC-$START_SEC))
                echo "$BROWSER Test $i Time end: $END    TrialNum: $TRIALNUM CasesNum: $CASESNUM Duration: $(($DURATION / 60))m $(($DURATION % 60))s $DURATION s"
                printf "$BROWSER[$b]\t $i\t $TRIALNUM\t $CASESNUM\t  $(($DURATION / 60))m $(($DURATION % 60))s\t $DURATION\n" >> $RESULT_FILE
                if [ $b -lt $tLen ]; then
                    b=$(($b+1))
                fi
                echo "end b = $b"
            done
        START=$(date)
        START_SEC=$(date +"%s")

     #   i=$(($i+1))
     #   echo "end i = $i"
   # done