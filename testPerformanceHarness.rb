#! /usr/bin/ruby

require 'rspec'
require 'selenium-webdriver'
require 'optparse'
require 'date'
require 'csv'

#Parses the options entered in command line. Syntax is -b = [firefox, chrome]; -v = [build_nnnn], -r = [localhost:4020/dg, codap.concord.org/releases/]
def parse_args
  opt = {}
  opt_parser = OptionParser.new do |opts|
    opts.banner = "Usage: testLogin.rb [options]"
    opts.separator('')
    opts.on('-b', '--browser [BROWSER]', "Default is Chrome") do |driver|
      opt[:browser] = driver
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

def write_to_csv (time, platform, browser_name, browser_version, build, counter, num_cases, delay, duration, rate, test_name)
  googledrive_path="Google Drive/CODAP @ Concord/Software Development/QA"
  localdrive_path="Documents/CODAP data/"

  if !File.exist?("#{Dir.home}/#{$dir_path}/#{$save_filename}") || $new_file
    CSV.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "wb") do |csv|
      csv<<["Time", "Platform", "Browser", "Browser Version", "CODAP directory", "Test Name", "Counter", "Num of Cases", "Delay (s)", "Time Result (ms)", "Rate (cases/sec)"]
      csv << [time, platform, browser_name, browser_version, build, test_name, counter, num_cases, duration, rate]
    end
  else
    CSV.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "a") do |csv|
      csv << [time, platform, browser_name, browser_version, build, test_name, counter, num_cases, delay, duration, rate]
    end
  end
end

#Sets up which browser to test on, and which CODAP server to test against
def setup

  opt = parse_args

  #Set default values
  if opt[:browser].nil?
    opt[:browser]="chrome"
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
    opt[:filename]="testLoginResultDefault"
  end
  if opt[:path].nil?
    opt[:path]="Google Drive/CODAP @ Concord/Software Development/QA"
  end
  if opt[:sleep_time].nil?
    opt[:sleep_time]="1"
  end
  if opt[:write].nil?
    opt[:write]=false
  end

  if opt[:browser]=="chrome"
    @browser = Selenium::WebDriver.for :chrome
  elsif opt[:browser]=="firefox"
    @browser = Selenium::WebDriver.for :firefox
  end

  $ROOT_DIR = opt[:root]
  $dir_path = opt[:path]
  $new_file =opt[:write]

  if opt[:root].include? "localhost"
    $build = opt[:root]
    $save_filename = "#{opt[:filename]}_localhost.csv"
  else
    if opt[:version].nil?
      opt[:version]="latest"
    end
    $build = "http://#{opt[:root]}/#{opt[:version]}"
    $save_filename = "#{opt[:filename]}_#{opt[:version]}.csv"
  end

  #$save_filename = "#{opt[:filename]}_#{opt[:version]}.csv"
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

  @wait= Selenium::WebDriver::Wait.new(:timeout=>100)
  #@browser.manage.window.maximize
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
end

#Opens CODAP and creates a new document
def test_standalone(url)
  test_name = "Test Standalone"
  puts test_name
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  create_new_doc_test
end

#Opens CODAP with specified data interactive in url with graph and table
def test_data_interactive_gt(url)
  test_name = "Test Data Interactive with Graph and Table"
  puts test_name
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  @wait.until {@browser.find_element(:css=> '.dg-graph-button')}.click
  @wait.until {@browser.find_element(:css=> '.dg-tables-button')}.click
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
  @wait.until {@browser.find_element(:css=> '.dg-graph-button')}.click
  run_performance_harness(test_name)
end

#Opens CODAP with specified data interactive in url with table
def test_data_interactive_t(url)
  test_name = "Test Data Interactive with Table"
  puts test_name
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  @wait.until {@browser.find_element(:css=> '.dg-tables-button')}.click
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

#Opens CODAP with document server, logged in as guest.
def test_document_server(url)
  test_name = "Test Document Server Connection"
  puts test_name
  get_website(url)
  login_as_guest_test
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  @wait.until {@browser.find_element(:css=> '.dg-graph-button')}.click
  @wait.until {@browser.find_element(:css=> '.dg-tables-button')}.click
  run_performance_harness(test_name)
  login_toolshelf_button_test
  login_test
end

