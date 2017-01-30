require './plugin_api_object'

######
# This test will create:
# 1 Data Context
# 1 Collection
# 3 Attributes
# 5 Cases
# Components: Table, Graph, Map, Calculator, Text, Slider
######
IFRAME ={tag_name: 'iframe'}

url = "https://codap.concord.org/releases/staging/static/dg/en/cert/index.html?di=https://concord-consortium.github.io/codap-data-interactives/DataInteractiveAPITester/"

def actionDataContext(action, context_name=nil)
  puts "in actionDataContext"
  case action
    when "create"
      message = '{ "action": "' + action + '",
      "resource": "dataContext",
      "values": {
        "name": "' + context_name +'",
        "title": "Title: ' +  context_name + '",
        "description": "Description: ' +  context_name +'"
      }
    }'

    when "get"
      message = '{
          "action": "get",
          "resource": "dataContextList"
      }'
  end

  return message
end

def createCollection

end

def createAttribute

end

def createCase

end

def createComponent(component)

end

apiTester = PluginAPIObject.new()
apiTester.setup_one(:chrome)
apiTester.visit(url)
plugin = apiTester.find(IFRAME)
apiTester.switch_to_iframe(plugin)


message = actionDataContext("create", "Continents")
apiTester.sendRequest("dataContext", "create", message)
apiTester.checkResponse()
message = actionDataContext("get")
apiTester.sendRequest("dataContext","get",message)
apiTester.checkResponse()
