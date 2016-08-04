module GraphObject

  GRAPH_TILE = {css: '.graph-view'}
  GRAPH_H_AXIS = {css: '.h-axis'}
  GRAPH_V_AXIS = {css: '.v-axis'}
  GRAPH_V2_AXIS = {css: '.v2-axis'}
  GRAPH_PLOT_VIEW = {css: '.plot-view'}
  GRAPH_LEGEND = {css: '.legend-view'}
  AXIS_MENU_REMOVE = {xpath: '//div[contains(@class, "sc-menu-item")]/a/span[contains(text(),"Remove")]'}
  GRAPH_RESCALE = {css: '.display-rescale'}
  GRAPH_HIDESHOW = {css: '.display-hideshow'}
  GRAPH_TRASH = {css: '.display-trash'}
  GRAPH_RULER = {css: '.display-values'}
  GRAPH_STYLES = {css: '.display-styles'}
  GRAPH_SCREENSHOT = {css: '.display-camera'}
  GRAPH_COUNT = {css: '.graph-count-check'}
  GRAPH_CONNECTING_LINE = {css: '.graph-connectingLine-check'}
  GRAPH_MOVABLE_VALUE = {css: '.graph-movableValue-check'}
  GRAPH_MOVABLE_LINE = {css: '.graph-movableLine-check'}
  GRAPH_INTERCEPT_LOCKED = {css: '.graph-interceptLocked-check'}
  GRAPH_SQUARES = {css: '.graph-squares-check'}
  GRAPH_MEAN = {css: '.graph-plottedMean-check'}
  GRAPH_MEDIAN = {css: '.graph-plottedMedian-check'}
  GRAPH_STD_DEV = {css: '.graph-plottedStdDev-check'}
  GRAPH_INTERQUARTILE = {css: '.graph-plottedIQR-check'}
  GRAPH_PLOTTED_VALUE = {css: '.graph-plottedValue-check'}
  GRAPH_PLOTTED_FUNCTION = {css: '.graph-plottedFunction-check'}
  GRAPH_POINT_SIZE_SLIDER = {css: '.graph-pointSize-slider'}
  GRAPH_POINT_COLOR_PICKER = {css: '.graph-point-color'}
  GRAPH_STROKE_COLOR_PICKER = {css: '.graph-stroke-color'}
  GRAPH_TRANSPARENT = {css: '.graph-transparent-check'}

  SINGLE_TEXT_DIALOG_TEXTFIELD = {css: '.dg-single-text-dialog-textfield'}
  SINGLE_TEXT_DIALOG_OK_BUTTON = {css: '.dg-single-text-dialog-ok'} #Graph Screenshot, Display Webpage
  SINGLE_TEXT_DIALOG_CANCEL_BUTTON = {css: '.dg-single-text-dialog-cancel'}

  #menu items for trash and hide/show need to be added.

  def remove_graph_attribute(graph_target)
    puts "In remove_graph_attribute"
    case (graph_target)
      when 'x'
        target_loc = find(GRAPH_H_AXIS)
      when 'y'
        target_loc = find(GRAPH_V_AXIS)
      when 'legend'
        target_loc = find(GRAPH_LEGEND)
    end
    target_loc.click
    puts "Clicked #{target_loc}"
    if (find(AXIS_MENU_REMOVE))
      click_on(AXIS_MENU_REMOVE)
    else
      puts "Can't find menu"
    end

  end

  def take_screenshot(attribute,location)
    click_on(GRAPH_TILE)
    click_on(GRAPH_SCREENSHOT)
    wait_for{ displayed?(SINGLE_TEXT_DIALOG_TEXTFIELD) }
    screenshot_popup = find(SINGLE_TEXT_DIALOG_TEXTFIELD)
    puts "Found screenshot_popup at #{screenshot_popup}"
    pop_up_click(screenshot_popup)
    screenshot_filename = "#{attribute}_on_#{location}"
    pop_up_type(screenshot_popup, screenshot_filename)
    click_on(SINGLE_TEXT_DIALOG_OK_BUTTON)
  end

end