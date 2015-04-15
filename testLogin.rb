require 'rspec'
require 'selenium-webdriver'


def setup
  @browser = Selenium::WebDriver.for :firefox
  @wait= Selenium::WebDriver::Wait.new(:timeout=>60)
end

def teardown
  @browser.quit
end

def run
  setup
  yield
 teardown
end

def getURL(url)
  @browser.get(url)
  puts "Page title is #{@browser.title}"
  #Checks if correct document is on screen
  if @browser.title == "Untitled Document - CODAP"
    puts "Got right document"
  else
    puts "Got wrong page"
  end
end

def testStandAlone(url)
  getURL(url)
  createNewDocTest
end

def testWithDataInteractive(url)
  getURL(url)
  @wait.until {@browser.find_element(:xpath=> "//canvas[@alt='Graph']")}.click
  @wait.until {@browser.find_element(:xpath=> "//canvas[@alt='Tables']")}.click
  runPerformanceHarness
end

def testWithDocumentServer(url)
  getURL(url)
  loginAsGuestTest
  @wait.until {@browser.find_element(:xpath=> "//canvas[@alt='Graph']")}.click
  @wait.until {@browser.find_element(:xpath=> "//canvas[@alt='Tables']")}.click
  runPerformanceHarness
  loginToolshelfButtonTest
  loginTest
end

def createNewDocTest
  #Send document name to text field
  @wait.until {@browser.find_element(:class=>"field")}.send_keys "testDoc"
  @browser.find_element(:xpath=>"//label[@title='Create a new document with the specified title']").click

  #Validate that the document is created
  if @browser.title.include?("testDoc")
    puts "Created new document"
  else
    puts "Did not create new document"
  end
end


def loginAsGuestTest
  #Click on Login as Guest button

 @loginGuestButton = @browser.find_element(:xpath, "//label[contains(.,'Login as guest')]")
  if @loginGuestButton.text.include?("Login as guest")
    puts "Found Login in as guest button"
    @wait.until {@loginGuestButton}.click
  else
    puts "Login as guest button not found"
  end
end


def loginTest
  #Click on Login button
 #@loginButton = @browser.find_element(:xpath, "//label[contains(.,'Login')]")
 @loginButton = @browser.find_element(:class, "def")
  if @loginButton
    puts "Found Login button"
    puts @loginButton.text
    @wait.until {@loginButton}.click
  else
    puts "Login button not found"
  end
end


def loginToolshelfButtonTest
  #Click on Login as Guest button
  @loginToolshelfButton = @browser.find_element(:xpath, '//div[@title="Login"]')

  if @loginToolshelfButton.text.include?("Login")
    puts "Found Login button on Toolshelf"
    @loginToolshelfButton.click
    puts "Just clicked the Login on Toolshelf button"
  #  loginTest
  else
    puts "Login button on Toolshelf not found"
  end
end

def runPerformanceHarness

  $counter=0
  $totalTrials=3

  frame = @browser.find_element(:css, "iframe")

  @browser.switch_to.frame(frame)

  trials = @browser.find_element(:name=>'numTrials')
  trials.clear
  trials.send_keys('20')


  while $counter < $totalTrials do


    runButtonEnabled = @wait.until{
      runButton = @browser.find_element(:name=>'run')
      runButton.click if runButton.enabled?
    }

    timeResult=@wait.until{
      timeElement = @browser.find_element(:id=>'time')
      timeElement if timeElement.displayed?
    }

    puts "Time result is #{timeResult.text} ms"
    rateResult=@browser.find_element(:id=>'rate')
    puts "Rate result is #{rateResult.text} cases/sec"

    $counter+=1
  end

  @browser.switch_to.default_content
end


run do
  testStandAlone("http://codap.concord.org/releases/latest/static/dg/en/cert/index.html")
end

run do
  testWithDataInteractive("http://codap.concord.org/releases/build_0292/static/dg/en/cert/index.html?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
end

run do
  testWithDocumentServer("http://codap.concord.org/releases/latest/static/dg/en/cert/index.html?documentServer=http://document-store.herokuapp.com&di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
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