def create_new_doc_test
  #Send document name to text field
  @wait.until {@browser.find_element(:css=>"input.field")}.send_keys "testDoc"
  @browser.find_element(:css=>"[title='Create a new document with the specified title']").click

  #Validate that the document is created
  if @browser.title.include?("testDoc")
    puts "Created new document"
  else
    puts "Did not create new document"
  end
end


def login_as_guest_test
  #Click on Login as Guest button
  sleep(1) #Sleep to slow down when testing on Chrome
  @login_guest_button = @wait.until{@browser.find_element(:css=> ".dg-loginguest-button")}
  if @login_guest_button
    puts "Found Login in as guest button"
    @login_guest_button.click
  else
    puts "Login as guest button not found"
  end
end


def login_test
  #Click on Login button
  @login_button = @browser.find_element(:css=> ".dg-login-button")
  if @login_button
    puts "Found Login button"
    @login_button.click
  else
    puts "Login button not found"
  end
end


def login_toolshelf_button_test
  #Click on Login as Guest button
  @login_toolshelf_button = @wait.until{@browser.find_element(:css=> '.dg-toolshelflogin-button')}

  if @login_toolshelf_button
    puts "Found Login button on Toolshelf"
    @login_toolshelf_button.click
    puts "Just clicked the Login on Toolshelf button"
  else
    puts "Login button on Toolshelf not found"
  end
end

def find_parent(component)
  parent = component.find_element(:xpath=>'.')
end

def find_gear_menu(parent)
  gear_menu=@wait.until{parent.find_element(:css=>'.dg-gear-view')}
  puts "gear_menu location is #{gear_menu}"
  parent_text=parent.text
  puts "parent text is #{parent_text}"
  gear_menu_parent = find_parent(gear_menu)
  if !gear_menu
    puts "No gear menu"
  else
    gear_menu.click
    puts 'Clicked on gear menu'
    #show_count(gear_menu)
    #@wait.until{gear_menu.find_element(:css=>'a.menu-item').text=='Show Count'}.click
  end
end

def find_status(parent)
  puts "In table find_status"
  table_title = @wait.until{parent.find_element(:css=>'.dg-title-view')}
  puts "Table title: #{table_title.text}"

  table_status = @wait.until{parent.find_element(:css=>'div.dg-status-view')}
  puts "Table status: #{table_status.text}"
end

def find_component(component)
  @browser.switch_to.default_content # Always switch to main document when looking for a certain component
  component_views=@browser.find_elements(:css=>'div.component-view')
  component_title=component_views.find{|title| title.find_element(:css=>'div.dg-title-view').text==component}

  if component_title!=""
    component_title_text = component_title.text
    puts "Component title text is #{component_title_text}"
    @parent = find_parent(component_title)
    case component
      when 'Graph'
        find_gear_menu(@parent)
      when 'Performance Harness'
        find_gear_menu(@parent)
    end
  end
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

  frame = @browser.find_element(:css=> "iframe")

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
            Trial no. #{counter}, Number of cases: #{num_cases}, Delay: #{delay}, Time result: #{time_result.text} ms, Rate result: #{rate_result.text} cases/sec \n"
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

  #find_component('Graph')
  #find_component('Performance Harness')


end

run do
  # test_standalone("#{$build}")
  test_data_interactive("#{$build}?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
  # test_data_interactive_g("#{$build}?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
  # test_data_interactive_t("#{$build}?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
  # test_data_interactive_gt("#{$build}?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
  # test_document_server("#{$build}?documentServer=http://document-store.herokuapp.com&di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
end





#@url = "http://codap.concord.org/releases/latest/static/dg/en/cert/index.html?documentServer=http://document-store.herokuapp.com/"
#@url="http://codap.concord.org/releases/latest/static/dg/en/cert/index.html?documentServer=http://document-store.herokuapp.com&di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html"
#@url = "http://codap.concord.org/releases/build_0292/static/dg/en/cert/index.html?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html"





=begin
  #Click on File icon
  @browser.find_element(:xpath=> "//canvas[@alt='File']").click

  if (@browser.find_element(:xpath=> "//span[contains(.,'Close Document...')]")).displayed?
    puts "Found Close Document"
    @browser.find_element(:xpath=> "//span[contains(.,'Close Document...')]").click
  else
    puts "Close Document not displayed"
  end
=end





