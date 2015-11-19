#! /bin/bash

    . $HOME/.testRunnerrc
    #PLATFORM=("mac" "win")
    #BROWSER=("firefox" "chrome" "ie")
    #pLen=${#PLATFORM[@]}
    i=0
    echo "TRIALNUM IS $TRIALNUM"
    echo "CASENUM IS $CASENUM"
    echo "GOOGLE_PATH IS $GOOGLE_PATH"
    printf "Browser\t Test No.\t Trials\t Cases\t Duration\t Duration(s)\n" >> $RESULT_FILE
    #tLen=${#BROWSER[@]}
    #echo "$tLen number of browsers"
    while [ $i -lt $TESTNUM ]
    do
        echo "begin i = $i"
            PLATFORM=("mac" "win")
            if [ $PLATFORM=="mac" ]; then
                BROWSER=("firefox" "chrome")
                echo "$tLen number of browsers"
            fi
            if [ $PLATFORM=="win" ]; then
                BROWSER=("firefox" "chrome" "ie")
                echo "$tLen number of browsers"
            fi
            pLen=${#PLATFORM[@]}
            tLen=${#BROWSER[@]}
        p=0
        while [ $p -lt $pLen ]
        do
            b=0
            while [ $b -lt $tLen ]
              do
                echo "begin b = $b"
                START=$(date)
                START_SEC=$(date +"%s")
                echo "Call testPerformanceHarness.rb"
                ruby testPerformanceHarness.rb -t $TRIALNUM -c $CASESNUM -b ${BROWSER[$b]} -m ${PLATFORM[$p]} -r $CODAP_ROOT -v $CODAP_VERSION -p "$GOOGLE_PATH"
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
              if [ $p -lt $pLen ]; then
                   p=$(($p+1))
              fi
        done
        START=$(date)
        START_SEC=$(date +"%s")

        i=$(($i+1))
        echo "end i = $i"
    done