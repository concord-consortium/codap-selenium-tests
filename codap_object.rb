require './base_object'
require './cfm_object'
require './table_object'
require './graph_object'
require './map_object'

class CODAPObject < CodapBaseObject
  include CFMObject
  include TableObject
  include GraphObject
  include MapObject

  SPLASHSCREEN = {css: '.focus'}
  BACKGROUND = {css: 'menu-bar'}
  DATA_INTERACTIVE = { css: 'iframe'}
  DOC_TITLE = {css: '.menu-bar-content-filename'}
  DOC_FILE_STATUS = {css: 'span.menu-bar-file-status-alert'}
  FILE_MENU = { css: '.menu-anchor'}
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
  HELP_BUTTON = {css: '.dg-help-button'}
  VERSION_INFO = {css: 'span.menu-bar-info'}
  LOGIN_USER = {css: '.navBar-status'}
  H_SCROLLER = {css: '.sc-horizontal, .sc-scroller-view'}
  SCROLL_H_RIGHT = {css: '.thumb'}
  SLIDER_TILE = {css: '.slider-label'}
  TEXT_TILE = {css: '.text-area'}
  CALC_TILE = {css: '.calculator'}
#  OPEN_NEW_BUTTON = {id: 'dg-user-entry-new-doc-button'}
  OPEN_DOC_BUTTON = {id: 'dg-user-entry-open-doc-button'}
  AUTHORIZE_STARTUP_BUTTON = {id: 'dg-user-entry-authorize-startup-button'}
  TILE_ICON_SLIDER = {css: '.tile-icon-slider'}
  ALERT_DIALOG = {xpath: '//div[contains(@role, "alertdialog")]'}
  NOT_SAVED_CLOSE_BUTTON = {xpath: '//div[contains(@class, "sc-alert")]/div/div/div[contains(@label,"Close")]'}
  VIEW_WEBPAGE_MENU_ITEM = { id: 'dg-optionMenuItem-view_webpage'}
  OPTION_MENU_SEPARATOR ={css: '.menu-item.disabled'}
  OPEN_CODAP_WEBSITE = {id: 'dg-optionMenuItem-codap-website'}
  WEBVIEW_FRAME = {css: '.dg-web-view-frame'}
  TILE_MENU_ITEM = {css: 'a.menu-item'}
  HELP_MENU_ITEM = {css: '#dg-optionMenuItem-help-website > a > span[contains(text()="Help"'}
  HELP_PAGE_TITLE = {id: 'page-title'}

  def initialize()
    puts "Initializing"
  end

  def start_codap(url)
    visit(url)
    verify_page('CODAP')
    # dismiss_splashscreen #Splashscreen was repurposed to be the wait cursor for loading document and can no longer be dismissed.
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
    verifiable = ['table','graph','map','slider','calc','text','codap_site']

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
      when 'tilelist'
        element = TILE_LIST_BUTTON
      when 'option'
        element = OPTION_BUTTON
      when 'guide'
        element = GUIDE_BUTTON
      when 'help'
        element = HELP_MENU_ITEM
      when 'toolshelf'
        element = TOOLSHELF_BACK
      when 'background'
        element = BACKGROUND
      when 'separator'
        element = OPTION_MENU_SEPARATOR
      when 'examples'
        element = OPEN_EXAMPLE_DOCS
      when 'cloud'
        element = OPEN_CONCORD_CLOUD
      when 'google drive'
        element = OPEN_GOOGLE_DRIVE
      when 'local'
        element = OPEN_LOCAL_FILE
      when 'codap_site'
        element = OPEN_CODAP_WEBSITE
    end

    puts "button is #{button}, element is #{element}"
    click_on(element)
    if verifiable.include? button
      puts "#{button} Button is in verifiable"
      verify_tile(element)
    end
    if button == 'option'
      puts "In option if. #{OPEN_CODAP_WEBSITE}"
      click_on(OPEN_CODAP_WEBSITE)
      verify_tile(WEBVIEW_FRAME)
      sleep(5)
    end
    if button == "tilelist"
      puts "In tilelist if #{TILE_MENU_ITEM}"
      click_on(TILE_MENU_ITEM)
    end
    if button == 'help'
      puts "In help if #{HELP_MENU_ITEM}"
      click_on(HELP_MENU_ITEM)
    end
  end

  def undo
    click_on(UNDO_BUTTON)
  end

  def redo
    click_on(REDO_BUTTON)
  end

  def click_toolshelf
    #@codap_base.click_on(TOOLSHELF_BACK)
    @@driver.find_element(TOOLSHELF_BACK).click
  end

  def goto_table
    click_on(CASE_TABLE)
  end

  def drag_scroller
    scroll = find(H_SCROLLER)
    driver.action.drag_and_drop_by(scroll, 100, 0).perform
  end

  def drag_scroller_right
    puts "In drag_scroller_right"
    scroll_right = find(SCROLL_H_RIGHT)
    puts "Found element #{scroll_right}"
    @@driver.action.drag_and_drop_by(scroll_right, 50, 0).perform
    #scroll_right.click
  end

  def verify_tile(button)
    case (button)
      when TABLE_BUTTON
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
        # click_on(TEXT_TILE)
      when HELP_BUTTON
        # help_page_title = driver.find_element(:id, "block-menu-menu-help-categories")
        # wait_for {displayed?(help_page_title)}
        # expect(help_page_title.text).to include "CODAP Help"
        puts "Help button clicked."
      when TILE_LIST_BUTTON
        puts "Tile list button clicked"
      #driver.find_element(:xpath=> '//span[contains(@class, "ellipsis") and text()="No Data"]').click
      when OPTION_BUTTON
        wait_for {displayed? (OPEN_CODAP_WEBSITE)}
        click_on(OPEN_CODAP_WEBSITE)
        wait_for { displayed? WEBVIEW_FRAME}
      # puts "Option button clicked"
      when GUIDE_BUTTON
        puts "Guide button clicked"
      when OPEN_CODAP_WEBSITE
        wait_for { displayed? WEBVIEW_FRAME}
    end
  end

  def verify_doc_title(doc_name)
    sleep(3)
    expect(@@driver.title).to include(doc_name)
  end

  def dismiss_splashscreen
    if !find(SPLASHSCREEN) #Dismisses the splashscreen if present
      sleep(1)
    else
      click_on(SPLASHSCREEN)
    end
  end

end


