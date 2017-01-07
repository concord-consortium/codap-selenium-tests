module CFMObject
  #User Entry Buttons Locators
  USER_ENTRY_NEW_DOC_BUTTON = {xpath: '//button[contains(.,"Create New Document")]'}
  USER_ENTRY_OPEN_DOC_BUTTON = {xpath: '//button[contains(.,"Open Document")]'}
  USER_ENTRY_AUTHORIZE_DOC_BUTTON = {xpath: '//button[contains(.,"Authorize")]'}

  #Open Dialog box locators
  OPEN_EXAMPLE_DOCS = {css: '.workspace-tabs >ul:nth-of-type(1)> li'}#.workspace-tabs>ul>li:contains("Example Documents")
  OPEN_GOOGLE_DRIVE = {css: '.workspace-tabs >ul:nth-of-type(2) > li'}
  OPEN_LOCAL_FILE = {css: '.workspace-tabs >ul:nth-of-type(3) > li'}
  FILE_SELECTION_DROP_AREA = {css: '.dropArea>input'}
  DOC_STORE_LOGIN = {css: '.document-store-footer'}
  SAVE_CONCORD_CLOUD = {css: '.workspace-tabs > ul:nth-child(1) > li'}
  SAVE_GOOGLE_DRIVE = {css: '.workspace-tabs > ul:nth-child(2) > li'}
  FILE_MENU = { css: '.menu-anchor'}
  FILE_NEW = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(1)'}
  FILE_OPEN = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(2)'}
  FILE_CLOSE = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(3)'}
  FILE_IMPORT = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(4)'}
  FILE_REVERT = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(5)'}
  FILE_SAVE = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(7)'}
  FILE_COPY = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(8)'}
  FILE_SHARE = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(9)'}
  FILE_DOWNLOAD = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(10)'}
  FILE_RENAME = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(11)'}
  OPEN_FILE_LIST = {css: '.selectable'}
  OPEN_FILE_BUTTTONS = {css: '.buttons'}
  OPEN_FILE_OPEN_BUTTON = {xpath: '//button[1]'}

  #Logins
  LOGIN_CONCORD_CLOUD = {CSS: '.document-store-footer> button'}
  # @driver.find_elements(css: '#list > li').select {|el| el.text == 'Orange'}.first


  def in_cfm
    puts "In CFMObject"
  end

  def login_to_concord_cloud
    click_on(LOGIN_CONCORD_CLOUD)

  end

  def user_entry_open_doc
    puts "In user_entry_open_doc"
    wait_for{ displayed?(USER_ENTRY_OPEN_DOC_BUTTON) }
    click_on(USER_ENTRY_OPEN_DOC_BUTTON)
  end

  def user_entry_start_new_doc
    puts "In user_entry_start_new_doc"
    wait_for { displayed?(USER_ENTRY_NEW_DOC_BUTTON) }
    click_on(USER_ENTRY_NEW_DOC_BUTTON)
  end

  def open_sample_doc(filename)
    wait_for{ displayed?(OPEN_EXAMPLE_DOCS) }
    click_on(OPEN_EXAMPLE_DOCS)
    wait_for{ displayed?(OPEN_FILE_LIST)}
    filelist = find_all(OPEN_FILE_LIST)
    sample_doc = filelist.find {|file| file.text == filename}
    sample_doc.click
    click_on(OPEN_FILE_OPEN_BUTTON)
    sleep(5)
  end

  def open_doc_concord_cloud(filename)
    wait_for{ displayed?(OPEN_CONCORD_CLOUD) }
    click_on(OPEN_CONCORD_CLOUD)
    wait_for{ displayed?(OPEN_FILE_LIST)}
    filelist = find_all(OPEN_FILE_LIST)
    sample_doc = filelist.find {|file| file.text == filename}
    sample_doc.click
    click_on(OPEN_FILE_OPEN_BUTTON)
    sleep(5)
  end

  def open_local_doc(filename)
    puts "File name is: #{filename}"
    wait_for{ displayed?(OPEN_LOCAL_FILE)}
    click_on(OPEN_LOCAL_FILE)
    wait_for {displayed?(FILE_SELECTION_DROP_AREA)}
    find(FILE_SELECTION_DROP_AREA).send_keys filename
  end

end