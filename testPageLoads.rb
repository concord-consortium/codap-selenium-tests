require './codap_object.rb'

LISTING = {css: ".listing-title"}

screenshot_dir = "#{Dir.home}/Sites/doc_screenshots/"
`mkdir -p #{screenshot_dir}`

# TODO change script so it loads CODAP Sample docs and CODAP Plug-in Page and clicks on each link

def fixPageSourceName(url)

end

def openMiscLinks(screenshot_dir)
  File.open('CODAPDocLinks.txt').each do |url|
    codap = CODAPObject.new()
    codap.setup_one(:chrome)
    codap.visit(url)
    # TODO if url fails to load, try again max 5 times.
    puts "URL is #{url}"
    sleep(30)
    if url.include? "#"
      page_source = url.split('#').last
    else
      page_source = url.split('?').last
    end
    page_source = page_source.gsub(/[.:=%\/]/, "_").chop
    puts "Page_source is #{page_source}"
    # Prepare screenshots dir
    codap.save_screenshot(screenshot_dir, page_source)
    codap.write_log_file(screenshot_dir, page_source)
    codap.teardown
  end
end

def openPluginLinks(screenshot_dir)
  pluginURL = "https://concord-consortium.github.io/codap-data-interactives/"

  codap = CODAPObject.new()
  codap.setup_one(:chrome)
  codap.visit(pluginURL)
  plugins = codap.find_all(LISTING)
  if plugins.length>0
    plugins.each do |plugin|
      plugin_title = plugin.text
      puts "Plugin text is #{plugin.text}"
    plugin.click
    sleep(15)
    tab_handles=codap.get_tab_handles
    codap.switch_to_tab(tab_handles[1])
    codap.save_screenshot(screenshot_dir, plugin_title) # Take screenshot
    codap.write_log_file(screenshot_dir, plugin_title) # Write log file
    codap.close_tab(tab_handles[1])
    codap.switch_to_tab(tab_handles[0])
    end
  else
    puts "No plugins in the list"
  end

  codap.teardown

end

def openSampleDocLinks(screenshot_dir)
  pluginURL = "https://concord-consortium.github.io/codap-data/"

  codap = CODAPObject.new()
  codap.setup_one(:chrome)
  codap.visit(pluginURL)
  sample_docs = codap.find_all(LISTING)
  if sample_docs.length>0
    sample_docs.each do |doc|
      doc_title = doc.text
      puts "Doc text is #{doc_title}"
      doc.click
      sleep(15)
      tab_handles=codap.get_tab_handles
      codap.switch_to_tab(tab_handles[1])
      codap.save_screenshot(screenshot_dir, doc_title) # Take screenshot
      codap.write_log_file(screenshot_dir, doc_title) # Write log file
      tab_handle = codap.switch_to_last_tab()
      codap.close_tab(tab_handles[1])
      codap.switch_to_tab(tab_handles[0])
    end
  else
    puts "No docs in the list"
  end

  codap.teardown

end

openMiscLinks(screenshot_dir)
openPluginLinks(screenshot_dir)
openSampleDocLinks(screenshot_dir)