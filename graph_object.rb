class GraphObject

  GRAPH_TILE = {css: '.graph-view'}
  GRAPH_H_AXIS = {css: '.h-axis'}
  GRAPH_V_AXIS = {css: '.v-axis'}
  GRAPH_V2_AXIS = {css: '.v2-axis'}
  GRAPH_PLOT_VIEW = {css: '.plot-view'}
  GRAPH_LEGEND = {css: '.legend-view'}
  AXIS_MENU_REMOVE = {xpath: '//div[contains(@class, "sc-menu-item")]/a/span[contains(text(),"Remove")]'}
  GRAPH_SCREENSHOT = {css: '.display-camera'}

  attr_reader :driver

  def initialize
    @driver = driver
  end

  def remove_graph_attribute(graph_target)
    puts "In remove_graph_attribute"
    case (graph_target)
      when 'x'
        target_loc = driver.find_element(GRAPH_H_AXIS)
      when 'y'
        target_loc = driver.find_element(GRAPH_V_AXIS)
      when 'legend'
        target_loc = driver.find_element(GRAPH_LEGEND)
    end
    target_loc.click
    puts "Clicked #{target_loc}"
    if (driver.find_element(AXIS_MENU_REMOVE))
      driver.find_element(AXIS_MENU_REMOVE).click
    else
      puts "Can't find menu"
    end

  end

  def take_screenshot(attribute,location)
    driver.find_element(GRAPH_TILE).click
    sleep(3)
    driver.find_element(GRAPH_SCREENSHOT).click
    screenshot_popup = wait_for{driver.find_element(SINGLE_TEXT_DIALOG_TEXTFIELD)}
    puts "Found screenshot_popup at #{screenshot_popup}"
    driver.action.click(screenshot_popup).perform
    screenshot_filename = "#{attribute}_on_#{location}"
    driver.action.send_keys(screenshot_popup, screenshot_filename).perform
    driver.find_element(SINGLE_TEXT_DIALOG_OK_BUTTON).click

  end


end