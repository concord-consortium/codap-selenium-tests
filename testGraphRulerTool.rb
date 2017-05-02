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

CHECKBOX_LOCATOR = {css: '.checkbox'}
INPUT_FIELD_LOCATOR = {css: "input.field"}
LABEL_LOCATOR = {xpath: '//input[contains(@class,"field")]/ancestor::div/div[contains(@class, "sc-label-view")]'}
# GRAPH_TITLE_BAR = {xpath: '//div[contains(@class,"graph-view")]/ancestor::dg/div[contains(@class,"titlebar")]'}
GRAPH_CLOSE = {css: ".dg-close-view"}
GRAPH_TITLE_BAR = {css: '.titlebar-selected'}
GRAPH_TILE = {css: '.graph-view'}


def click_on_checkboxes(kcodap, state)
#Turn on checkboxes
  plotted_value = false
  plotted_function = false
  input = ["x*x/10", "75"]
  input_field_list=[]

  kcodap.open_ruler_tool
  checkbox_list = kcodap.find_all(CHECKBOX_LOCATOR) #get list of checkboxes
  num_of_checkboxes = checkbox_list.length
  i = num_of_checkboxes
  checkbox_texts=''
  puts "num of checkboxes is: #{num_of_checkboxes}"
  sleep(3)
  checkbox_list.each do |checkbox|
    # puts checkbox.text
    if checkbox.text == 'Plotted Value'
      plotted_value = true
    end
    if checkbox.text == 'Plotted Function'
      plotted_function = true
    end
    checkbox_texts +=checkbox.text
    (checkbox).click
    i -=1
    # sleep(8)
    # if i!=0
    #   codap.open_ruler_tool
    # end
  end
  if state == 'on'
    index=0
    input_field_list = kcodap.find_all(INPUT_FIELD_LOCATOR)
    if input_field_list.length>0
      puts "input field list length is #{input_field_list.length}. input field list is #{input_field_list}"
      input_field_list.each do |input_field|
        # label_loc = {xpath: '/ancestor::div/div[contains(@class, "sc-label-view")]'}
        label = kcodap.find(LABEL_LOCATOR)
        puts "label is #{label.text}"
        # input_field.send_keys(input[index])
        index +=1
      end
    end
    # if plotted_value == true
    #   puts "plotted value is on"
    #   input_value_field = kcodap.find(PLOTTED_INPUT_FIELD)
    #   puts "input_value_field is #{input_value_field}"
    #   sleep(3)
    #   kcodap.click_on(PLOTTED_INPUT_FIELD)
    #   input_value_field.send_keys("75")
    #   sleep(2)
    # end
    # if plotted_function ==true
    #   input_function_field = kcodap.find(PLOTTED_FUNCTION_FIELD)
    #   if (input_function_field.text=='')
    #     input_function_field.send_keys('x*x/10')
    #     sleep(2)
    #   end
    # end
  end
  return checkbox_texts
end


codap = CODAPObject.new()
codap.setup_one(:chrome)
url = "https://codap.concord.org/releases/staging/"
open_doc = '3TableGroups.json'
file = File.absolute_path(File.join(Dir.pwd, open_doc))
puts "file is #{file}, open_doc is #{open_doc}"
attributes = ['ACAT1','ACAT2','ANUM1','ANUM2','BCAT1','BNUM1','CCAT1','CNUM1','CCAT2','CNUM2']
drop_zone = ['x','y','legend']
array_of_plots = [{:attribute=>'ACAT1', :axis=>'y'},
                  {:attribute=>'ACAT2', :axis=>'x'},
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
                  {:attribute=>'BCAT1', :axis=>'graph_legend'},
                  {:attribute=>'CNUM1', :axis=>'graph_legend'},
                  {:attribute=>'CNUM2', :axis=>'y'},]

codap.start_codap(url)
# Open CODAP document
codap.user_entry_open_doc
codap.open_local_doc(file)
sleep(2)
open_doc.slice! '.json'
codap.verify_doc_title(open_doc)

#Open a graph
codap.click_button('graph')
sleep(2)
codap.click_on(GRAPH_TILE)

# codap.drag_attribute('ACAT2', 'x') # Univariate categorical axis
# sleep(2)
# checkbox_texts = click_on_checkboxes(codap,'on') #Turn on checkboxes
# sleep(2)
# codap.take_screenshot('ACAT2x', checkbox_texts)
# checkbox_texts = click_on_checkboxes(codap,'off') #Turn off checkboxes
#
# codap.drag_attribute('ACAT1','y')
# sleep(2)
# checkbox_texts = click_on_checkboxes(codap,'on') #Turn on checkboxes
# sleep(2)
# codap.take_screenshot('ACAT1y', checkbox_texts)
# checkbox_texts = click_on_checkboxes(codap,'off') #Turn off checkboxes

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
title_bar = codap.find(GRAPH_TITLE_BAR)
codap.close_component(title_bar)

codap.click_button('graph')
sleep(2)
codap.drag_attribute('ANUM1','x')
sleep(2)
checkbox_texts = click_on_checkboxes(codap,'on') #Turn on checkboxes
codap.take_screenshot('ANUM1x', checkbox_texts)
checkbox_texts = click_on_checkboxes(codap,'off') #Turn off checkboxes

codap.remove_graph_attribute('x')
sleep(2)
checkbox_texts = click_on_checkboxes(codap,'on') #Turn on checkboxes
codap.take_screenshot('ANUM1y', checkbox_texts)
checkbox_texts = click_on_checkboxes(codap,'off') #Turn off checkboxes
codap.take_screenshot('ANum1y_checkboxoff',checkbox_texts)

sleep(5)

#Turn off checkboxes

#for each checkbox in the list, turn the checkbox on, take a snapshot, turn checkbox off, take a snapshot
#what to do about combination checkboxes ([count and percent], percent with [row,column, and cell], [movable line and lsrl] with [intercept, and squares of residuals])
# codap.turn_on_count
# sleep(3)
# codap.take_screenshot('ACAT2','count')
# codap.turn_on_percent
# sleep(3)
# codap.take_screenshot('ACAT2','countpercent')
# codap.turn_off_count
# sleep(3)
# codap.take_screenshot('ACAT2','percent')
# codap.turn_off_percent
#
# codap.drag_attribute('ACAT1','x')
# sleep(2)
# codap.turn_on_count
# sleep(3)
# codap.take_screenshot('ACAT1x','count')
# codap.turn_on_percent
# sleep(3)
# codap.take_screenshot('ACAT1x','countpercent')
# sleep(3)
# codap.take_screenshot('ACAT1x','percent_row')
# codap.show_percent_column
# sleep(3)
# codap.take_screenshot('ACAT1x','percent_column')
# codap.show_percent_cell
# sleep(3)
# codap.take_screenshot('ACAT1x','percent_cell')
# codap.turn_off_count
# sleep(3)
# codap.take_screenshot('ACATx','percent_only')
# codap.turn_off_percent
#
# codap.drag_attribute('ANUM1', 'x')
# sleep(2)
# codap.turn_on_count
# sleep(3)
# codap.take_screenshot('ANUM1x','count')


# #Change axes by attribute, axis
# array_of_plots.each do |hash|
#   codap.drag_attribute(hash[:attribute], hash[:axis])
#   sleep(5)
#   codap.write_log_file('./', open_doc)
#   codap.take_screenshot(hash[:attribute],hash[:axis])
# end

# codap.remove_graph_attribute('graph_legend')
# codap.teardown

# `mkdir -p ~/Sites/plot_transition_results`
# `mv ~/Downloads/graph_*.png ~/Sites/plot_transition_results/`
