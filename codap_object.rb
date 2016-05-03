class CODAPObject

  SPLASHSCREEN = {css: '.focus'}
  DATA_INTERACTIVE = { css: 'iframe'}
  DOC_TITLE = {css: '.doc-title'}
  FILE_MENU = { css: '.nav-popup-button'}
  TOOLSHELF_BACK = { css: '.toolshelf-background'}
  TABLE_BUTTON = { css: '.dg-table-button' }
  GRAPH_BUTTON = { css: '.dg-graph-button'  }
  MAP_BUTTON = {css: '.dg-map-button'}
  SLIDER_BUTTON = {css: '.dg-slider-button' }
  CALC_BUTTON = {css: '.dg-calc-button' }
  TEXT_BUTTON = {css: '.dg-text-button' }
  UNDO_BUTTON = {css: '.dg-undo-button' }
  REDO_BUTTON = {css: '.dg-redo-button' }
  TILE_LIST_BUTTON ={css: '.dg-tilelist-button' }
  OPTION_BUTTON = {css: '.dg-option-button' }
  GUIDE_BUTTON   = {css: '.dg-guide-button' }
  HELP_BUTTON = {css: '.navBar-help'}
  LOGIN_USER = {css: '.navBar-status'}
  H_SCROLLER = {css: '.sc-horizontal, .sc-scroller-view'}
  SCROLL_H_RIGHT = {css: '.thumb'}
  CASE_TABLE_TILE = {css: '.dg-case-table'}
  GRAPH_TILE = {css: '.graph-view'}
  MAP_TILE = {css: '.leaflet-container'}
  SLIDER_TILE = {css: '.slider-thumb'}
  TEXT_TILE = {css: '.text-area'}
  CALC_TILE = {css: '.calculator'}
  HELP_TILE = {css: }
  TILE_ICON_SLIDER = {css: '.tile-icon-slider'}
  ALERT_DIALOG = {xpath: '//div[contains(@role, "alertdialog")]'}
  NOT_SAVED_CLOSE_BUTTON = {xpath: '//div[contains(@class, "sc-alert)]/div/div/div[contains(@label,"Close")]'}
  SINGLE_TEXT_DIALOG_TEXTFIELD = {css: '.dg-single-text-dialog-textfield'}
  SINGLE_TEXT_DIALOG_OK_BUTTON = {css: '.dg-single-text-dialog-ok'} #Graph Screenshot, Display Webpage
  SINGLE_TEXT_DIALOG_CANCEL_BUTTON = {css: '.dg-single-text-dialog-cancel'}
  VIEW_WEBPAGE_MENU_ITEM = { id: 'dg-optionMenuItem-view_webpage'}

  attr_reader :driver

  def initialize(driver)
    @driver = driver
    visit
    verify_page
    dismiss_splashscreen
  end

  def visit
    driver.get ENV['base_url']
  end

  def open_file_menu
    driver.find_element(FILE_MENU).click
  end

  def not_saved_alert_close_button
    wait_for {displayed?(ALERT_DIALOG)}
    wait_for {displayed?(NOT_SAVED_CLOSE_BUTTON)}
    driver.find_element(NOT_SAVED_CLOSE_BUTTON).click
  end

  def click_button(button)
    case (button)
      when 'table'
        element = TABLE_BUTTON
      when 'graph'
        element = GRAPH_BUTTON
      when 'map'
        element = MAP_BUTTON
      when 'slider'
        element = SLIDER_BUTTON
      when 'calc'
        element = CALC_BUTTON
      when 'text'
        element = TEXT_BUTTON
      when 'tile'
        element = TILE_LIST_BUTTON
      when 'option'
        element = OPTION_BUTTON
      when 'guide'
        element = GUIDE_BUTTON
      when 'tooslhelf'
        element = TOOLSHELF_BACK
      when 'single_text_dialog_ok'
        element = SINGLE_TEXT_DIALOG_OK_BUTTON
      when 'single_text_dialog_cancel'
        element = SINGLE_TEXT_DIALOG_CANCEL_BUTTON
    end

    puts "button is #{button}, element is #{element}"
    wait_for {displayed?(element)}
    driver.find_element(element).click
  end

  def click_toolshelf
    driver.find_element(TOOLSHELF_BACK).click
  end

  def drag_attribute(header_name, graph_target)
    #drag_scroller
    #drag_scroller_right
    source_loc = get_column_header(header_name)
    case (graph_target)
      when 'x'
        target_loc = driver.find_element(GRAPH_H_AXIS)
      when 'y'
        target_loc = driver.find_element(GRAPH_V_AXIS)
      when 'legend'
        target_loc = driver.find_element(GRAPH_PLOT_VIEW)
        wait_for { displayed?(GRAPH_LEGEND)}
    end
    driver.action.drag_and_drop(source_loc, target_loc).perform
  end

  def drag_scroller
    scroll = driver.find_element(H_SCROLLER)
    driver.action.drag_and_drop_by(scroll, 100, 0).perform
  end

  def drag_scroller_right
    puts "In drag_scroller_right"
    scroll_right = driver.find_element(SCROLL_H_RIGHT)
    puts "Found element #{scroll_right}"
    driver.action.drag_and_drop_by(scroll_right, 50, 0).perform
    #scroll_right.click
  end

  private
  def verify_page
    expect(driver.title).to include('CODAP')
  end

  def wait_for(seconds=25)
    puts "Waiting"
    Selenium::WebDriver::Wait.new(:timeout => seconds).until { yield }
  end

  def verify_tile(button)
    case (button)
      when TABLE_BUTTON
        #puts "Table button clicked"
        wait_for { displayed?(CASE_TABLE_TILE) }
      when GRAPH_TILE
        wait_for { displayed?(GRAPH_TILE) }
      when MAP_BUTTON
        wait_for { displayed?(MAP_TILE) }
      when SLIDER_BUTTON
        wait_for { displayed?(SLIDER_TILE) }
      when CALC_BUTTON
        wait_for { displayed?(CALC_TILE) }
      when TEXT_BUTTON
        wait_for { displayed?(TEXT_TILE) }
        driver.find_element(TEXT_TILE).click
      when HELP_BUTTON
        # help_page_title = driver.find_element(:id, "block-menu-menu-help-categories")
        # wait_for {displayed?(help_page_title)}
        # expect(help_page_title.text).to include "CODAP Help"
        puts "Help button clicked."
      when TILE_LIST_BUTTON
        puts "Tile list button clicked"
      #driver.find_element(:xpath=> '//span[contains(@class, "ellipsis") and text()="No Data"]').click
      when OPTION_BUTTON
        wait_for {displayed? (VIEW_WEBPAGE_MENU_ITEM)}
        driver.find_element(VIEW_WEBPAGE_MENU_ITEM).click
        textfield = wait_for{driver.find_element(SINGLE_TEXT_DIALOG_TEXTFIELD)}
        driver.action.click(textfield).perform
        driver.find_element(SINGLE_TEXT_DIALOG_CANCEL_BUTTON).click
       # puts "Option button clicked"
      when GUIDE_BUTTON
        puts "Guide button clicked"
    end
  end

  def dismiss_splashscreen
    if !driver.find_element(SPLASHSCREEN) #Dismisses the splashscreen if present
      #sleep(5)
    else
      driver.find_element(SPLASHSCREEN).click
    end
  end

  def switch_to_dialog
    user_entry_dialog = driver.find_element(USER_ENTRY_DIALOG)
    driver.switch_to.alert(user_entry_dialog)
  end



  def select_menu_item(menu, menu_item)
    puts 'in select_menu_item'
    driver.find_element(menu)
    wait_for {displayed? (menu_item)}
    driver.find_element(menu_item).click
  end

  def displayed?(locator)
    driver.find_element(locator).displayed?
    puts "#{locator} found"
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    puts "#{locator} not found"
    false
  end

end
