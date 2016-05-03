class CODAPObject < BaseObject

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
  #HELP_TILE = {css: }
  TILE_ICON_SLIDER = {css: '.tile-icon-slider'}
  ALERT_DIALOG = {xpath: '//div[contains(@role, "alertdialog")]'}
  NOT_SAVED_CLOSE_BUTTON = {xpath: '//div[contains(@class, "sc-alert)]/div/div/div[contains(@label,"Close")]'}
  VIEW_WEBPAGE_MENU_ITEM = { id: 'dg-optionMenuItem-view_webpage'}

  #attr_reader :driver

  def initialize(driver)
    super
    visit
    verify_page
    dismiss_splashscreen
  end

  def open_file_menu
    click_on(FILE_MENU)
  end

  def not_saved_alert_close_button
    wait_for {displayed?(ALERT_DIALOG)}
    wait_for {displayed?(NOT_SAVED_CLOSE_BUTTON)}
    click_on(NOT_SAVED_CLOSE_BUTTON)
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
    click_on(TOOLSHELF_BACK)
  end

  def drag_scroller
    scroll = find(H_SCROLLER)
    driver.action.drag_and_drop_by(scroll, 100, 0).perform
  end

  def drag_scroller_right
    puts "In drag_scroller_right"
    scroll_right = find(SCROLL_H_RIGHT)
    puts "Found element #{scroll_right}"
    driver.action.drag_and_drop_by(scroll_right, 50, 0).perform
    #scroll_right.click
  end

  def verify_page
    expect(driver.title).to include('CODAP')
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
        click_on(TEXT_TILE)
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
        click_on(VIEW_WEBPAGE_MENU_ITEM)
        textfield = wait_for{find(SINGLE_TEXT_DIALOG_TEXTFIELD)}
        driver.action.click(textfield).perform
        find(SINGLE_TEXT_DIALOG_CANCEL_BUTTON).click
       # puts "Option button clicked"
      when GUIDE_BUTTON
        puts "Guide button clicked"
    end
  end

  def dismiss_splashscreen
    if !find(SPLASHSCREEN) #Dismisses the splashscreen if present
      #sleep(5)
    else
      find(SPLASHSCREEN).click
    end
  end

end
