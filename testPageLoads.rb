require './codap_object.rb'
require 'selenium-webdriver'

screenshot_dir = "#{Dir.home}/Sites/doc_screenshots"

File.open('CODAPDocLinks copy.txt').each do |url|
  codap = CODAPObject.new()
  codap.setup_one(:chrome)
  codap.visit(url)
  # TODO if url fails to load, try again max 5 times.
  puts "URL is #{url}"
  sleep(5)
  page_title = codap.title
  puts "Page title is #{page_title}"
  #Prepare screenshots dir
  `mkdir -p #{screenshot_dir}`
  codap.save_screenshot(screenshot_dir, page_title)
  codap.write_log_file(screenshot_dir, page_title)
  codap.teardown
end