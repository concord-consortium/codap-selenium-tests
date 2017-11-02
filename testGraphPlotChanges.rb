#testGraphPlotChanges test graph plot transitions and take graph screenshots of each transition. The data file 3TableGroups.json need to be in the same directory as the test. Plot transitions screenshots are saved separately by plot transition name. The test will run on latest version of CODAP in Mac OS X Chrome, Firefox and Safari, and Windows 8.1 Chrome, Firefox and Internet Explorer 11.

require './codap_object'

GRAPH_TILE = {css: '.dg-graph-view'}
"#{Dir.home}/Sites/doc_screenshot_results/test_screenshots/"
expected_screenshots_dir = "#{Dir.home}/Sites/plot_transition_results/expected_screenshots/"
staging_screenshots_dir = "#{Dir.home}/Sites/plot_transition_results/test_screenshots/"
prev_attr = ""
prev_axis = ""


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

begin
  attempt = 0
  max_attempts = 5

  codap = CODAPObject.new()
  codap.setup_one(:chrome)
  url = "https://codap.concord.org/releases/staging/"
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
                    {:attribute=>'ACAT1', :axis=>'graph_legend'},
                    {:attribute=>'CNUM1', :axis=>'y'},
                    {:attribute=>'BNUM1', :axis=>'x'},
                    {:attribute=>'ANUM1', :axis=>'graph_legend'},
                    {:attribute=>'BCAT1', :axis=>'x'},
                    {:attribute=>'CCAT2', :axis=>'y'},]

  codap.start_codap(url)
  # Open CODAP document
  codap.user_entry_open_doc
  codap.open_local_doc(file)
  open_doc.slice! '.json'
  codap.verify_doc_title(open_doc)

  #Open a graph
  codap.click_button('graph')
  codap.wait_for{codap.displayed? (GRAPH_TILE) }

  #Change axes by attribute, axis
  array_of_plots.each do |hash|
    sleep(2)
    codap.drag_attribute(hash[:attribute], hash[:axis])
    sleep(2)
    codap.write_log_file('./', open_doc)
    codap.take_screenshot(hash[:attribute],hash[:axis], prev_attr, prev_axis)
    prev_attr = hash[:attribute]
    prev_axis = hash[:axis]
  end
  codap.teardown

rescue => e
  puts '::ERROR::'
  puts e
  attempt +=1
  if attempt< max_attempts
    puts "RETRYING (#{attempt})..."
    retry
  end
end

`rm -rf ~/Sites/plot_transition_results/test_screenshots`
`mkdir -p ~/Sites/plot_transition_results/test_screenshots`
`mv ~/Downloads/graph_*.png ~/Sites/plot_transition_results/test_screenshots/`

size_compare_result = codap.compare_file_sizes(staging_screenshots_dir, expected_screenshots_dir)
puts ("#{size_compare_result}")