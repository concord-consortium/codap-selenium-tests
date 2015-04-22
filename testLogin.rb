require 'rspec'
require 'selenium-webdriver'
require 'optparse'

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
  puts $build

  @wait= Selenium::WebDriver::Wait.new(:timeout=>30)
  @browser.manage.window.maximize
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
def testStandAlone(url)
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  createNewDocTest
end

#Opens CODAP with specified data interactive in url
def testWithDataInteractive(url)
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  @wait.until {@browser.find_element(:css=> '.dg-graph-button')}.click
  @wait.until {@browser.find_element(:css=> '.dg-tables-button')}.click
  runPerformanceHarness
end

#Opens CODAP with document server, logged in as guest.
def testWithDocumentServer(url)
  get_website(url)
  loginAsGuestTest
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  @wait.until {@browser.find_element(:css=> '.dg-graph-button')}.click
  @wait.until {@browser.find_element(:css=> '.dg-tables-button')}.click
  runPerformanceHarness
  loginToolshelfButtonTest
  loginTest
end

def createNewDocTest
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


def loginAsGuestTest
  #Click on Login as Guest button
  sleep(1) #Sleep to slow down when testing on Chrome
  @loginGuestButton = @wait.until{@browser.find_element(:css=> ".dg-loginguest-button")}
  if @loginGuestButton
    puts "Found Login in as guest button"
    @loginGuestButton.click
  else
    puts "Login as guest button not found"
  end
end


def loginTest
  #Click on Login button
  @loginButton = @browser.find_element(:css=> ".dg-login-button")
  puts @loginButton
  if @loginButton
    puts "Found Login button"
    @loginButton.click
  else
    puts "Login button not found"
  end
end


def loginToolshelfButtonTest
  #Click on Login as Guest button
  @loginToolshelfButton = @wait.until{@browser.find_element(:css=> '.dg-toolshelflogin-button')}

  if @loginToolshelfButton
    puts "Found Login button on Toolshelf"
    @loginToolshelfButton.click
    puts "Just clicked the Login on Toolshelf button"
  else
    puts "Login button on Toolshelf not found"
  end
end

#Run the Performance Harness data interactive
def runPerformanceHarness

  counter=0
  total_trials=3

  frame = @browser.find_element(:css=> "iframe")

  @browser.switch_to.frame(frame)

  trials = @browser.find_element(:name=>'numTrials')
  trials.clear
  trials.send_keys('50')

  while counter < total_trials do
    counter=counter+1
    run_button_enabled = @wait.until{@browser.find_element(:name=>'run')}
    run_button_enabled.click if run_button_enabled.enabled?

    timeResult=@wait.until{
      timeElement = @browser.find_element(:id=>'time')
      timeElement if timeElement.displayed?
    }
    puts "Time result is #{timeResult.text} ms"
    rateResult=@browser.find_element(:id=>'rate')
    puts "Rate result is #{rateResult.text} cases/sec"
  end

  @browser.switch_to.default_content
end

run do
  testStandAlone("#{$build}")
  testWithDataInteractive("#{$build}?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
  testWithDocumentServer("#{$build}?documentServer=http://document-store.herokuapp.com&di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
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





