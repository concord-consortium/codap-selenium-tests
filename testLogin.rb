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
    opts.on('-b', '--browser BROWSER') do |driver|
      opt[:browser] = driver
    end
    opts.on('-v', '--version BUILDNO') do |build|
      opt[:version] = build
    end
    opts.on('-r', '--root_dir ROOTDIR') do |root|
      opt[:root]=root
    end
  end
  opt_parser.parse!(ARGV)
  return opt
end

def write_to_csv (time, platform, browser_name, browser_version, build, counter, num_cases, duration, rate)
  if counter<1
    CSV.open("testLoginResult.csv", "wb") do |csv|
      csv<<["Time", "Platform", "Browser", "Browser Version", "CODAP Build", "Counter", "Num of Cases", "Time Result", "Rate"]
      csv << [time, platform, browser_name, browser_version, build, counter, num_cases, duration, rate]
    end
  else
    CSV.open("testLoginResult.csv", "a") do |csv|
      csv << [time, platform, browser_name, browser_version, build, counter, num_cases, duration, rate]
    end
  end
end

#Sets up which browser to test on, and which CODAP server to test against
def setup
  opt = parse_args
  if opt[:browser]=="firefox"
    @browser = Selenium::WebDriver.for :firefox
  elsif opt[:browser]=="chrome"
    @browser = Selenium::WebDriver.for :chrome
  end
  $ROOT_DIR = opt[:root]
  if opt[:version]!=""
    $build = "http://#{$ROOT_DIR}#{opt[:version]}"
  else
    $build=$ROOT_DIR
  end

  @time = (Time.now+1*24*3600).strftime("%m-%d-%Y %H:%M")
  @platform = @browser.capabilities.platform
  @browser_name = @browser.capabilities.browser_name
  @browser_version = @browser.capabilities.version
  puts "Time:#{@time}; Platform: #{@platform}; Browser: #{@browser_name} v.#{@browser_version}; Testing: #{$build}"

  @wait= Selenium::WebDriver::Wait.new(:timeout=>30)
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
  #teardown
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
  puts "Test Standalone"
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  create_new_doc_test
end

#Opens CODAP with specified data interactive in url with graph and table
def test_data_interactive_gt(url)
  puts "Test Data Interactive with Graph and Table"
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  @wait.until {@browser.find_element(:css=> '.dg-graph-button')}.click
  @wait.until {@browser.find_element(:css=> '.dg-tables-button')}.click
  run_performance_harness
end

#Opens CODAP with specified data interactive in url with graph
def test_data_interactive_g(url)
  puts "Test Data Interactive with Graph"
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  @wait.until {@browser.find_element(:css=> '.dg-graph-button')}.click
  run_performance_harness
end

#Opens CODAP with specified data interactive in url with table
def test_data_interactive_t(url)
  puts "Test Data Interactive with Table"
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  @wait.until {@browser.find_element(:css=> '.dg-tables-button')}.click
  run_performance_harness
end

#Opens CODAP with specified data interactive in url with no other components
def test_data_interactive(url)
  puts "Test Data Interactive"
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  run_performance_harness
end

#Opens CODAP with document server, logged in as guest.
def test_document_server(url)
  puts "Test Document Server Connection"
  get_website(url)
  login_as_guest_test
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  @wait.until {@browser.find_element(:css=> '.dg-graph-button')}.click
  @wait.until {@browser.find_element(:css=> '.dg-tables-button')}.click
  run_performance_harness
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
def run_performance_harness

  counter=0
  total_trials=20
  num_cases = 100


  frame = @browser.find_element(:css=> "iframe")

  @browser.switch_to.frame(frame)

  trials = @browser.find_element(:name=>'numTrials')
  trials.clear
  trials.send_keys(num_cases)
  run_button = @wait.until{@browser.find_element(:name=>'run')}


  while counter < total_trials do

    if run_button.enabled?
      run_button.click
      #sleep(3)
      time_result=@wait.until{
        time_element = @browser.find_element(:id=>'time')
        time_element if time_element.displayed?
      }
      rate_result=@browser.find_element(:id=>'rate')
      duration=time_result.text
      rate = rate_result.text
      puts "Time:#{@time}, Platform: #{@platform}, Browser: #{@browser_name} v.#{@browser_version}, Testing: #{$build},
            Trial no. #{counter}, Number of cases: #{num_cases}, Time result: #{time_result.text} ms, Rate result: #{rate_result.text} cases/sec \n"
      write_to_csv(@time, @platform, @browser_name, @browser_version, $build, counter, num_cases, duration, rate)
      counter=counter+1
      @browser.switch_to.default_content

      @browser.switch_to.frame(frame)
    end

  end

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





