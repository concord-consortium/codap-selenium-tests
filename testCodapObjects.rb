require './codap_object.rb'
require 'selenium-webdriver'

@@driver = Selenium::WebDriver.for :chrome
ENV['base_url'] = 'http://codap.concord.org/releases/latest/'

codap = CODAPObject.new()
codap.visit
codap.verify_page('CODAP')
codap.dismiss_splashscreen
open_doc = '3TableGroups.json'
file = 'Mammals'
# file = File.absolute_path(File.join(Dir.pwd,open_doc))
codap.user_entry_open_doc
codap.open_sample_doc(file)

codap.goto_table
codap.create_new_attribute('random_test','random()')

# @@driver.quit