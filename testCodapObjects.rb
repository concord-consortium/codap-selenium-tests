require './codap_object.rb'
require 'selenium-webdriver'

@@driver = Selenium::WebDriver.for :chrome
ENV['base_url'] = 'http://codap.concord.org/releases/latest/'

codap = CODAPObject.new()
codap.visit
codap.verify_page('CODAP')
codap.dismiss_splashscreen
open_doc = '3TableGroups.json'
file = File.absolute_path(File.join(Dir.pwd,open_doc))
codap.user_entry_open_doc
codap.open_local_doc(file)
open_doc.slice! '.json'
codap.verify_doc_title(open_doc)

array_of_plots = [{:attribute=>'ACAT1', :axis=>'x'},
                  {:attribute=>'ACAT2', :axis=>'y'},
                  {:attribute=>'ANUM1', :axis=>'x'},
                  {:attribute=>'ANUM2', :axis=>'y'},
                  {:attribute=>'BCAT1', :axis=>'x'}]

#Open a graph
codap.click_button('graph')

#Change axes by attribute, axis
array_of_plots.each do |hash|
  codap.drag_attribute(hash[:attribute], hash[:axis])
end

@@driver.quit