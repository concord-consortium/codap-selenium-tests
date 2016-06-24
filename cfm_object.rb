require './codap_base_object'

class CFMObject
#Open Dialog box locators
  OPEN_EXAMPLE_DOCS = {css: '.workspace-tabs >ul:nth-of-type(1)> li'}#.workspace-tabs>ul>li:contains("Example Documents")
  OPEN_CONCORD_CLOUD = {css: '.workspace-tabs >ul:nth-of-type(2) > li'}
  OPEN_GOOGLE_DRIVE = {css: '.workspace-tabs >ul:nth-of-type(3) > li'}
  OPEN_LOCAL_FILE = {css: '.workspace-tabs >ul:nth-of-type(4) > li'}
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

  attr_reader :driver

  def initialize(driver)
    puts "Initializing CFM Object"
    @driver=driver
    @codap_base = CodapBaseObject.new(driver)
  end

  def click_on(button)

    case (button)
      when 'examples'
        element = OPEN_EXAMPLE_DOCS
      when 'cloud'
        element = OPEN_CONCORD_CLOUD
      when 'google drive'
        element = OPEN_GOOGLE_DRIVE
      when 'local'
        element = OPEN_LOCAL_FILE
      when 'file_menu'
        element = FILE_MENU
      when 'new'
        element = FILE_NEW
      when 'open'
        element = FILE_OPEN
      when 'close'
        element = FILE_CLOSE
      when 'import'
        element = FILE_IMPORT
      when 'revert'
        element = FILE_REVERT
      when 'save'
        element = FILE_SAVE
      when 'copy'
        element = FILE_COPY
      when 'share'
        element = FILE_SHARE
      when 'download'
        element = FILE_DOWNLOAD
      when 'rename'
        element = FILE_RENAME
    end

    puts "button is #{button}, element is #{element}"
    @codap_base.click_on(element)

  end
end