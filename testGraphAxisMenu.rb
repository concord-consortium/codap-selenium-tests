#testGraphToolPalette test graph tool palette values transitions and take graph screenshots of each transition. The data file 3TableGroups.json need to be in the same directory as the test. Plot transitions screenshots are saved separately by plot transition name. The test will run on latest version of CODAP in Mac OS X Chrome, Firefox and Safari, and Windows 8.1 Chrome, Firefox and Internet Explorer 11.

require './codap_object'


def write_result_file(doc_name)
  googledrive_path="Google Drive/CODAP @ Concord/Software Development/QA"
  localdrive_path="Documents/CODAP data/"
  $dir_path = "Documents/CODAP data/"
  $save_filename = "Plot_changes_logs"

  log = @@driver.manage.logs.get(:browser)
  messages = ""
  log.each {|item| messages += item.message + "\n"}

  if !File.exist?("#{Dir.home}/#{$dir_path}/#{$save_filename}") || $new_file
    File.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "wb") do |log|
      log<< messages unless messages == ""
    end
  else
    File.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "a") do |log|
      log << messages unless messages == ""
    end
  end

end

codap = CODAPObject.new()
codap.setup_one(:chrome)
url = "https://codap.concord.org/releases/staging/"
open_doc = '3TableGroups.codap'
file = File.absolute_path(File.join(Dir.pwd, open_doc))
puts "file is #{file}, open_doc is #{open_doc}"

codap.start_codap(url)
# Open CODAP document
codap.user_entry_open_doc
codap.open_local_doc(file)
sleep(5)
open_doc.slice! '.codap'
codap.verify_doc_title(open_doc)

#Open a graph
codap.click_button('graph')
sleep(2)

codap.drag_attribute('ACAT2', 'y') # Univariate categorical axis
sleep(2)

codap.drag_attribute('ANUM1','x')
sleep(2)

codap.drag_attribute('ACAT1','graph_legend')

codap.remove_graph_attribute('graph_legend')

sleep(10)



# codap.drag_attribute('ANUM1','x')
# sleep(2)
# checkbox_texts = click_on_checkboxes(codap,'on') #Turn on checkboxes
# codap.take_screenshot('ANUM1x', checkbox_texts)
# checkbox_texts = click_on_checkboxes(codap,'off') #Turn off checkboxes
#
# codap.drag_attribute('ANUM2','y')
# sleep(2)
# checkbox_texts = click_on_checkboxes(codap,'on') #Turn on checkboxes
# codap.take_screenshot('ANUM2y', checkbox_texts)
# checkbox_texts = click_on_checkboxes(codap,'off') #Turn off checkboxes
# codap.take_screenshot('ANum2y_checkboxoff',checkbox_texts)
#
# codap.remove_graph_attribute('y')
# sleep(2)
# checkbox_texts = click_on_checkboxes(codap,'on') #Turn on checkboxes
# codap.take_screenshot('ANUM1x', checkbox_texts)
# checkbox_texts = click_on_checkboxes(codap,'off') #Turn off checkboxes
# codap.take_screenshot('ANum1x_checkboxoff',checkbox_texts)


