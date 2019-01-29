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
  BACKGROUND = {css: '.toolshelf-background'}
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
  PLUGIN_BUTTON = {css: '.dg-plugin-button'}
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
  SLIDER_TILE = {css: '.dg-slider-label'}
  TEXT_TILE = {css: '.text-area'}
  CALC_TILE = {css: '.dg-calculator'}
  TILE_ICON_SLIDER = {css: '.tile-icon-slider'}
  ALERT_DIALOG = {xpath: '//div[contains(@role, "alertdialog")]'}
  NOT_SAVED_CLOSE_BUTTON = {xpath: '//div[contains(@class, "sc-alert")]/div/div/div[contains(@label,"Close")]'}
  OPTION_MENU_SEPARATOR ={css: '.menu-item.disabled'}
  OPEN_HELP_WEBSITE = {id:'dg-optionMenuItem-help-website'}
  OPEN_CODAP_WEBSITE = {id: 'dg-optionMenuItem-codap-website'}
  WEBVIEW_FRAME = {css: '.dg-web-view'}
  TILE_MENU_ITEM = {css: 'a.menu-item'}
  HELP_PAGE_TITLE = {id: '#page-title'}
  DISPLAY_WEBSITE = {id: 'dg-optionMenuItem-view_webpage'}
  SINGLE_TEXT_DIALOG_TEXTFIELD = {css: '.dg-single-text-dialog-textfield'}
  SINGLE_TEXT_DIALOG_OK_BUTTON = {css: '.dg-single-text-dialog-ok'} #Graph Screenshot, Display Webpage
  SINGLE_TEXT_DIALOG_CANCEL_BUTTON = {css: '.dg-single-text-dialog-cancel'}
  GRAPH_TILE = {css: '.dg-graph-view'}
  IFRAME = {tag_name: 'iframe'}
  NEW_TABLE = {css: '.sc-menu > .sc-menu-scroll-view >  .sc-container-view > .sc-view > .sc-menu-item > .menu-item span'}
  CASE_TABLE_TILE = {css: '.dg-case-table-view'}
  PLUGIN_SAMPLER_MENU_ITEM = {id: 'dg-pluginMenuItem-Sampler'}
  PLUGIN_DRAW_TOOL_MENU_ITEN = {id: 'dg-pluginMenuItem-Draw-Tool'}
  SAMPLER_WEBVIEW = {xpath: '//iframe[contains(@src,"TP-Sampler"'}
  SAMPLER = {css: '#sampler'}
  DRAW_TOOL_WEBVIEW = {xpath: '//iframe[contains(@src,"DrawTool"'}
  DRAW_TOOL_PALETTE = {css: '#drawing-tool > .dt-container > .dt-tools'}
  LEARN_WEBVIEW = {xpath: '//iframe[contains(@src,"learn.concord.org")]'}
  CONCORD_LOGO = {css: '.concord-logo'}
  TILE_LIST_LAST_ITEM = {css: '.menu > .sc-menu-scroll-view > .sc-container-view > .sc-view > .sc-menu-item'}
