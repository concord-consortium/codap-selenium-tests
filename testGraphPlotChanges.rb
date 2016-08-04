#testGraphPlotChanges test graph plot transitions and take graph screenshots of each transition. The data file 3TableGroups.json need to be in the same directory as the test. Plot transitions screenshots are saved separately by plot transition name. The test will run on latest version of CODAP in Mac OS X Chrome, Firefox and Safari, and Windows 8.1 Chrome, Firefox and Internet Explorer 11.

require 'selenium-webdriver'
require 'rspec/expectations'
require './codap_object'
include RSpec::Matchers
# require './LogReporter'
#
# def setupHelper(session_id)
#   @logger = LogReporter.new(session_id)
# end

# def write_result_file(doc_name)
#   googledrive_path="Google Drive/CODAP @ Concord/Software Development/QA"
#   localdrive_path="Documents/CODAP data/"
#   $dir_path = "Documents/CODAP data/"
#   $save_filename = "Plot_changes_logs"
#
#   log = @driver.manage.logs.get(:browser)
#   messages = ""
#   log.each {|item| messages += item.message + "\n"}
#
#   if !File.exist?("#{Dir.home}/#{$dir_path}/#{$save_filename}") || $new_file
#     File.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "wb") do |log|
#       log<< messages unless messages == ""
#     end
#   else
#     File.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "a") do |log|
#       log << messages unless messages == ""
#     end
#   end
#
# end

# def setup(browser_name, platform)
#   caps = Selenium::WebDriver::Remote::Capabilities.new
#   case (platform)
#     when "mac"
#       caps[:platform]='OS X'
#       case (browser_name)
#         when :firefox
#           caps[:browserName] = :firefox
#           caps[:logging_prefs] = {:browser => "ALL"}
#         when :chrome
#           caps[:browserName] = :chrome
#           caps[:logging_prefs] = {:browser => "ALL"}
#         when :safari
#           caps[:browserName] = :safari
#           caps[:logging_prefs] = {:browser => "ALL"}
#       end
#     when "windows"
#       caps[:platform]='Windows'
#       case (browser_name)
#         when :firefox
#           caps[:browserName] = :firefox
#           caps[:logging_prefs] = {:browser => "ALL"}
#         when :chrome
#           caps[:browserName] = :chrome
#           caps[:logging_prefs] = {:browser => "ALL"}
#         when :ie
#           caps[:browserName] = :internet_explorer #'internet explorer'
#           caps[:logging_prefs] = {:browser => "ALL"}
#       end
#   end
#   @@driver = Selenium::WebDriver.for(
#       :remote,
#       :url=> 'http://localhost:4444/wd/hub',
#       :desired_capabilities=> caps )
#   @@driver = Selenium::WebDriver.for browser_name
#   #setupHelper(@driver.session_id)
#   #ENV['base_url'] = 'http://codap.concord.org/releases/latest/'
#   #ENV['base_url'] = 'http://codap.concord.org/~eireland/CodapClasses'
#   #ENV['base_url'] = 'localhost:4020/dg'
#   ENV['base_url'] = 'http://codap.concord.org/releases/latest/'
#   rescue Exception => e
#     puts e.message
#     puts "Could not start driver #{@@driver}"
#     exit 1
# end
def setup
  @@driver = Selenium::WebDriver.for :chrome
  ENV['base_url'] = 'http://codap.concord.org/releases/latest/'
end

def teardown
  puts "in teardown"
  @driver.quit
end

MACBROWSERS = [:chrome, :firefox, :safari]
WINBROWSERS = [:ie, :chrome, :firefox]

def run
  setup
  yield
  teardown
  # MACBROWSERS.each do |macbrowser|
  #   puts macbrowser
  #   setup(macbrowser, 'mac')
  #   yield
  #   teardown
  # end
  # WINBROWSERS.each do |winbrowser|
  #   puts winbrowser
  #   setup(winbrowser, 'windows')
  #   yield
  #   teardown
  # end
end

run do
  codap = CODAPObject.new()
  open_doc = '3TableGroups.json'
  file = File.absolute_path(File.join(Dir.pwd, open_doc))
  puts "file is #{file}, open_doc is #{open_doc}"
  attributes = ['ACAT1','ACAT2','ANUM1','ANUM2','BCAT1','BNUM1','CCAT1','CNUM1','CCAT2','CNUM2']
  drop_zone = ['x','y','legend']
  array_of_plots = [{:attribute=>'ACAT1', :axis=>'x'},
                    {:attribute=>'ACAT2', :axis=>'y'},
                    {:attribute=>'ANUM1', :axis=>'x'},
                    {:attribute=>'ANUM2', :axis=>'y'},
                    {:attribute=>'BCAT1', :axis=>'x'},
                    {:attribute=>'BNUM1', :axis=>'x'},
                    {:attribute=>'CCAT1', :axis=>'x'},
                    {:attribute=>'CNUM1', :axis=>'x'},
                    {:attribute=>'BNUM1', :axis=>'y'},
                    {:attribute=>'CCAT2', :axis=>'x'},
                    {:attribute=>'BCAT1', :axis=>'y'},
                    {:attribute=>'ACAT2', :axis=>'y'},
                    {:attribute=>'BCAT1', :axis=>'legend'},
                    {:attribute=>'CNUM1', :axis=>'legend'},
                    {:attribute=>'CNUM2', :axis=>'y'},]

  codap.start_codap

  # Open CODAP document
  codap.user_entry_open_doc
  codap.open_local_doc(file)
  open_doc.slice! '.json'
  codap.verify_doc_title(open_doc)

  #Open a graph
  codap.click_button('graph')

  #Change axes by attribute, axis
  array_of_plots.each do |hash|
    codap.drag_attribute(hash[:attribute], hash[:axis])
    sleep(2)
    # write_result_file(open_doc)
    codap.take_screenshot(hash[:attribute],hash[:axis])
  end

  # # codap.remove_graph_attribute('legend')
  # # write_result_file(open_doc)
  # # codap.take_screenshot('none','legend')
  # # codap.remove_graph_attribute('x')
  # # write_result_file(open_doc)
  # # codap.take_screenshot('none','x')
  #
  # #puts @logger.latest
end