module GraphObject

  GRAPH_TILE = {css: '.dg-graph-view'}
  GRAPH_H_AXIS = {css: '.dg-axis-view.h-axis'}
  GRAPH_V_AXIS = {css: '.dg-axis-view.v-axis'}
  GRAPH_V2_AXIS = {css: '.dg-v2-axis'}
  GRAPH_PLOT_VIEW = {css: '.dg-plot-view'}
  GRAPH_LEGEND = {css: '.dg-legend-view>svg>text.dg-axis-label'}
  AXIS_MENU_REMOVE = {xpath: '//div/a[contains(@class,"menu-item")]/span[contains(text(),"Remove")]'}
  GRAPH_RESCALE = {css: '.dg-display-rescale'}
  GRAPH_HIDESHOW = {css: '.dg-display-hideshow'}
  GRAPH_TRASH = {css: '.dg-display-trash'}
  GRAPH_RULER = {css: '.dg-display-values'}
  GRAPH_STYLES = {css: '.dg-display-styles'}
  GRAPH_SCREENSHOT = {css: '.display-camera'}
  GRAPH_INSPECTOR_PICKER_PANEL = {css: '.dg-inspector-picker'}
  GRAPH_COUNT = {css: '.dg-graph-count-check'}
  GRAPH_PERCENT = {css: '.dg-graph-percent-check'}
  GRAPH_PERCENT_ROW = {css: '.dg.radio-0'}
  GRAPH_PERCENT_COLUMN = {css: '.dg.radio-1'}
  GRAPH_PERCENT_CELL = {css: '.dg.radio-2'}
  GRAPH_CONNECTING_LINE = {css: '.dg-graph-connectingLine-check'}
  GRAPH_MOVABLE_VALUE = {css: '.dg-movable-value-button'}
  GRAPH_MOVABLE_LINE = {css: '.dg-graph-movableLine-check'}
  GRAPH_LSR_LINE = {css: '.dg-graph-lsrl-check'}
  GRAPH_INTERCEPT_LOCKED = {css: '.dg-graph-interceptLocked-check'}
  GRAPH_MEAN = {css: '.dg-graph-plottedMean-check'}
  GRAPH_MEDIAN = {css: '.dg-graph-plottedMedian-check'}
  GRAPH_STD_DEV = {css: '.dg-graph-plottedStdDev-check'}
  # GRAPH_INTERQUARTILE = {css: '.graph-plottedIQR-check'}
  GRAPH_PLOTTED_VALUE = {css: '.dg-graph-plottedValue-check'}
  GRAPH_PLOTTED_FUNCTION = {css: '.dg-graph-plottedFunction-check'}
  GRAPH_SQUARES = {css: '.dg-graph-squares-check'}
  GRAPH_BOX_PLOT = {css: '.dg-graph-plottedBoxPlot-check'}
  GRAPH_POINT_SIZE_SLIDER = {css: '.dg-graph-pointSize-slider'}
  GRAPH_POINT_COLOR_PICKER = {css: '.dg-graph-point-color'}
  GRAPH_STROKE_COLOR_PICKER = {css: '.graph-stroke-color'}
  GRAPH_TRANSPARENT = {css: '.dg-graph-transparent-check'}
  GRAPH_SCREENSHOT_DOWNLOAD = {css: '.buttons>a'}
  GRAPH_SCREENSHOT_INPUT_FILENAME = {css: '.localFileSave>input'}
  GRAPH_SCREENSHOT_DIALOG_TITLE = {css: '.modal-dialog-title'}
  GRAPH_COUNT_PERCENTAGE = {xpath: '//div[contains(@class,"dg-plot-view")]/svg/text[contains(@class,"dg-graph-adornment-count"]/tspan'}

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
    puts "target text is #{target_loc_text}, target_loc is #{target_loc}"
    target_loc.click
    puts "Clicked #{target_loc}"
    sleep(5)
    select_menu_item("Remove")
    # click_on(AXIS_MENU_REMOVE)
  end

  def take_screenshot(attribute,location,other_attr="", other_axis="", checkboxes=[])
    puts "in graph screenshot"
    if (!displayed?(GRAPH_SCREENSHOT))
      click_on(GRAPH_TILE)
      puts "clicked on graph tile"
    end
    click_on(GRAPH_SCREENSHOT)
    puts "clicked on graph_screenshot"
    wait_for{ displayed?(GRAPH_SCREENSHOT_DIALOG_TITLE) }
     screenshot_popup = find(GRAPH_SCREENSHOT_INPUT_FILENAME)
     puts "Found screenshot_popup at #{screenshot_popup}"
     screenshot_filename = "graph_#{attribute}_on_#{location}_#{other_attr}_on_#{other_axis}_with_#{checkboxes}" #add a specific folder to save snapshots to
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

  def change_checkbox_state(checkbox, state)
    puts 'in change checkbox state'
      click_on(GRAPH_TILE)
      click_on(GRAPH_RULER)
      case (checkbox)
        when "count"
          element = GRAPH_COUNT
        when "percent"
          element = GRAPH_PERCENT
        when "mean"
          element = GRAPH_MEAN
        when "median"
          element = GRAPH_MEDIAN
        when "sd"
          element = GRAPH_STD_DEV
        when "boxplot"
          element = GRAPH_BOX_PLOT
        when "plotted_value"
          element = GRAPH_PLOTTED_VALUE
        when "plotted_function"
          element = GRAPH_PLOTTED_FUNCTION
        when "connecting_lines"
          element = GRAPH_CONNECTING_LINE
        when "movable_line"
          element = GRAPH_MOVABLE_LINE
        when "lsrl"
          element = GRAPH_LSR_LINE
        when "intercept_lock"
          element = GRAPH_INTERCEPT_LOCKED
        when "squares"
          element = GRAPH_SQUARES
      end

    wait_for{ displayed?(element)}
    sleep(1)
    click_on(element)
    # verify state
    el = find(element)
    puts "#{element} state is #{el.selected?.inspect}"
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