#! /usr/bin/ruby
#testPerformanceHarness runs the CODAP data interactive Peformance Harness. This test can be used to generate a specified number of data and benchmark the data generation rate with only a the data interactive, with the data interactive and a table, with the data interactive and a graph, with the data interactive, table and graph.

require 'rspec'
require 'selenium-webdriver'
require 'optparse'
require 'date'
require 'csv'

$test_one=true
$keep_opt={}
def which_test
  puts "test_one is #{$test_one}"
  if $test_one
    opt=parse_args
    $keep_opt=opt
  end
  if !$test_one
    puts "test_one is false. keep_opt is #{$keep_opt}"
    opt=$keep_opt
  end
  return opt
end
#Closes browser at end of test
def teardown
  @browser.quit
end

#Main function
def run
  setup
  yield
  teardown
end

#Parses the options entered in command line. Syntax is -b = [firefox, chrome]; -v = [build_nnnn], -r = [localhost:4020/dg, codap.concord.org/releases/]
def parse_args
  opt = {}
  opt_parser = OptionParser.new do |opts|
    opts.banner = "Usage: testLogin.rb [options]"
    opts.separator('')
    opts.on('-b', '--browser [BROWSER]', "Default is Chrome") do |driver|
      opt[:browser] = driver
    end
    opts.on('-m', '--platform [PLATFORM]', "Default is Mac") do |platform|
      opt[:platform] = platform
    end
    opts.on('-v', '--version [BUILDNO]', 'CODAP build number (build_0xxx). Default is latest') do |build|
      opt[:version] = build
    end
    opts.on('-r', '--root_dir [ROOTDIR]', 'Root directory of CODAP. Default is localhost:4020/dg') do |root|
      opt[:root]=root
    end
    opts.on('-t', '--trials [NUMBER OF TRIALS]') do |num_trials|
      opt[:num_trials]=num_trials
    end
    opts.on('-c', '--cases [NUMBER OF CASES]') do |cases|
      opt[:num_cases]=cases
    end
    opts.on('-d', '--delay [DELAY BETWEEN TRIALS (ms)]') do |delay|
      opt[:delay]=delay
    end
    opts.on('-f', '--filename [FILENAME where to save results]','Must be specified if writing to a new file') do |filename|
      opt[:filename]=filename
    end
    opts.on('-p', '--path [PATH where to save results, do not include home in path]') do |path|
      opt[:path]=path
    end
    opts.on('-s', '--sleep [SLEEP time between runs (s)]') do |sleep_time|
      opt[:sleep_time]=sleep_time
    end
    opts.on('-w', '--[no-]write [WRITE]', 'write to a new file-> must specify filename, default is append (no-write). If no file name is specified, results will be appended.') do |write|
      opt[:write]=write
    end

  end
  opt_parser.parse!(ARGV)
  return opt
end

#Writes results from the performance harness to a csv file in the specified directory
def write_to_csv (time, platform, browser_name, browser_version, build, counter, num_cases, delay, duration, rate, test_name)

  if !File.exist?("#{$dir_path}/#{$save_filename}") || $new_file
    CSV.open("#{$dir_path}/#{$save_filename}", "wb") do |csv| #changed from Mac version. Omitted Dir.home to the path.  Mac code is commented out above
      csv<<["Time", "Platform", "Browser", "Browser Version", "CODAP directory", "CODAP Build Num", "Test Name", "Counter", "Num of Cases", "Delay (s)", "Time Result (ms)", "Rate (cases/sec)"]
      csv << [time, platform, browser_name, browser_version, build, $buildno, test_name, counter, num_cases, delay, duration, rate]
    end
  else
    CSV.open("#{$dir_path}/#{$save_filename}", "a") do |csv|#changed from Mac version. Omitted Dir.home to the path.  Mac code is commented out above
      csv << [time, platform, browser_name, browser_version, build, $buildno, test_name, counter, num_cases, delay, duration, rate]
    end
  end
end

