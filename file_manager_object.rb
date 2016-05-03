class File_Manager_Object
  OPEN_NEW_BUTTON = {id: 'dg-user-entry-new-doc-button'}
  OPEN_EXAMPLE_BUTTON = {id: 'dg-user-entry-example-button'}
  OPEN_LOCAL_DOC_BUTTON = {id: 'dg-user-entry-open-local-doc-button'}
  USER_ENTRY_OK_BUTTON= {css: '.dg-ok-new-doc-button'}
  USER_ENTRY_EXAMPLE_OK_BUTTON = {css: '.dg-example-ok-button'}
  EXAMPLE_FILENAME_LIST  = {css: '.dg-example-name'}
  OPEN_LOCAL_DOC_SELECT = {xpath: '//div[contains(@class, "dg-file-import-view")]/div/input[contains(@class, "field")]'}#= {css: '.dg-file-import-view'}
  USER_ENTRY_OPEN_LOCAL_OK = {css: '.dg-ok-open-local-button'}
  LOCAL_FILE_SELECT = {css: '.dg-file-import-view, .not-empty'}
  FILE_MENU_OPEN_DOC = {id: 'dg-fileMenutItem-open-doc'}

  def select_file_menu_open_doc
    wait_for {displayed?(FILE_MENU_OPEN_DOC)}
    driver.find_element(FILE_MENU_OPEN_DOC).click
  end

  def start_new_doc
    puts "In start_new_doc"
    wait_for { displayed?(OPEN_NEW_BUTTON) }
    driver.find_element(OPEN_NEW_BUTTON).click
    wait_for { displayed?(USER_ENTRY_OK_BUTTON) }
    driver.find_element(USER_ENTRY_OK_BUTTON).click
    #dismissed? verify_dismiss of user entry
  end

  def open_sample_doc(sample_doc_name)
    doc_path = '//div[contains(@class, "dg-example-name") and text()="'+sample_doc_name+'"]'
    sample_doc = {xpath: doc_path}
    puts "In open_example_doc"
    wait_for { displayed?(OPEN_EXAMPLE_BUTTON) }
    driver.find_element(OPEN_EXAMPLE_BUTTON).click
    puts "clicked example button"
    wait_for { displayed?(EXAMPLE_FILENAME_LIST) }
    select_menu_item(EXAMPLE_FILENAME_LIST, sample_doc)
    driver.find_element(USER_ENTRY_EXAMPLE_OK_BUTTON).click
    #dismissed? verify_dismiss of user entry
  end

  def open_local_doc(doc_name)
    puts "In open_local_doc"
    wait_for { displayed?(OPEN_LOCAL_DOC_BUTTON)}
    driver.find_element(OPEN_LOCAL_DOC_BUTTON).click
    puts "clicked open local doc. doc name is #{doc_name}"
    wait_for { displayed?(OPEN_LOCAL_DOC_SELECT)}
    driver.find_element(OPEN_LOCAL_DOC_SELECT).send_keys doc_name
    wait_for {displayed? (LOCAL_FILE_SELECT)}
    wait_for {displayed? (USER_ENTRY_OPEN_LOCAL_OK)}
    driver.find_element(USER_ENTRY_OPEN_LOCAL_OK).click
  end

  def verify_doc(opened_doc)
    puts "open_doc is #{opened_doc}"
    doc_title = driver.find_element(DOC_TITLE)
    puts "Doc title is #{doc_title.text} opened_doc is #{opened_doc}"
    wait_for {doc_title.text == opened_doc}
    #expect(doc_title.text).to eql opened_doc
  end

end