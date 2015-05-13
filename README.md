codap-selenium-tests
==================

Selenium tests of CODAP



Installation
====

1. CODAP's Selenium tests are written in Ruby. The Selenium Webdriver has to be added to your Ruby environment using the following command:

    ```
    gem install selenium-webdriver
    ```

2. Clone the codap-selenium-tests git repository to your computer:

    ```
    git clone https://github.com/concord-consortium/codap-selenium-tests.git
    ```
3. To run the test in Firefox, no other installation is needed.

   To run the test in Chrome, ChromeDriver needs to be installed and added to your system PATH
   Download ChromeDriver [here](https://sites.google.com/a/chromium.org/chromedriver/downloads)



Usage
====

### testPerformanceHarness.rb
`testPerformanceHarness.rb` runs the CODAP data interactive Peformance Harness. This test can be used to generate data and benchmark the data generation rate.
`testPerformanceHarness.rb -h` shows available options and their descriptions

    
    Usage: testPerformanceHarness.rb [options]
    
    Specific options:
        -b, --browser BROWSER            Browser that should be tested (Chrome, Firefox), default Chrome.
        -v, --version VERSION            CODAP version that should be tested. Build numbers are generally in the form of build_0xxx. Default is "latest"
        -r, --root_dir ROOTDIR           Root directory of CODAP. Default is localhost:4020/dg. Another common root is codap.concord.org/releases/.
        -w, --[no]-write WRITE           Writes test result into a new file (filename must be specified). Default is to append to the file testPFResultDefault_version.csv
        -f, --filename FILENAME          Specify a filename for where to write the results of the test. This must be specified if writing to a new file. CODAP version to be tested is appended to the filename.
        -p, --path PATH                  Specify path where the result file should be saved to. Default is Google Drive/CODAP @ Concord/Software Development/QA.
        -t, --trials NUMBER OF TRIALS    Specify the number of runs of Performance Harness. Default is 1
        -c, --cases NUMBER OF CASES      Specify the number of cases Performance Harness should generate. Default is 100.
        -d, --delay DELAY BETWEEN TRIALS Specify the delay between trials in ms Default is 1
        -s, --sleep SLEEP TIME           Specify sleep time between runs. Default is 1
    
  

Examples:
    `ruby testPerformanceHarness.rb -b Chrome` runs script in Chrome  
    `ruby testPerformanceHarness.rb -r codap.concord.org/releases/ -v build_0293` will run Performance Harness in codap.concord.org/releases/build_0293   
    `ruby testPerformanceHarness.rb -p Documents/CODAP data -f testrun -v latest` will save the test results in ~/Documents/CODAP data/testrun_latest.csv
    `ruby testPerformanceHarness.rb -t 5 -c 250 -d 20 -s 3` runs Performance Harness 5 times, with 250 Number of trials, 20 ms Delay between trials and 3 seconds between runs.
