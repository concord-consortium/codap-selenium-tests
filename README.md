codap-selenium-tests
==================

Selenium tests of CODAP.

- testPerformanceHarness runs the CODAP data interactive Peformance Harness. This test can be used to generate a specified number of data and benchmark the data generation rate with only a the data interactive, with the data interactive and a table, with the data interactive and a graph, with the data interactive, table and graph.

- testPerformanceInflection runs the CODAP data interactive Performance Harness to see how much data CODAP can handle. The test will keep generating data until either the rate becomes less than 1 or there are more than 10,000 cases. This test will generate data with only the data interactive, with the data interactive and a table, with the data interactive and a graph, with the data interactive, table and graph. Results are written into csv file.

- testCODAPToolbar will click on all the buttons in the CODAP toolshelf except for the table and the guide. Tables do not open unless there is data. Guides do not open if there is no guide specified in configuration. The test will run on latest version of CODAP in Mac OS X Chrome, Firefox and Safari, and Windows 8.1 Chrome, Firefox and Internet Explorer 11. 

- testGraphPerformance tests graph plot transition performance with varying numbers of data. The following files need to be in the same directory as the test:PH_35_Data.json, PH_5K_Data.json, and PH_10K_Data.json. The test will run om latest version of CODAP in Mac OS X Chrome, Firefox and Safari. Result of console log benchmarks are written into a text file.

- testGraphPlotChanges test graph plot transitions and take graph screenshots of each transition. The data file 3TableGroups.json need to be in the same directory as the test. Plot transitions screenshots are saved separately by plot transition name. The test will run on latest version of CODAP in Mac OS X Chrome, Firefox and Safari, and Windows 8.1 Chrome, Firefox and Internet Explorer 11.

Selenium Standalone Server needs to be installed on all platforms that the test will run on.

Installation
====

