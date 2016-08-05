module TableObject

  CASE_TABLE = {css: '.dg-case-table'}
  CASE_TABLE_TILE = {css: '.dg-case-table-title'}
  ATTRIBUTE_NAME = {css: '.slick-header-column'}
  TABLE_TRASH = {css:  '.table-trash'}
  TABLE_DROP_TARGET = {css: '.dg-table-drop-target'}
  TABLE_ATTRIBUTES = {css: '.inspector-palette> .table-attributes'} #Tool palette icon for creating new attributes and export cases
  TABLE_ATTRIBUTES_MENU = {css:  '.attributes-popup'}
  TABLE_SELECT_ALL = {css: '.sc-menu-item > a:nth-child(1) > span:nth-child(1)'}
  # TABLE__DELETE_SELECTED
  # TABLE_DELETE_UNSELECTED
  # TABLE_DELETE_ALL_CASES
  TABLE_NEW_ATTRIBUTE = {xpath: '//a/span[contains(.,"New Attribute")]' }

  # New attribute dialog box
  NEW_ATTRIBUTE_NAME = {tag_name: 'input'}
  NEW_ATTRIBUTE_APPLY_BUTTON = {xpath: '//div[contains(@class,"button")]/label[contains(.,"Apply")]'}
  NEW_ATTRIBUTE_FORMULA = {css: '.field.ui-autocomplete-input'}

  # Need to add menu items for trash and attributes menu

  # {xpath: '//button[contains(.,"Authorize")]'}
  # //*[@id="sc4108"]/div[2]/input


  def get_column_header(header_name)
    header_name_path = '//span[contains(@class, "slick-column-name") and text()="'+header_name+'"]'
    column_header_name = {xpath: header_name_path}
    column_header_name_loc = find(column_header_name)
    move_to(column_header_name_loc)
    puts "Column header name is #{column_header_name_loc.text}"
    return column_header_name_loc
  end

  def create_new_attribute(new_attribute_name, new_attribute_formula)
    puts "In create_new_attribute"
    wait_for { displayed?(TABLE_ATTRIBUTES)}
    ruler = find(TABLE_ATTRIBUTES)
    sleep(2)
    click_on(TABLE_ATTRIBUTES)
    sleep(2)
    click_on(TABLE_NEW_ATTRIBUTE)
    wait_for{ displayed?(NEW_ATTRIBUTE_NAME) }
    click_on(NEW_ATTRIBUTE_NAME)


    new_attribute_popup = find(NEW_ATTRIBUTE_NAME)
    attribute_formula_textfield = find(NEW_ATTRIBUTE_FORMULA)

    pop_up_click(new_attribute_popup)
    pop_up_type(new_attribute_popup, new_attribute_name)
    pop_up_type(attribute_formula_textfield, new_attribute_formula)
    click_on(NEW_ATTRIBUTE_APPLY_BUTTON)
  end



end