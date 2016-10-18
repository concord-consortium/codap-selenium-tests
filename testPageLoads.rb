require './codap_object.rb'

screenshot_dir = "#{Dir.home}/Sites/doc_screenshots/"

File.open('CODAPDocLinks.txt').each do |url|
  codap = CODAPObject.new()
  codap.setup_one(:chrome)
  codap.visit(url)
  # TODO if url fails to load, try again max 5 times.
  puts "URL is #{url}"
  sleep(8)
  if url.include? "#"
    page_source = url.split('#').last
  else
    page_source = url.split('?').last
  end
  page_source = page_source.gsub(/[.:=%\/]/, "_").chop
  puts "Page_source is #{page_source}"
  # Prepare screenshots dir
  `mkdir -p #{screenshot_dir}`
  codap.save_screenshot(screenshot_dir, page_source)
  codap.write_log_file(screenshot_dir, page_source)
  codap.teardown
 end