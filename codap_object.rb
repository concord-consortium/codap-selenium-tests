class CODAPObject

  SPLASHSCREEN = {css: '.focus'}
  DATA_INTERACTIVE = { css: 'iframe'    }
  DOC_TITLE = {css: '.doc-title'}
  FILE_MENU = { css: '.nav-popup-button'    }
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
  HELP_BUTTON = {css: '.moonicon-icon-help'}
  CASE_TABLE_TILE = {css: '.dg-case-table'}
  GRAPH_TILE = {css: '.graph-view'}
  MAP_TILE = {css: '.leaflet-container'}
  SLIDER_TILE = {css: '.slider-thumb'}
  CALC_TILE = {css: '.calculator'}
  OPEN_NEW_BUTTON = {id: 'dg-user-entry-new-doc-button'}
  OPEN_EXAMPLE_BUTTON = {id: 'dg-user-entry-example-button'}
  OPEN_FILE_BUTTON = {id: 'dg-user-entry-open-local-button'}
  USER_ENTRY_OK_BUTTON= {css: '.dg-ok-new-doc-button'}
  USER_ENTRY_EXAMPLE_OK_BUTTON = {css: '.dg-example-ok-button'}
  EXAMPLE_FILENAME_LIST  = {css: '.dg-example-name'}
  MARKOV_SAMPLE_DOC = {xpath: '//div[contains(@class, "dg-example-name") and text()="Markov Game"]'}
  MARKOV_DOC_TITLE = {xpath: '//div[contains(@class, "doc-title" and text() = "Markov Sample"'}


  attr_reader :driver

  def initialize(driver)
    @driver = driver
    visit
    verify_page
    dismiss_splashscreen
    #start_new_doc
  end

  def visit
    driver.get ENV['base_url']
  end

  def start_new_doc
    puts "In start_new_doc"
    wait_for { displayed?(OPEN_NEW_BUTTON) }
    driver.find_element(OPEN_NEW_BUTTON).click
    wait_for { displayed?(USER_ENTRY_OK_BUTTON) }
    driver.find_element(USER_ENTRY_OK_BUTTON).click
    #dismissed? verify_dismiss of user entry
  end

  def open_markov_example_doc
    puts "In open_example_doc"
    wait_for { displayed?(OPEN_EXAMPLE_BUTTON) }
    driver.find_element(OPEN_EXAMPLE_BUTTON).click
    wait_for { displayed?(EXAMPLE_FILENAME_LIST) }
    #driver.find_element(EXAMPLE_FILENAME_LIST).select_by(:text, 'Markov Game')
    select_menu_item(EXAMPLE_FILENAME_LIST, MARKOV_SAMPLE_DOC)
    driver.find_element(USER_ENTRY_EXAMPLE_OK_BUTTON).click
    #wait_for { displayed? (MARKOV_DOC_TITLE)}
    #dismissed? verify_dismiss of user entry
  end

  def click_table_button
    driver.find_element(TABLE_BUTTON).click
    verify_tile(TABLE_BUTTON)
  end

  def click_graph_button
    driver.find_element(GRAPH_BUTTON).click
    verify_tile(GRAPH_BUTTON)
  end

  def click_map_button
    driver.find_element(MAP_BUTTON).click
    verify_tile(MAP_BUTTON)
  end

  def click_slider_button
    driver.find_element(SLIDER_BUTTON).click
    verify_tile(SLIDER_BUTTON)
  end

  def click_calc_button
    driver.find_element(CALC_BUTTON).click
    verify_tile(CALC_BUTTON)
  end

  def click_text_button
    driver.find_element(TEXT_BUTTON).click
    verify_tile(TEXT_BUTTON)
  end

  def click_tilelist_button
    driver.find_element(TILE_LIST_BUTTON).click
    verify_tile(TILE_LIST_BUTTON)
  end

  def click_option_button
    driver.find_element(OPTION_BUTTON).click
    verify_tile(OPTION_BUTTON)
  end

  def click_guide_button
    driver.find_element(GUIDE_BUTTON).click
    verify_tile(GUIDE_BUTTON)
  end

  private
  def verify_page
    expect(driver.title).to eql('Untitled Document - CODAP')
  end

  def verify_tile(button)
    case (button)
      when TABLE_BUTTON
        puts "Table button clicked"
      #wait_for { displayed?(CASE_TABLE_TILE) }
      when GRAPH_TILE
        wait_for { displayed?(GRAPH_TILE) }
      when MAP_BUTTON
        wait_for { displayed?(MAP_TILE) }
      when SLIDER_BUTTON
        wait_for { displayed?(SLIDER_TILE) }
      when CALC_BUTTON
        wait_for { displayed?(CALC_TILE) }
      when TEXT_BUTTON
        puts "Text button clicked"
      when TILE_LIST_BUTTON
        puts "Tile list button clicked"
      when OPTION_BUTTON
        puts "Option button clicked"
      when GUIDE_BUTTON
        puts "Guide button clicked"
    end
  end

  def dismiss_splashscreen
    if driver.find_element(SPLASHSCREEN) #Dismisses the splashscreen if present
      driver.find_element(SPLASHSCREEN).click
    end
  end

  def switch_to_dialog
    user_entry_dialog = driver.find_element(USER_ENTRY_DIALOG)
    driver.switch_to.alert(user_entry_dialog)
  end

  def wait_for(seconds=15)
    Selenium::WebDriver::Wait.new(:timeout => seconds).until { yield }
  end

  def select_menu_item(menu, menu_item)
    puts 'in select_menu_item'
    driver.find_element(menu)
    found = driver.find_element(menu_item)
    puts "found is #{found}"
    found.click
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
