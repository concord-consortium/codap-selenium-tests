require 'selenium-webdriver'
require 'rspec/expectations'
include RSpec::Matchers
require '~/development/codap-selenium-tests/LogReporter'

class CodapBaseObject

  def setup_one(browser)
    @@driver = Selenium::WebDriver.for browser
    if browser!=:safari
      manage_window_size
    end
  rescue Exception => e
    puts e.message
    puts "Could not start driver #{@@driver}"
    exit
  end

  # def setup_caps(platform, browser)
  #   puts "In setup_caps #{platform}, #{browser}"
  #   caps = Selenium::WebDriver::Remote::Capabilities.new
  #   if browser == "iPad"
  #     caps['appiumVersion'] = '1.6.3'
  #     caps['deviceName'] = 'iPad Simulator'
  #     caps['platformName'] = 'iOS'
  #     caps['platformVersion'] = '9.3'
  #     caps['deviceOrientation'] = 'landscape'
  #     caps['browserName'] = 'Safari'
  #     caps['rotatable'] = true
  #   elsif browser == "Android" #Need an Android Emulator that runs Chrome instead of generic Browser
  #     caps['appiumVersion'] = '1.6.3'
  #     caps['platformName'] = 'Android'
  #     caps['platformVersion'] = '6.0'
  #     caps['browserName'] ='Chrome'
  #     caps['deviceName'] = 'Android Emulator'
  #     caps['deviceOrientation'] = 'landscape'
  #     caps['nativeWebScreenshot'] = true
  #     caps['rotatable'] = true
  #   else
  #     caps['platform'] = platform
  #     caps['browserName'] = browser
  #     caps['logging_prefs'] = {:browser => "ALL"}
  #   end
  #   puts "Caps are #{caps}"
  #   return caps
  # end
  #
  # #does not work for tests that need to open a CODAP file
  # def setup_remote(caps)
  #   puts "in setup_remote #{caps}"
  #   @@driver = Selenium::WebDriver.for(:remote,
  #                                      :url => "http://eireland:b64ffb1e-a71d-40db-a73c-67a8b43620b6@ondemand.saucelabs.com:80/wd/hub",
  #                                      :desired_capabilities => caps)
  #   rescue Exception => e
  #     puts e.message
  #     puts "Could not start driver #{@@driver}"
  #     exit
  # end
  #
  # def setup_grid(caps)
  #   puts "in setup_remote #{caps}"
  #   @@driver = Selenium::WebDriver.for (
  #       :remote,
  #       :url=> 'http://localhost:4444/wd/hub',
  #       :desired_capabilities=> caps )
  # rescue Exception => e
  #   puts e.message
  #   puts "Could not start driver #{@@driver}"
  #   exit
  # end

  def teardown
    @@driver.quit
  end

  def manage_window_size
    # target_size = Selenium::WebDriver::Dimension.new(1680,1023)
    # @@driver.manage.window.size = target_size
    @@driver.manage.window.maximize
  end

  def visit(url='/')
    @@driver.get(url)
    # if browser
    # manage_window_size
  end

  def verify_page(title)
    puts "Page title is #{@@driver.title}"
    expect(@@driver.title).to include(title)
  end

  def get_url
    puts "In get url"
    @@driver.current_url
  end

  def get_page_title
    return @@driver.title
  end

  def find(locator)
    @@driver.find_element locator
  end

  def find_all(locator)
    @@driver.find_elements locator
  end

  def clear(locator)
    find(locator).clear
  end

  def type(locator, input)
    wait_for{displayed?(locator)}
    find(locator).send_keys input
  end

  def click_on(locator)
    wait_for {displayed?(locator)}
    find(locator).click
  end

  def click_with_offset(locator,xoffset, yoffset)
    puts "in click with offset"
    element = find(locator)
    @@driver.action.move_to(element, xoffset, yoffset).click.perform
  end

  def click_hold(locator,duration)
    element = @@driver.find(locator)
    @@driver.action.click_and_hold(element).perform
    sleep(duration)
    @@driver.action.release(element).perform
  end

  def hover(locator)
    @@driver.action.move_to(locator).perform
  end

  def drag_and_drop(source_loc, target_loc) #source_loc and target_loc have to be Selenium locators alread. Find both locs first
    @@driver.action.drag_and_drop(source_loc, target_loc).perform
  end

  def displayed?(locator)
    @@driver.find_element(locator).displayed?
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def text_of(locator)
    wait_for {displayed?(locator)}
    find(locator).text
  end

  def title
    @@driver.title
  end

  def submit_form(locator, input)
    puts "in submit form"
      clear(locator)
      find(locator).send_keys input
      find(locator).send_keys :return
  end

  def save_screenshot(dir,page_title)
    puts "in get_screenshot"
    file_name = page_title.gsub(/[?\/\s]/, '_')
    @@driver.save_screenshot "#{dir}/#{file_name}.png"
  end

  def write_log_file(dir_path, filename)
    log = @@driver.manage.logs.get(:browser)
    messages = ""
    log.each {|item| messages += item.message + "\n"}

    if !File.exist?("#{dir_path}/#{filename}.txt")
      File.open("#{dir_path}/#{filename}.txt", "wb") do |log|
        log<< messages unless messages == ""
      end
    else
      File.open("#{dir_path}/#{filename}.txt", "a") do |log|
        log << messages unless messages == ""
      end
    end
  end

  def write_to_file(dir_path, filename, message)
    if !File.exist?("#{dir_path}/#{filename}.txt")
      File.open("#{dir_path}/#{filename}.txt", "wb") do |responses|
        responses<< message unless message == ""
      end
    else
      File.open("#{dir_path}/#{filename}.txt", "a") do |responses|
        responses << message unless message == ""
      end
    end
  end

  def wait_for(seconds=45)
    Selenium::WebDriver::Wait.new(:timeout => seconds).until { yield }
  end

  def pop_up_click(locator)
    puts "In pop_up_click"
    @@driver.action.click(locator).perform
  end

  def pop_up_type(locator, input)
    puts "In pop_up_type. Input is: #{input}"
    @@driver.action.send_keys(locator, input).perform
  end

  def move_to(locator)
    @@driver.action.move_to(locator).perform
  end

  def switch_to_main()
    puts "in switch to main"
    @@driver.switch_to.default_content()
  end

  def switch_to_alert()
    puts "In switch to alert"
    @@driver.switch_to.alert()
  end

  def switch_to_modal()
    puts "In switch to modal"
    @@driver.switch_to.active_element()
  end

  def switch_to_iframe(locator)
    puts "In switch to iframe"
    # iframe = find(locator)
    @@driver.switch_to.frame(locator)
  end

  def get_tab_handles
    return @@driver.window_handles
  end

  def switch_to_tab(handle)
    puts "in switch to tab"
    @@driver.switch_to.window(handle)
  end

  def switch_to_first_tab()
    puts "in switch to first tab"
    @@driver.switch_to.window(@@driver.window_handles.first)
    window_handle = @@driver.window_handles.first
    return window_handle
  end

  def switch_to_last_tab()
    puts "in switch to last tab"
    # @@driver.action.send_keys(:control + :tab).perform
    @@driver.switch_to.window(@@driver.window_handles.last)
    window_handle = @@driver.window_handles.last
    return window_handle
  end

  def close_tab(handle)
    puts "in close tab"
    @@driver.switch_to.window(handle)
    @@driver.close
  end


  def switch_to_last_window()
    @@driver.switch_to.window(@@driver.window_handles.last)
  end

  def select_menu_item(menu_item_text)
    puts 'in select_menu_item'
    menu_item = {xpath: "//div/a[contains(@class,'menu-item')]/span[contains(text(),'#{menu_item_text}')]"}
    wait_for {displayed? (menu_item)}
    click_on(menu_item)
  end

  def select_from_dropdown(dropdown, dropdown_locator, item)
    puts "In select from dropdown"
    dropdown_loc = find(dropdown)
    click_on(dropdown)
    sleep(3)
    list_item = {xpath: "#{dropdown_locator}ul/li/a[contains(text(),'#{item}')]"}#templatePulldown>span>ul>li
    click_on(list_item)
  end

  def get_link(page_locator)
    return page_locator.attribute('href')
  end

  def chrome_print(type)
    print_save_button =  {css: '#print-header > div > button.print.default'}
    change_destination = {css: '#destination-settings > div.right-column > button'}
    pdf = {xpath: '//ul/li/span/span[contains(@title,"Save as PDF")]'}

    case (type)
      when "pdf"
        destination = pdf
    end
    switch_to_last_window
    click_on(change_destination)
    sleep(2)
    click_on(destination)
    click_on(print_save_button)
    sleep(1)
    keys = 'return'
    system('osascript -e \'tell application "System Events" to keystroke ' + keys + "'")
  end

  def compare_images(path_a, path_b)
    return 100 if !File.exist?(path_a) || !File.exist?(path_b)
    a = Magick::Image.read(path_a).first
    b = Magick::Image.read(path_b).first
    a.resize!(b.columns, b.rows) if a.columns != b.columns || a.rows != b.rows
    a.compare_channel(b, Magick::RootMeanSquaredErrorMetric)[1] * 100
  end

  def compare_file_sizes(dir_a, dir_b)
    file_mismatch = []
    missing_expected_files = []
    dir_a_files = Dir.entries(dir_a)
    dir_b_files = Dir.entries(dir_b)
    num_files_a = dir_a_files.length
    num_files_b = dir_b_files.length

    while dir_a_files.length > 0
      file = dir_a_files[0]
      if File.exists?("#{dir_b}/#{file}")
        if File.size("#{dir_a}/#{file}") != File.size("#{dir_b}/#{file}")
          if file!= '.'
            file_mismatch.push(file)
          end
        end
      else
        missing_expected_files.push(file)
      end
      dir_a_files.shift
    end

    if file_mismatch.length == 0 && missing_expected_files.length == 0
      return "ALL FILES MATCH"
    else
      return "These files do not match #{file_mismatch}. These expected files are missing #{missing_expected_files}"
    end
  end

end