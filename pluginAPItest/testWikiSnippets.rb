require './plugin_api_object'
require 'json'
require 'execjs'

dir="#{Dir.home}/development/codap-selenium-tests/"
filename = "api-responses"

wiki_url = 'https://github.com/concord-consortium/codap/wiki/CODAP-Data-Interactive-API'

CODE_SNIPPETS = {tag_name: 'pre'}

codap_url = "https://codap.concord.org/releases/staging/static/dg/en/cert/index.html?di=https://concord-consortium.github.io/codap-data-interactives/DataInteractiveAPITester/"

IFRAME ={tag_name: 'iframe'}

def getCodeSnippets(snippets)
  messages_create=Array.new
  messages_get=[]
  messages_update=[]
  messages_delete=[]
  messages_notify=[]

  snippets.each do |snippet|
    snippet_text=snippet.text
    if snippet_text.include? 'action:'
      snippet_text.gsub! "\n",""
      snippet_text.gsub! /\/\*(.*)\*\//,""
      message = ExecJS.eval "JSON.stringify(#{snippet_text})"
      if message.include? '"create"'
        messages_create << message + ','
      elsif message.include? '"get"'
        messages_get.push(message + ',')
      elsif message.include? '"update"'
        messages_update.push(message + ',')
      elsif message.include? '"delete"'
        messages_delete.push(message + ',')
      elsif message.include? '"notify"'
        messages_notify.push(message + ',')
      end
    end
  end
  puts messages_create.length
  puts messages_get.length
  puts messages_update.length
  puts messages_delete.length
  puts messages_notify.length

  messages = [messages_create, messages_get, messages_update, messages_delete, messages_notify]
  return messages
end

apiTester = PluginAPIObject.new()
apiTester.setup_one(:chrome)
apiTester.visit(wiki_url)
snippets = apiTester.find_all(CODE_SNIPPETS)
messages = getCodeSnippets(snippets)
create = messages[0]
get = messages[1]
update = messages[2]
delete = messages[3]

apiTester.visit(codap_url)
apiTester.wait_for{apiTester.displayed? (IFRAME) }
plugin = apiTester.find(IFRAME)
apiTester.switch_to_iframe(plugin)

create.each do |message|
  message = message.chomp(',')
    apiTester.sendRequest(message)
    response = apiTester.checkResponse()
    apiTester.write_to_file(dir,filename,response)
end
get.each do |message|
  puts message
  message = message.chomp(',')
  apiTester.sendRequest(message)
  response = apiTester.checkResponse()
  apiTester.write_to_file(dir,filename,response)
end
update.each do |message|
  message = message.chomp(',')
  apiTester.sendRequest(message)
  response = apiTester.checkResponse()
  apiTester.write_to_file(dir,filename,response)
end
get.each do |message|
  message = message.chomp(',')
  apiTester.sendRequest(message)
  response = apiTester.checkResponse()
  apiTester.write_to_file(dir,filename,response)
end
delete.each do |message|
  message = message.chomp(',')
  apiTester.sendRequest(message)
  response = apiTester.checkResponse()
  apiTester.write_to_file(dir,filename,response)
end
get.each do |message|
  message = message.chomp(',')
  apiTester.sendRequest(message)
  response = apiTester.checkResponse()
  apiTester.write_to_file(dir,filename,response)
end
