# This will click on all the buttons in the CODAP toolshelf except for the table and the guide. Tables do not open unless there is data. Guides do not open if there is no guide specified in configuration.

require './codap_object.rb'

url = 'https://codap.concord.org/releases/staging/'
components = ['table','graph','map','slider','calc','text','sampler','draw tool','option','tilelist', 'help']

codap = CODAPObject.new()
codap.setup_one(:firefox)
codap.start_codap(url)
codap.user_entry_start_new_doc
sleep(3)
components.each do |component|
  codap.click_button(component)
  sleep(2)
end
  #  puts @logger.latest if @driver.capabilities.browser_name !='internet explorer'
  #TODO Needs assertions for each button click

