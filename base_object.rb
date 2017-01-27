require 'selenium-webdriver'
require 'rspec/expectations'
include RSpec::Matchers
require './LogReporter'

class CodapBaseObject
  SINGLE_TEXT_DIALOG_TEXTFIELD = {css: '.dg-single-text-dialog-textfield'}
  SINGLE_TEXT_DIALOG_OK_BUTTON = {css: '.dg-single-text-dialog-ok'} #Graph Screenshot, Display Webpage
  SINGLE_TEXT_DIALOG_CANCEL_BUTTON = {css: '.dg-single-text-dialog-cancel'}
  GRAPH_TILE = {css: '.graph-view'}
  GRAPH_H_AXIS = {css: '.h-axis'}
  GRAPH_V_AXIS = {css: '.v-axis'}
  GRAPH_V2_AXIS = {css: '.v2-axis'}
  GRAPH_PLOT_VIEW = {css: '.plot-view'}
  GRAPH_LEGEND = {css: '.legend-view'}
  MAP_VIEW = {css: '.leaflet-map-pane'}
  MAP_lEGEND = {css: '.legend-view'}
  IFRAME = {tag_name: 'iframe'}

  def setup_one(browser)
    @@driver = Selenium::WebDriver.for browser
    rescue Exception => e
      puts e.message
      puts "Could not start driver #{@@driver}"
      exit
  end

  def setup_caps(platform, browser)
    puts "In setup_caps #{platform}, #{browser}"
    caps = Selenium::WebDriver::Remote::Capabilities.new
    caps[:platform] = platform
    caps[:browserName] = browser
    caps[:logging_prefs] = {:browser => "ALL"}
    return caps
  end

  # def setup_remote(caps)
  #   puts "in setup_remote #{caps}"
  #   @@driver = Selenium::WebDriver.for (
  #     :remote,
  #     :url=> 'http://localhost:4444/wd/hub',
  #     :desired_capabilities=> caps )
  #   rescue Exception => e
  #     puts e.message
  #     puts "Could not start driver #{@@driver}"
  #     exit
  # end

  def teardown
    @@driver.quit
  end

  def visit(url)
    puts "IN VISIT"
    @@driver.get(url)
    @@driver.manage.window.maximize
  end

  def verify_page(title)
    puts "Page title is #{@@driver.title}"
    expect(@@driver.title).to include(title)
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
    find(locator).send_keys input
  end

  def click_on(locator)
    find(locator).click
  end

  def displayed?(locator)
    @@driver.find_element(locator).displayed?
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def text_of(locator)
    find(locator).text
  end

  def title
    @@driver.title
  end

  def save_screenshot(dir,page_title)
    puts "in get_screenshot"
    @@driver.save_screenshot "#{dir}/#{page_title}#{Time.now.strftime("_%d_%m_%Y__%H_%M_%S")}.png"
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

  def wait_for(seconds=25)
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

  def switch_to_dialog(dialog)
    puts "In switch to dialog"
    @@driver.switch_to.alert()
  end

  def switch_to_iframe(locator)
    puts "In switch to iframe"
    @@driver.switch_to.frame(locator)
  end

  def switch_to_main()
    puts "in switch to main"
    @@driver.switch_to.default_content
  end

  def switch_to_first_tab()
    puts "in switch to first tab"
    @@driver.switch_to.window(@@driver.window_handles.first)
    window_handle = @@driver.window_handles.first
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

  # def select_menu_item(menu, menu_item)
  #   puts 'in select_menu_item'
  #   find(menu)
  #   wait_for {displayed? (menu_item)}
  #   click_on(menu_item)
  # end

  def select_menu_item(menu_item_text)
    puts 'in select_menu_item'
    menu_item = {xpath: "//div/a/span[contains(text(),'#{menu_item_text}')]"}
    wait_for {displayed? (menu_item)}
    click_on(menu_item)
  end

  def drag_attribute(source_element, target_element)
    #drag_scroller
    #drag_scroller_right
    source_loc = get_column_header(source_element)
    case (target_element)
      when 'x'
        target_loc = find(GRAPH_H_AXIS)
      when 'y'
        target_loc = find(GRAPH_V_AXIS)
      when 'graph_legend'
        target_loc = find(GRAPH_PLOT_VIEW)
        wait_for { displayed?(GRAPH_LEGEND)}
      when 'map_legend'
        target_loc = find(MAP_LEGEND)
    end
    @@driver.action.drag_and_drop(source_loc, target_loc).perform
  end

end