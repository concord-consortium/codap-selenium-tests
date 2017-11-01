#testGraphToolPalette test graph tool palette values transitions and take graph screenshots of each transition. The data file 3TableGroups.json need to be in the same directory as the test. Plot transitions screenshots are saved separately by plot transition name. The test will run on latest version of CODAP in Mac OS X Chrome, Firefox and Safari, and Windows 8.1 Chrome, Firefox and Internet Explorer 11.

require './codap_object'

expected_screenshots_dir = "#{Dir.home}/Sites/plot_ruler_results/expected_screenshots/"
staging_screenshots_dir = "#{Dir.home}/Sites/plot_ruler_results/test_screenshots/"
prev_attr = ""
prev_axis = ""
$close_graph = false


def write_result_file(doc_name)
  googledrive_path="Google Drive/CODAP @ Concord/Software Development/QA"
  localdrive_path="Documents/CODAP data/"
  $dir_path = "Documents/CODAP data/"
  $save_filename = "Plot_ruler_logs"

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
FORMULA_DIALOG ={css: '.dg-formula-dialog'}
INPUT_FIELD_LOCATOR = {xpath: "//div[contains(@class,'dg-formula-dialog-input-field')]/div/div/div/textarea"}
FORMULA_DIALOG_APPLY_BUTTON = {css: '.dg-formula-dialog-apply'}
LABEL_LOCATOR = {xpath: '//input[contains(@class,"field")]/ancestor::div/div[contains(@class, "sc-label-view")]'}
GRAPH_CLOSE = {css: ".dg-close-view"}
GRAPH_TITLE_BAR = {css: '.dg-titlebar-selected'}
GRAPH_TILE = {css: '.dg-graph-view'}


# Not sure if this actually does anything
def first_time(counter)
  if counter<=0
    return true
  else
    return false
  end
end

def input_formula(type, kcodap)
  sleep(1)
    formula_dialog = kcodap.find(FORMULA_DIALOG)
    puts "Found formula dialog at #{formula_dialog}"
    formula_dialog.click
    input_field = kcodap.find(INPUT_FIELD_LOCATOR)
    puts "Found input field  at #{input_field}"
    if type=="Plotted Value"
      puts "sending keys"
      kcodap.type(INPUT_FIELD_LOCATOR,'10')
    end
    if type == 'Plotted Function'
      kcodap.type(INPUT_FIELD_LOCATOR,'x*x/10')
    end
    puts "applying formula"
    kcodap.click_on(FORMULA_DIALOG_APPLY_BUTTON)

end

def click_on_checkboxes(kcodap, state, pvcounter, pfcounter)
#Turn on checkboxes
  plotted_value = false
  plotted_function = false
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
    checkbox.click
    if state=="on"
      if checkbox.text == 'Plotted Value'
          if first_time(pvcounter)
            input_formula("Plotted Value", kcodap)
            pvcounter+=1
          end
      end
      if checkbox.text == 'Plotted Function'
        if first_time(pfcounter)
          input_formula("Plotted Function", kcodap)
          pfcounter+=1
        end
      end
    end

    checkbox_texts +=checkbox.text
    i -=1
  end
  return checkbox_texts
end


  codap = CODAPObject.new()
  codap.setup_one(:chrome)
  url = "https://codap.concord.org/releases/staging/"
  #url = "localhost:4020/dg"
  open_doc = '3TableGroups.json'
  file = File.absolute_path(File.join(Dir.pwd, open_doc))
  puts "file is #{file}, open_doc is #{open_doc}"

  array_of_plots = [{:attribute=>'ACAT1', :axis=>'y'},
                    {:attribute=>'BCAT1', :axis=>'x'},
                    {:attribute=>'ANUM1', :axis=>'x'},
                    {:attribute=>'BNUM1', :axis=>'y'},
                    {:attribute=>'BCAT1', :axis=>'x'},
                    {:attribute=>'CCAT1', :axis=>'y'},
                    {:attribute=>'CNUM1', :axis=>'x'},
                    {:attribute=>'BNUM1', :axis=>'y'},
                    {:attribute=>'CCAT2', :axis=>'x'},
                    {:attribute=>'BCAT1', :axis=>'y'},
                    {:attribute=>'ACAT2', :axis=>'y'},
                    {:attribute=>'BCAT1', :axis=>'graph_legend'},
                    {:attribute=>'CNUM1', :axis=>'graph_legend'},
                    {:attribute=>'CNUM2', :axis=>'y'}]

  codap.start_codap(url)
# Open CODAP document
  codap.user_entry_open_doc
  codap.open_local_doc(file)
  sleep(2)
  open_doc.slice! '.json'
  codap.verify_doc_title(open_doc)

#Open a graph
  codap.click_button('graph')
  codap.wait_for{codap.displayed? (GRAPH_TILE) }

#Change axes by attribute, axis
  pvcounter=0 # Boolean for checking to see if first time plotted value is checked
  pfcounter=0 # Boolean for checking to see if first time plotted function is checked

array_of_plots.each do |hash|
  begin
    attempt = 0
    max_attempts = 5

    sleep(2)
    codap.drag_attribute(hash[:attribute], hash[:axis])
    sleep(2)
    checkbox_texts = click_on_checkboxes(codap,'on', pvcounter, pfcounter) #Turn on checkboxes
    sleep(2)
    codap.write_log_file('./', open_doc)
    codap.take_screenshot(hash[:attribute],hash[:axis], prev_attr, prev_axis, checkbox_texts)
    checkbox_texts = click_on_checkboxes(codap,'off', pvcounter, pfcounter) #Turn off checkboxes
    prev_attr = hash[:attribute]
    prev_axis = hash[:axis]

  rescue => e
    puts '::ERROR::'
    puts e
    attempt +=1
    if attempt< max_attempts
      puts "RETRYING (#{attempt})..."
      retry
    end

    #After having both value and function plotted on graph, two input fields are present in DOM even if only one input field is visible. So if both value and function have been plotted, we close the existing graph and open a new one.
    # if $close_graph==true
    #   title_bar = codap.find(GRAPH_TITLE_BAR)
    #   codap.close_component(title_bar)
    #   codap.click_button('graph')
    #   codap.wait_for{codap.displayed? (GRAPH_TILE) }
    #   $close_graph=false
    # end

  end



  codap.teardown

end

`rm -rf ~/Sites/plot_ruler_results/test_screenshots`
`mkdir -p ~/Sites/plot_ruler_results/test_screenshots`
`mv ~/Downloads/graph_*.png ~/Sites/plot_ruler_results/test_screenshots/`

size_compare_result = codap.compare_file_sizes(staging_screenshots_dir, expected_screenshots_dir)
puts ("#{size_compare_result}")



