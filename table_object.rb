module TableObject

  CASE_TABLE = {css: '.dg-case-table'}
  CASE_TABLE_TILE = {css: '.dg-case-table-title'}
  ATTRIBUTE_NAME = {css: '.slick-header-column'}
  TABLE_TRASH = {css:  '.table-trash'}
  TABLE_DROP_TARGET = {css: '.dg-table-drop-target'}
  TABLE_ATTRIBUTES = {css: '.table-attributes'} #Tool palette icon for creating new attributes and export cases
  TABLE_ATTRIBUTES_MENU = {css:  '.attributes-popup'}
  TABLE_SELECT_ALL = {css: '.sc-menu-item > a:nth-child(1) > span:nth-child(1)'}
  # TABLE__DELETE_SELECTED
  # TABLE_DELETE_UNSELECTED
  # TABLE_DELETE_ALL_CASES

  # Need to add menu items for trash and attributes menu

  def get_column_header(header_name)
    header_name_path = '//span[contains(@class, "slick-column-name") and text()="'+header_name+'"]'
    column_header_name = {xpath: header_name_path}
    column_header_name_loc = find(column_header_name)
    move_to(column_header_name_loc)
    puts "Column header name is #{column_header_name_loc.text}"
    return column_header_name_loc
  end

end