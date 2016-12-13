module GraphObject

  GRAPH_TILE = {css: '.graph-view'}
  GRAPH_H_AXIS = {css: '.h-axis>svg>text.axis-label'}
  GRAPH_V_AXIS = {css: '.v-axis>svg>text.axis-label'}
  GRAPH_V2_AXIS = {css: '.v2-axis'}
  GRAPH_PLOT_VIEW = {css: '.plot-view'}
  GRAPH_LEGEND = {css: '.legend-view>svg>text.axis-label'}
  AXIS_MENU_REMOVE = {xpath: '//div/a/span[contains(text(),"Remove")]'}
  GRAPH_RESCALE = {css: '.display-rescale'}
  GRAPH_HIDESHOW = {css: '.display-hideshow'}
  GRAPH_TRASH = {css: '.display-trash'}
  GRAPH_RULER = {css: '.display-values'}
  GRAPH_STYLES = {css: '.display-styles'}
  GRAPH_SCREENSHOT = {css: '.display-camera'}
  GRAPH_INSPECTOR_PICKER_PANEL = {css: '.inspector-picker'}
  GRAPH_COUNT = {css: '.graph-count-check'}
  GRAPH_PERCENT = {css: '.graph-percent-check'}
  GRAPH_PERCENT_ROW = {css: '.radio-0'}
  GRAPH_PERCENT_COLUMN = {css: '.radio-1'}
  GRAPH_PERCENT_CELL = {css: '.radio-2'}
  GRAPH_CONNECTING_LINE = {css: '.graph-connectingLine-check'}
  GRAPH_MOVABLE_VALUE = {css: '.graph-movableValue-check'}
  GRAPH_MOVABLE_LINE = {css: '.graph-movableLine-check'}
  GRAPH_LSR_LINE = {css: '.graph-lsrl-check'}
  GRAPH_INTERCEPT_LOCKED = {css: '.graph-interceptLocked-check'}
  GRAPH_MEAN = {css: '.graph-plottedMean-check'}
  GRAPH_MEDIAN = {css: '.graph-plottedMedian-check'}
  GRAPH_STD_DEV = {css: '.graph-plottedStdDev-check'}
  GRAPH_INTERQUARTILE = {css: '.graph-plottedIQR-check'}
  GRAPH_PLOTTED_VALUE = {css: '.graph-plottedValue-check'}
  GRAPH_PLOTTED_FUNCTION = {css: '.graph-plottedFunction-check'}
  GRAPH_SQUARES = {css: '.graph-squares-check'}
  GRAPH_BOX_PLOT = {css: '.graph-plottedBoxPlot-check'}
  GRAPH_POINT_SIZE_SLIDER = {css: '.graph-pointSize-slider'}
  GRAPH_POINT_COLOR_PICKER = {css: '.graph-point-color'}
  GRAPH_STROKE_COLOR_PICKER = {css: '.graph-stroke-color'}
  GRAPH_TRANSPARENT = {css: '.graph-transparent-check'}
  GRAPH_SCREENSHOT_DOWNLOAD = {css: '.buttons>a'}
  GRAPH_SCREENSHOT_INPUT_FILENAME = {css: '.localFileSave>input'}
  GRAPH_SCREENSHOT_DIALOG_TITLE = {css: '.modal-dialog-title'}

  SINGLE_TEXT_DIALOG_TEXTFIELD = {css: '.dg-single-text-dialog-textfield'}
  SINGLE_TEXT_DIALOG_OK_BUTTON = {css: '.dg-single-text-dialog-ok'} #Graph Screenshot, Display Webpage
  SINGLE_TEXT_DIALOG_CANCEL_BUTTON = {css: '.dg-single-text-dialog-cancel'}

  def remove_graph_attribute(graph_target)
    puts "In remove_graph_attribute"
    case (graph_target)
      when 'x'
        target_loc = find(GRAPH_H_AXIS)
      when 'y'
        target_loc = find(GRAPH_V_AXIS)
      when 'graph_legend'
        target_loc = find(GRAPH_LEGEND)
    end
    target_loc_text = target_loc.text
    puts "target text is #{target_loc_text}"
    target_loc.click
    puts "Clicked #{target_loc}"
    sleep(5)
    click_on(AXIS_MENU_REMOVE)
  end

  def take_screenshot(attribute,location)
    puts "in graph screenshot"
    click_on(GRAPH_TILE)
    puts "clicked on graph tile"
    click_on(GRAPH_SCREENSHOT)
    puts "clicked on graph_screenshot"
    wait_for{ displayed?(GRAPH_SCREENSHOT_DIALOG_TITLE) }
     screenshot_popup = find(GRAPH_SCREENSHOT_INPUT_FILENAME)
     puts "Found screenshot_popup at #{screenshot_popup}"
     screenshot_filename = "graph_#{attribute}_on_#{location} count" #add a specific folder to save snapshots to
     screenshot_popup.clear
     screenshot_popup.send_keys(screenshot_filename)
    sleep(3)
    wait_for{ displayed?(GRAPH_SCREENSHOT_DOWNLOAD)}
    download_button = find(GRAPH_SCREENSHOT_DOWNLOAD)
    puts "found download button at #{download_button}"
    click_on(GRAPH_SCREENSHOT_DOWNLOAD)
    puts "clicked on download button"
    sleep(3)
  end

  def open_ruler_tool
    wait_for{ displayed?(GRAPH_RULER)}
    sleep(1)
    click_on(GRAPH_RULER)
  end

  def turn_on_count()
    puts 'in turn_on_count'
      click_on(GRAPH_TILE)
      click_on(GRAPH_RULER)
    wait_for{ displayed?(GRAPH_COUNT)}
    sleep(1)
    click_on(GRAPH_COUNT)
    puts "clicked on graph count #{GRAPH_COUNT}"
  end

  def turn_off_count()
    puts 'in turn_on_count'
    click_on(GRAPH_TILE)
    click_on(GRAPH_RULER)
    wait_for{ displayed?(GRAPH_COUNT)}
    sleep(1)
    click_on(GRAPH_COUNT)
    puts "clicked on graph count #{GRAPH_COUNT}"
  end

  def turn_on_percent()
    puts 'in turn_on_percent'
    click_on(GRAPH_TILE)
    click_on(GRAPH_RULER)
    wait_for{ displayed?(GRAPH_PERCENT)}
    sleep(1)
    click_on(GRAPH_PERCENT)
    puts "clicked on graph percent #{GRAPH_PERCENT}"
  end

  def turn_off_percent()
    puts 'in turn_on_percent'
    click_on(GRAPH_TILE)
    click_on(GRAPH_RULER)
    wait_for{ displayed?(GRAPH_PERCENT)}
    sleep(1)
    click_on(GRAPH_PERCENT)
    puts "clicked on graph percent #{GRAPH_PERCENT}"
  end

  def show_percent_column()
    puts 'in show_percent_column'
    click_on(GRAPH_TILE)
    click_on(GRAPH_RULER)
    wait_for{ displayed?(GRAPH_PERCENT)}
    percent_checkbox = find(GRAPH_PERCENT)
    sleep(1)
    if (percent_checkbox.attribute('aria-checked') == 'false')
      click_on(GRAPH_PERCENT)
      puts "clicked on graph percent #{GRAPH_PERCENT}"
    end
    click_on(GRAPH_PERCENT_COLUMN)
    puts "clicked on graph percent column #{GRAPH_PERCENT_COLUMN}"
  end

  def show_percent_cell()
    puts 'in turn_on_percent'
    click_on(GRAPH_TILE)
    click_on(GRAPH_RULER)
    wait_for{ displayed?(GRAPH_PERCENT)}
    percent_checkbox = find(GRAPH_PERCENT)
    sleep(1)
    if (percent_checkbox.attribute('aria-checked') == 'false')
      click_on(GRAPH_PERCENT)
      puts "clicked on graph percent #{GRAPH_PERCENT}"
    end
    click_on(GRAPH_PERCENT_CELL)
    puts "clicked on graph percent column #{GRAPH_PERCENT_CELL}"
  end

  def show_percent_row()
    puts 'in turn_on_percent'
    click_on(GRAPH_TILE)
    click_on(GRAPH_RULER)
    wait_for{ displayed?(GRAPH_PERCENT)}
    percent_checkbox = find(GRAPH_PERCENT)
    sleep(1)
    if (percent_checkbox.attribute('aria-checked') == 'false')
      click_on(GRAPH_PERCENT)
      puts "clicked on graph percent #{GRAPH_PERCENT}"
    end
    click_on(GRAPH_PERCENT_ROW)
    puts "clicked on graph percent column #{GRAPH_PERCENT_ROW}"
  end
end