require '~/development/codap-selenium-tests/base_object.rb'

class PluginAPIObject< CodapBaseObject
  RESOURCE_ITEMS = {css: '.di-resources-type-list>.di-item'}
  ACTION_ITEMS = {css: '.di-action-list>.di-item'}
  MESSAGE_AREA = {css: '.di-message-area'}
  SEND_BUTTON = {css: '.di-send-button'}
  RESPONSE_AREA = {id: 'message-log'}
  SENT_MESSAGE_NUM = {id: 'sentMessages'}
  SUCCESS_NUM = {id: 'success'}

  def intialize()
    puts "Initializing"
  end

  def sendRequest(resource, action, message)
    puts "in sendRequest"

    resource_elements = find_all(RESOURCE_ITEMS)
    action_elements = find_all(ACTION_ITEMS)

    resource_elements.each do |resource_item|
      if resource == resource_item.text
        resource_item.click
      end
    end

    action_elements.each do |action_item|
      if action == action_item.text
        action_item.click
      end
    end

    clear(MESSAGE_AREA)
    type(MESSAGE_AREA,message)

    click_on(SEND_BUTTON)
  end

  def checkResponse
    puts "in checkResponse"
    puts text_of(RESPONSE_AREA)
    puts text_of(SENT_MESSAGE_NUM)
    puts text_of(SUCCESS_NUM)
  end
end