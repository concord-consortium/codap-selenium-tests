#testGraphToolPalette test graph tool palette values transitions and take graph screenshots of each transition. The data file 3TableGroups.json need to be in the same directory as the test. Plot transitions screenshots are saved separately by plot transition name. The test will run on latest version of CODAP in Mac OS X Chrome, Firefox and Safari, and Windows 8.1 Chrome, Firefox and Internet Explorer 11.

require './codap_object'
require './graph_object'

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
GRAPH_TITLE_BAR = {css: '.dg-titlebar~.dg-graph-view'}
GRAPH_TILE = {css: '.dg-graph-view'}
BACKGROUND = {css: '.toolshelf-background'}

GRAPH_H_AXIS = {css: '.dg-axis-view.dg-h-axis'}
GRAPH_V_AXIS = {css: '.dg-axis-view.dg-v-axis'}
GRAPH_V2_AXIS = {css: '.dg-v2-axis'}
GRAPH_PLOT_VIEW = {css: '.dg-plot-view'}
GRAPH_LEGEND = {css: '.dg-legend-view'}


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
    puts "formula applied"
end

def click_on_checkboxes(kcodap, state, pvcounter, pfcounter)
#Turn on checkboxes
  plotted_value = false
  plotted_function = false
  input_field_list=[]
  checkbox_texts=''

  kcodap.open_ruler_tool
  checkbox_texts = kcodap.get_list_of_ruler_checkboxes
  checkbox_list = kcodap.find_all(CHECKBOX_LOCATOR) #get list of checkboxes
  num_of_checkboxes = checkbox_list.length
  i = num_of_checkboxes
  puts "num of checkboxes is: #{num_of_checkboxes}"
  sleep(3)
  checkbox_list.each do |checkbox|
    checkbox.click
    if state=="on"
      if checkbox.text == 'Count'
        puts ("count adormnent is #{kcodap.verify_count_adornment}")
        if !(kcodap.verify_count_adornment)
          puts 'count adornment is missing'
        end
      end
      if checkbox.text == 'Plotted Value'
          puts 'in plotted value if statement'
          puts "pvcounter: #{pvcounter}"
          if first_time(pvcounter)
            if pfcounter>0
              pv_text_field = {css: '.dg-graph-view > .sc-text-field-view > div > input.field:nth-child(2)'}
            else
              pv_text_field = {css: '.dg-graph-view > .sc-text-field-view > div > input.field'}
            end
            puts "text field: #{pv_text_field}"
            kcodap.click_on(BACKGROUND)
            kcodap.click_on(pv_text_field)

            input_formula("Plotted Value", kcodap)
            pvcounter+=1
          else
            if pfcounter>0
              pv_text_field = {css: '.dg-graph-view > .sc-text-field-view > div > input.field:nth-child(2)'}
            else
              pv_text_field = {css: '.dg-graph-view > .sc-text-field-view > div > input.field'}
            end
            puts "text field: #{pv_text_field}"
            kcodap.click_on(BACKGROUND)
            kcodap.click_on(pv_text_field)
            input_formula("Plotted Value", kcodap)
            pvcounter+=1
          end
      end
      puts "before plotted function if statement"
      if checkbox.text == 'Plotted Function'
        puts 'in plotted function if statement'
        puts "pfcounter: #{pfcounter}"
        # if pfcounter>0
          pf_text_field = {css: '.dg-graph-view > .sc-text-field-view > div > input.field'}
        # else
        #   pf_text_field = {css: '.dg-graph-view > sc-text-field-view > div > input.field'}
        # end
        kcodap.click_on(BACKGROUND)
        kcodap.click_on(pf_text_field)
        if first_time(pfcounter)
          input_formula("Plotted Function", kcodap)
          pfcounter+=1
        end
      end
    end

    # checkbox_texts +=checkbox.text
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

  array_of_plots = [{:attribute=>'ACAT1', :axis=>'y', :collection=>'Table A'},
                    {:attribute=>'BCAT1', :axis=>'x', :collection=>'Table B'},
                    {:attribute=>'ANUM1', :axis=>'x', :collection=>'Table A'},
                    {:attribute=>'BNUM1', :axis=>'y', :collection=>'Table B'},
                    {:attribute=>'BCAT1', :axis=>'x', :collection=>'Table B'},
                    {:attribute=>'CCAT1', :axis=>'y', :collection=>'Table C'},
                    {:attribute=>'CNUM1', :axis=>'x', :collection=>'Table C'},
                    {:attribute=>'BNUM1', :axis=>'y', :collection=>'Table B'},
                    {:attribute=>'CCAT2', :axis=>'x', :collection=>'Table C'},
                    {:attribute=>'BCAT1', :axis=>'y', :collection=>'Table B'},
                    {:attribute=>'ACAT2', :axis=>'y', :collection=>'Table A'},
                    {:attribute=>'BCAT1', :axis=>'graph_legend', :collection=>'Table B'},
                    {:attribute=>'CNUM1', :axis=>'graph_legend', :collection=>'Table C'},
                    {:attribute=>'CNUM2', :axis=>'y', :collection=>'Table C'}]

  codap.start_codap(url)
# Open CODAP document
  codap.user_entry_open_doc
  codap.open_local_doc(file)
  sleep(1)
  open_doc.slice! '.json'
  codap.verify_doc_title(open_doc)

#Open a graph
  codap.click_button('graph')
  codap.wait_for{codap.displayed? (GRAPH_TILE) }
  sleep(5)
#Change axes by attribute, axis
  pvcounter=0 # Boolean for checking to see if first time plotted value is checked
  pfcounter=0 # Boolean for checking to see if first time plotted function is checked
  # sleep(3)
attempt = 0

array_of_plots.each do |hash|
  begin
    attempt = 0
    max_attempts = 5

    sleep(2)
    # codap.add_attribute_to_graph(hash[:attribute], hash[:axis])
    # codap.change_axis_attribute(hash[:axis], hash[:attribute], hash[:collection])
    codap.drag_attribute_to_graph(hash[:attribute], hash[:axis])
    sleep(2)
    # checkbox_texts = codap.get_list_of_ruler_checkboxes
    # click_on_checkboxes(codap,'on', pvcounter, pfcounter) #Turn on checkboxes
    checkbox_texts = click_on_checkboxes(codap,'on', pvcounter, pfcounter) #Turn on checkboxes
    sleep(2)
    # codap.write_log_file('./', open_doc)

    # codap.write_log_file('./', open_doc)
    codap.take_screenshot(hash[:attribute],hash[:axis], prev_attr, prev_axis, checkbox_texts)
    puts "Turn off checkboxes"
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
  end
end
codap.teardown

`rm -rf ~/Sites/plot_ruler_results/test_screenshots`
`mkdir -p ~/Sites/plot_ruler_results/test_screenshots`
`mv ~/Downloads/graph_*.png ~/Sites/plot_ruler_results/test_screenshots/`

size_compare_result = codap.compare_file_sizes(staging_screenshots_dir, expected_screenshots_dir)
puts ("#{size_compare_result}")
