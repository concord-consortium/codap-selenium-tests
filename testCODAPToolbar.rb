require 'selenium-webdriver'
require 'rspec/expectations'
require './codap_object'
include RSpec::Matchers


def setupMac(browser_name)
  @driver = Selenium::WebDriver.for browser_name
  ENV['base_url'] = 'http://codap.concord.org/~eireland/CodapClasses/'
rescue Exception => e
  puts e.message
  puts "Could not start driver"
  exit 1

end

def setupWin(browser_name)
  @driver = Selenium::WebDriver.for(
      :remote,
      :url=> 'http://localhost:4444/wd/hub',
      :desired_capabilities=> browser_name)
  ENV['base_url'] = 'http://codap.concord.org/~eireland/CodapClasses'
rescue Exception => e
  puts e.message
  puts "Could not start driver #{@browser_name}"
  exit 1
end

def teardown
  puts "in teardown"
  @driver.quit
end

MACBROWSERS = [:firefox, :chrome, :safari]
WINBROWSERS = [:firefox, :chrome, :ie]

def run
  MACBROWSERS.each do |macbrowser|
    puts macbrowser
    setupMac(macbrowser)
    yield
    teardown
  end
  WINBROWSERS.each do |winbrowser|
    puts winbrowser
    setupWin(winbrowser)
    yield
    teardown
  end
end

run do
  codap = CODAPObject.new(@driver)
  codap.click_table_button
  codap.click_graph_button
  codap.click_map_button
  codap.click_slider_button
  codap.click_calc_button
  codap.click_text_button
  codap.click_option_button
  codap.click_tilelist_button
  #codap.click_guide_button
end