1. Download Selenium Standalone Server from this [site] (http://www.seleniumhq.org/download/).

2. Clone the codap-selenium-tests git repository to your computer:

    ```
    git clone https://github.com/concord-consortium/codap-selenium-tests.git
    ```
3. Go to the folder where you cloned the repository and run the following command to install dependencies:

    ```
    bundle install
    ```
    This will install the following gems:
        selenium-webdriver
        rspec
        page-object
        optparse
        date
        csv
        rspec/expectations
        
4. To run tests in Firefox, no other installation is needed.

   To run tests in Chrome, ChromeDriver needs to be installed and added to your system PATH.
   Download ChromeDriver [here](https://sites.google.com/a/chromium.org/chromedriver/downloads)
   
   To run tests in Safari, SafariDriver needs to be installed as a browser extension. Download SafariDriver [here](https://github.com/SeleniumHQ/selenium/wiki/SafariDriver) 
   
   To run tests in Internet Explorer, IEDriver needs to be install and added to your system PATH. Tests run faster with the 32-bit version of the driver. 
   Download IEDriver [here](https://github.com/SeleniumHQ/selenium/wiki/InternetExplorerDriver#required-configuration)

Set-up Test Environment
=======================

Have Java installed.

1. Run Selenium Standalone Server as a hub on the main machine using setupSeleniumServer.sh 
`./setupSeleniumServer.sh` 
   or 
   in terminal, type in 
   `java -jar selenium-server-standalone-[version number].jar -role hub`
   where *version number* is the version of the selenium-server-standalone downloaded from the Selenium website. setupSeleniumServer.sh currently calls version 2.53.0.
   
    Note the IP address of the hub for nodes to register to.
   
2. Run Selenium Standalone Server nodes on the slave machines using setupSeleniumNode.sh
`./setupSeleniumServer.sh [IP address of hub]`
or
in terminal, type in 
    `java -jar selenium-server-standalone-[version number].jar -role node -hub http://[IP address of hub]:4444/grid/register`
where *version number* is the version of the selenium-server-standalon downloaded from the Selenium website and *IP address of hub* is the IP address noted from the hub server. setupSeleniumNode.sh currently calls version 2.53.0

    To check whether nodes are properly registered, navigate to http://localhost:4444/grid/console on any browser.    
    
Usage
====
 
### testPerformanceHarness.rb
`ruby testPerformanceHarness.rb` runs the CODAP data interactive Peformance Harness. This test can be used to generate data and benchmark the data transfer rate between the data interactive and CODAP. This test allows for specifying a number of configuration settings. Note that this test will not run on Safari.

`ruby testPerformanceHarness.rb -h` shows available options and their descriptions
 
    Usage: testPerformanceHarness.rb [options]
    
    Specific options:
        -b, --browser BROWSER            Browser that should be tested (Chrome, Firefox, IE11). 
                                            Default is Chrome.
        -m, --platform PLATFORM          Platform that should be tested (mac, win).
                                            Default is Mac.
        -v, --version VERSION            CODAP version that should be tested. Build numbers are  
                                            generally in the form of build_0xxx. Default is "latest"
        -r, --root_dir ROOTDIR           Root directory of CODAP. Default is localhost:4020/dg. 
                                            Another common root is codap.concord.org/releases/.
        -w, --[no]-write WRITE           Writes test result into a new file (filename must be specified). 
                                            Default appends results to the file testPerformanceHarnessResultDefault__version_.csv
        -f, --filename FILENAME          Specify a filename for where to write the results of the test. 
                                            This must be specified if writing to a new file. 
        -p, --path PATH                  Specify path where the result file should be saved to. 
                                            Default is Google Drive/CODAP @ Concord/Software Development/QA.
        -t, --trials NUMBER OF TRIALS    Specify the number of runs of Performance Harness. Default is 1
        -c, --cases NUMBER OF CASES      Specify the number of cases Performance Harness should generate. Default is 100.
        -d, --delay DELAY BETWEEN TRIALS Specify the delay between trials in ms Default is 1
        -s, --sleep SLEEP TIME           Specify sleep time between runs. Default is 1
   
  

Examples:

`ruby testPerformanceHarness.rb -b Chrome`    runs script in Chrome

`ruby testPerformanceHarness.rb -r codap.concord.org/releases/ -v build_0293` will run Performance Harness in codap.concord.org/releases/build_0293   

`ruby testPerformanceHarness.rb -p Documents/CODAP data -f testrun -v latest` will save the test results in ~/Documents/CODAP data/testrun_latest.csv

`ruby testPerformanceHarness.rb -t 5 -c 250 -d 20 -s 3` runs Performance Harness 5 times, with 250 Number of trials, 20 ms Delay between trials and 3 seconds between runs.

Results are saved to testPerformanceHarnessResultDefault__version__.csv unless otherwise specified with -f option.

**NOTE: Default location where result file is saved is Google Drive/CODAP @ Concord/Software Development/QA.  If you do not have access to this folder, please specify a path where to save the result file by using the -p option when running the test. **

### testRunner.sh
`./testRunner.sh` runs testPerformanceHarness.rb on Mac Firefox and Chrome, and Windows Firefox, Chrome, and Internet Explorer.

This prior setup is needed to use testRunner.sh
The shell script needs .testRunnerrc configuration file to set up with your user preferences. The following variables are expected in the config file:
    RESULT_FILE="filename" - filename for the testRunner aggregate result
    TRIALNUM=num - Number of trials in the Performance Harness
    CASENUM=num - Number of cases per trial
    TESTNUM=num - Number of times to run testPerformanceHarness.rb
    CODAP_ROOT="root folder of the CODAP version" (ie. "codap.concord.org/releases/")
    CODAP_VERSION="codap version" (ie. "latest", or "build_0322)
    GOOGLE_PATH="path to folder of test result file" (ie. "$HOME/Google Drive/some_folder")
    

### testPerformanceInflection
`ruby testPerformanceInflection.rb` runs the CODAP data interactive Peformance Harness. This test can be used to generate data and benchmark the data transfer rate between the data interactive and CODAP. This test allows for specifying a number of configuration settings. Note that this test will not run on Safari.

`ruby testPerformanceInflection.rb -h` shows available options and their descriptions
 
    Usage: testPerformanceHarness.rb [options]
    
    Specific options:
        -b, --browser BROWSER            Browser that should be tested (Chrome, Firefox, IE11). 
                                            Default is Chrome.
        -m, --platform PLATFORM          Platform that should be tested (mac, win).
                                            Default is Mac.
        -v, --version VERSION            CODAP version that should be tested. Build numbers are  
                                            generally in the form of build_0xxx. Default is "latest"
        -r, --root_dir ROOTDIR           Root directory of CODAP. Default is localhost:4020/dg. 
                                            Another common root is codap.concord.org/releases/.
        -w, --[no]-write WRITE           Writes test result into a new file (filename must be specified). 
                                            Default appends results to the file testPerformanceHarnessResultDefault__version_.csv
        -f, --filename FILENAME          Specify a filename for where to write the results of the test. 
                                            This must be specified if writing to a new file. 
        -p, --path PATH                  Specify path where the result file should be saved to. 
                                            Default is current test directory.
        -t, --trials NUMBER OF TRIALS    Specify the number of runs of Performance Harness. Default is 1
        -c, --cases NUMBER OF CASES      Specify the number of cases Performance Harness should generate. Default is 100.
        -d, --delay DELAY BETWEEN TRIALS Specify the delay between trials in ms Default is 1
        -s, --sleep SLEEP TIME           Specify sleep time between runs. Default is 1
   
  
Examples:

`ruby testPerformanceInflection.rb -b Chrome`    runs script in Chrome

`ruby testPerformanceInflection.rb -r codap.concord.org/releases/ -v build_0293` will run Performance Harness in codap.concord.org/releases/build_0293   

`ruby testPerformanceInflection.rb -p Documents/CODAP data -f testrun -v latest` will save the test results in ~/Documents/CODAP data/testrun_latest.csv

`ruby testPerformanceInflection.rb -t 5 -c 250 -d 20 -s 3` runs Performance Harness 5 times, with 250 Number of trials, 20 ms Delay between trials and 3 seconds between runs.

Results are saved to testPerformanceInflectionResultDefault__version__.csv unless otherwise specified with -f option.

### testCODAPToolbar
`ruby testCODAPToolbar.rb` runs the latest version of CODAP and clicks on all the toolshelf buttons except for the Table button and Guide button. The test runs on Mac Chrome, Firefox, and Safari, and Win 8.1 Chrome, Firefox, and IE11.

### testGraphPerformance
`ruby testGraphPerformance.rb` runs the latest version of CODAP and tests graph plot transition performance with varying numbers of data. The following CODAP documents need to be in the same directory as the test:PH_35_Data.json, PH_5K_Data.json, and PH_10K_Data.json. The test will run om latest version of CODAP in Mac OS X Chrome, Firefox and Safari. Result of console log benchmarks are written into a text file.
    The test opens one of the CODAP documents and drags attributes from the table to different graph positions (x axis, y-axis, and legend.) Benchmark console logs are saved to a text file called *Plot_changes_logs* in the test directory. Subsequent tests appends the console logs to this file.

### testGraphPlotChanges
`ruby testGraphPlotChanges.rb` tests graph plot transitions and take graph screenshots of each transition. The data file 3TableGroups.json need to be in the same directory as the test. Plot transitions screenshots are saved separately by plot transition name (*attribute*_on_*location*.png). The test will run on latest version of CODAP in Mac OS X Chrome, Firefox and Safari, and Windows 8.1 Chrome, Firefox and Internet Explorer 11.