#Sets up default values for the command line options
def setup

  opt=which_test
  #opt = parse_args
  puts "opt is #{opt}"

  #Set default values
  if opt[:browser].nil?
    opt[:browser]="chrome"
  end
  if opt[:platform].nil?
    opt[:platform]="mac"
  end
  if opt[:root].nil?
    opt[:root]="localhost:4020/dg"
  end
  if opt[:num_trials].nil?
    opt[:num_trials]="1"
  end
  if opt[:num_cases].nil?
    opt[:num_cases]="100"
  end
  if opt[:delay].nil?
    opt[:delay]="1"
  end
  if opt[:filename].nil?
    opt[:filename]="testPerformanceHarnessResultDefault"
  end
  if opt[:path].nil?
    opt[:path]="./"
  end
  if opt[:sleep_time].nil?
    opt[:sleep_time]="1"
  end
  if opt[:write].nil?
    opt[:write]=false
  end

  if opt[:platform]=='mac'
    if opt[:browser]=="chrome"
      @browser = Selenium::WebDriver.for :chrome
    elsif opt[:browser]=="firefox"
      @browser = Selenium::WebDriver.for :firefox
    elsif opt[:browser]=='safari'
      @browser = Selenium::WebDriver.for :safari
    end
  end

  if opt[:platform]=="win"
    if opt[:browser]=="chrome"
      @browser = Selenium::WebDriver.for(
          :remote,
          :url=> 'http://localhost:4444/wd/hub',
          :desired_capabilities=> :chrome)
    elsif opt[:browser]=="firefox"
      @browser = Selenium::WebDriver.for(
          :remote,
          :url=> 'http://localhost:4444/wd/hub',
          :desired_capabilities=> :firefox)
    elsif opt[:browser]=='ie'
      @browser = Selenium::WebDriver.for(
               :remote,
               :url=> 'http://localhost:4444/wd/hub',
               :desired_capabilities=> :ie)
    end
  end

  $ROOT_DIR = opt[:root]
  $dir_path = opt[:path]
  $new_file =opt[:write]

  if opt[:root].include? "localhost"
    $build = "http://#{opt[:root]}"
    $save_filename = "#{opt[:filename]}_localhost.csv"
  else
    if opt[:version].nil?
      opt[:version]="latest"
    end
    $build = "http://#{opt[:root]}/#{opt[:version]}"
    $save_filename = "#{opt[:filename]}_#{opt[:version]}.csv"
  end

  puts $save_filename

  @input_trials = opt[:num_trials]
  @input_cases = opt[:num_cases]
  @input_delay = opt[:delay]
  @input_sleep = opt[:sleep_time]

  @time = (Time.now+1*24*3600).strftime("%m-%d-%Y %H:%M")
  @platform = @browser.capabilities.platform
  @browser_name = @browser.capabilities.browser_name
  @browser_version = @browser.capabilities.version
  puts "Time:#{@time}; Platform: #{@platform}; Browser: #{@browser_name} v.#{@browser_version}; Testing: #{$build}"

  @wait= Selenium::WebDriver::Wait.new(:timeout=>60)
end


#Fetches the website
def get_website(url)
  @browser.get(url)
  puts "Page title is #{@browser.title}"
  #Checks if correct document is on screen
  if @browser.title == "Untitled Document - CODAP"
    puts "Got right document"
  else
    puts "Got wrong page"
  end
  get_buildno
end

#Gets the build number from the DOM
def get_buildno
  $buildno= @browser.execute_script("return window.DG.BUILD_NUM")
  puts "CODAP build_num is #{$buildno}."
end

#Opens CODAP with specified data interactive in url with graph and table
def test_data_interactive_gt(url)
  test_name = "Test Data Interactive with Graph and Table"
  puts test_name
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  @wait.until {@browser.find_element(:css=> '.dg-table-button')}.click
  @wait.until {@browser.find_element(:css=> '.dg-graph-button')}.click
  run_performance_harness(test_name)
end

#Opens CODAP with specified data interactive in url with graph
def test_data_interactive_g(url)
  test_name =  "Test Data Interactive with Graph"
  puts test_name
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  sleep(3)
  @wait.until {@browser.find_element(:css=> '.dg-graph-button')}.click
  run_performance_harness(test_name)
  #find_component("Graph")
end

#Opens CODAP with specified data interactive in url with table
def test_data_interactive_t(url)
  test_name = "Test Data Interactive with Table"
  puts test_name
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  @wait.until {@browser.find_element(:css=> '.dg-table-button')}.click
  run_performance_harness(test_name)
end

#Opens CODAP with specified data interactive in url with no other components
def test_data_interactive(url)
  test_name = "Test Data Interactive"
  puts test_name
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  run_performance_harness(test_name)
end

#Run the Performance Harness data interactive
def run_performance_harness(test_name)

  counter=0
  total_trials=@input_trials.to_i
  num_cases = @input_cases.to_i
  delay = @input_delay.to_i
  sleep_time = @input_sleep.to_i
  total_time = 0
  total_rate = 0
  average_duration = 0
  average_rate = 0

  frame = @browser.find_element(:xpath=> "//div/iframe")

  @browser.switch_to.frame(frame)

  trials = @browser.find_element(:name=>'numTrials')
  trials.clear
  trials.send_keys(num_cases)
  set_delay = @browser.find_element(:name=>'delay')
  set_delay.clear
  set_delay.send_keys(delay)
  run_button = @wait.until{@browser.find_element(:name=>'run')}

  while counter < total_trials do
    if run_button.enabled?
      sleep(sleep_time)
      run_button.click
      time_result=@wait.until{
        time_element = @browser.find_element(:id=>'time')
        time_element if time_element.displayed?
      }

      rate_result=@wait.until{@browser.find_element(:id=>'rate')}

      duration=time_result.text.to_f
      rate = rate_result.text.to_f
      total_time=total_time+duration
      total_rate = total_rate+rate

      puts "Time:#{@time}, Platform: #{@platform}, Browser: #{@browser_name} v.#{@browser_version}, Testing: #{$build},
            Trial no. #{counter}, Number of cases: #{num_cases}, Delay: #{delay} s, Time result: #{time_result.text} ms, Rate result: #{rate_result.text} cases/sec \n"
      counter=counter+1
      @browser.switch_to.default_content

      @browser.switch_to.frame(frame)
    end

  end

  average_duration = total_time/total_trials
  average_rate = total_rate/total_trials
  puts "Average Duration: #{average_duration}"
  puts "Average Rate: #{average_rate}"
  write_to_csv(@time, @platform, @browser_name, @browser_version, $build, total_trials, num_cases, delay, average_duration, average_rate, test_name)
  @browser.switch_to.default_content

end

run do
  test_data_interactive("#{$build}?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
  $test_one=false
end
 run do
   test_data_interactive_g("#{$build}?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
 end
run do
  test_data_interactive_t("#{$build}?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
end
run do
  test_data_interactive_gt("#{$build}?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
end