# These are here for dragging elements across tiles
  GRAPH_H_AXIS = {css: '.dg-axis-view.dg-h-axis'}
  GRAPH_V_AXIS = {css: '.dg-axis-view.dg-v-axis'}
  GRAPH_V2_AXIS = {css: '.dg-v2-axis'}
  GRAPH_PLOT_VIEW = {css: '.dg-plot-view'}
  GRAPH_LEGEND = {css: '.dg-legend-view'}
  MAP_VIEW = {css: '.leaflet-map-pane'}
  MAP_lEGEND = {css: '.dg-legend-view'}


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
    verifiable = ['table','graph','map','slider','calc','text','option', 'tilelist', 'help','codap_site']

    case (button)
      when 'table'
        click_on(TABLE_BUTTON)
        sleep(1)
        element = NEW_TABLE
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
      when 'plugin'
        element = PLUGIN_BUTTON
      when 'tilelist'
        click_on(TILE_LIST_BUTTON)
        sleep(1)
        element = TILE_LIST_LAST_ITEM
      when 'option'
        click_on(OPTION_BUTTON)
        sleep(1)
        element = DISPLAY_WEBSITE
      when 'guide'
        element = GUIDE_BUTTON
      when 'help'
        element=HELP_BUTTON
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
        click_on(HELP_BUTTON)
        sleep(1)
        element = OPEN_CODAP_WEBSITE
      when 'sampler'
        click_on(PLUGIN_BUTTON)
        element = PLUGIN_SAMPLER_MENU_ITEM
      when 'draw tool'
        click_on(PLUGIN_BUTTON)
        element = PLUGIN_DRAW_TOOL_MENU_ITEN
    end

    puts "button is #{button}, element is #{element}"
    if ((button=="table") || (button=="sampler") || (button=="draw tool") || (button=="tilelist") || (button=="codap_site"))
        menu_item = find(element)
        puts "menu item is #{menu_item}"
        sleep(2)
        puts "The menu item is #{text_of(element)}"
        menu_item.click
        sleep(2)
    elsif (button=="option")
        menu_item = find(element)
        puts "menu item is #{menu_item}"
        sleep(2)
        puts "The menu item is #{text_of(element)}"
        menu_item.click
        wait_for { displayed? SINGLE_TEXT_DIALOG_TEXTFIELD}
      input_field = find(SINGLE_TEXT_DIALOG_TEXTFIELD)
      pop_up_type(input_field,"https://learn.concord.org")
      wait_for {displayed? (SINGLE_TEXT_DIALOG_OK_BUTTON)}
      pop_up_click(find(SINGLE_TEXT_DIALOG_OK_BUTTON))
    else
        wait_for {displayed?(element)}
        sleep(2)
        click_on(element)
    end


    if verifiable.include? button
      puts "#{button} Button is in verifiable"
      verify_tile(element)
    end
  end

  def undo
    click_on(UNDO_BUTTON)
  end

  def redo
    click_on(REDO_BUTTON)
  end

  def click_toolshelf #TODO does not work
    #@codap_base.click_on(TOOLSHELF_BACK)
  end

  def add_attribute_to_graph(source_element, target_element)
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
      when 'plot view'
        target_loc = find(GRAPH_PLOT_VIEW)
    end
    @@driver.action.drag_and_drop(source_loc, target_loc).perform
  end

  def goto_table
    click_on(CASE_TABLE)
  end

  def select_menu_item(menu_item_text)
    puts 'in select_menu_item'
    menu_item = {xpath: "//div/a[contains(@class,'menu-item')]/span[contains(text(),'#{menu_item_text}')]"}
    puts "Menu item is #{menu_item}"
    # wait_for {displayed? (menu_item)}
    click_on(menu_item)
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
    puts "In verify tile"
    case (button)
      when TABLE_BUTTON
        puts "visible? #{displayed?(CASE_TABLE_TILE)}"
        if !(displayed?(CASE_TABLE_TILE))
          puts "not visible"
        end
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
        puts "Help button clicked."
        select_menu_item("Help")
        sleep(3)
        tab_handle = switch_to_last_tab
        sleep(1)
        url = get_url
        if(url.include? "help")
          puts"Went to help site"
        else
          puts "went to wrong site"
        end
        close_tab(tab_handle)
        switch_to_first_tab
        sleep(2)
      when TILE_LIST_BUTTON
        wait_for {displayed? (CASE_TABLE_TILE)} #Assumes that the first tile in the list is the first table created
        sleep(3)
      when DISPLAY_WEBSITE
        puts "visible? #{displayed?(DISPLAY_WEBSITE)}"
          webview = find(LEARN_WEBVIEW) #Assumes that the website entered is of Learn Portal
          sleep(5)
          switch_to_iframe(webview)
          wait_for {displayed? (CONCORD_LOGO)}
          if displayed? (CONCORD_LOGO)
            puts "Found Concord Logo"
          end
          switch_to_main
      when GUIDE_BUTTON
        puts "Guide button clicked"
      when OPEN_CODAP_WEBSITE
        puts "verify CODAP website presence"
        sleep(1)
        tab_handle=switch_to_last_tab
        url = get_url
        if(url.include? "codap")
          puts"Went to codap site"
        else
          puts "went to wrong site"
        end
        close_tab(tab_handle)
        switch_to_first_tab
      when PLUGIN_SAMPLER_MENU_ITEM
        puts "sampler verification"
        webview = find(SAMPLER_WEBVIEW)
        sleep(3)
        switch_to_iframe(webview)
        wait_for {displayed? (Sam)}
      when PLUGIN_DRAW_TOOL_MENU_ITEN
        puts "draw tool verification"
        webview = find(DRAW_TOOL_WEBVIEW)
        sleep(3)
        switch_to_iframe(webview)
        wait_for {displayed? (DRAW_TOOL_PALETTE)}
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

  def close_component(locator)
    puts "In close_component"
    @@driver.action.move_to(locator).move_by(137,0).click.perform
  end

  def open_new_table
    puts "In open new table"
    click_on(TABLE_BUTTON)
    click_on(NEW_TABLE)
    verify_tile('table')
  end

  def display_website
    puts "in display website"
    click_on(OPTION_BUTTON)
    element = DISPLAY_WEBSITE
    menu_item = find(element)
    menu_item.click
  end

  def open_plugin(plugin)
    puts "In open plugin"
    click_on(PLUGIN_BUTTON)
    case (plugin)
      when 'sampler'
        click_on(PLUGIN_SAMPLER)
      when 'draw tool'
        click_on(PLUGIN_DRAW_TOOL)

    end
  end
end


