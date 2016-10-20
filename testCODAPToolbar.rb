# This will click on all the buttons in the CODAP toolshelf except for the table and the guide. Tables do not open unless there is data. Guides do not open if there is no guide specified in configuration.

require './codap_object.rb'

url = 'https://codap.concord.org/releases/staging/'
components = ['graph','map','slider','calc','text','option','separator','tilelist']

codap = CODAPObject.new()
codap.setup_one(:chrome)
codap.start_codap(url)
codap.user_entry_start_new_doc
components.each do |component|
  codap.click_button(component)
end
  #  puts @logger.latest if @driver.capabilities.browser_name !='internet explorer'
  #TODO Needs assertions for each button click

