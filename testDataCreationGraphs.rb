require './codap_object'
require './pluginAPItest/plugin_api_object'
require 'csv'

expected_screenshots_dir = "#{Dir.home}/Sites/data_creation_graphs_results/expected_screenshots/"
staging_screenshots_dir = "#{Dir.home}/Sites/data_creation_graphs_results/test_screenshots/"
url = "https://codap.concord.org/releases/staging/?di=https://concord-consortium.github.io/codap-data-interactives//DataInteractiveAPITester/index.html"
data_filename = "./SmokeTestData.csv"

PLUGIN_API_TESTER_FRAME = {xpath: '//iframe[contains(@src,"DataInteractiveAPITester")]'}


def getData(filename)
  data = CSV.read(filename)
  # puts "data is #{data}"
  return data
end

#Data Interactive API calls
#Create data context
def create_data_context(plugin, context_name)
  puts "in create data context"
  message = "{
    'action': 'create',
    'resource': 'dataContext',
    'values': {
    'name': '#{context_name}',
    'title': '#{context_name}',
    'description': 'Test data with different types'
}
}"
  json_message = message.gsub(/[']/,'"') #JSON needs to be in double quotes
  puts "message is: #{json_message}"
  plugin.sendMessage(json_message)
  plugin.checkResponse
end

# #Create Collection with Attributes
def create_collection_with_attributes(plugin, data, context_name)
  puts "In create collection with attributes"
  i=0
  attributes = data[0] #assumes first line of csv file has the attribute names
  types = data[1] #assumes second line of csv file has the type of the attribute
  message = "{
       'action': 'create',
       'resource': 'dataContext[#{context_name}].collection',
       'values': {
         'name': '#{context_name}',
         'attributes': []}}"

  while i < attributes.length
    if i==0 #check if it is the the first attribute so don't add comma before hash
      attribute_to_add = "{'name': '#{attributes[i]}',
                          'type': '#{types[i]}' }"
    else
      attribute_to_add = ",
                         {'name': '#{attributes[i]}',
                          'type': '#{types[i]}' }"
    end
    json_message = message.insert(-4, attribute_to_add) #adds to the third character in from the end. In this case it will concat it to just prior the last square bracket
    i=i+1
  end
  json_message = json_message.gsub(/[']/,'"') #JSON needs to be in double quotes
  puts "collection with attribute message is: #{json_message}"
  plugin.sendMessage(json_message)
  plugin.checkResponse
end

def create_graph(plugin, context_name, graph_name,y_attr='',x_attr='',legend_attr='',y2_attr='')
  puts "In create_graphs"
  message = "{
      'action': 'create',
      'resource': 'component',
      'values': {
            'type': 'graph',
            'name': '#{graph_name}',
            'dimensions': {
                'width': 220,
                'height': 220
            },
            'position': 'top',
            'dataContext': '#{context_name}',
            'yAttributeName': '#{y_attr}',
            'xAttributeName': '#{x_attr}',
            'legendAttributeName':'#{legend_attr}',
            'y2AttributeName':'#{y2_attr}'
      }}"

  json_message = message.gsub(/[']/,'"') #JSON needs to be in double quotes
  puts "collection with attribute message is: #{json_message}"
  plugin.sendMessage(json_message)
  plugin.checkResponse
end
# graph_types =[{graph name, y-axis attr, x-axis attr, legend attr, y2-axis attr}] all elements in string
graph_types = [{'Cat Legend','','','Eyes',''},
               {'Cat X','','YesNo','',''},
               {'Cat Y','YesNo','','',''},
               {'Num X','','Weight','',''},
               {'Num Y','Height','','',''},
               {'Num X Num Y Num Legend','Height','Weight','Sample',''},
               {'Cat X Cat Y Num Legend','NumCat','Eyes','Sample',''},
               {'Cat X Cat Y Cat Legend','Eyes','NumCat','WinLose',''},
               {'Num X Num Y Cat Legend','Height','Weight','Eyes',''},
               {'Num X Cat Y','Sample','Eyes','',''},
               {'Cat X Num Y','Weight','Eyes','',''},
               {'Num X 2Num Y','Height','Sample','','Weight'},
]


data_context = "SmokeTestData"
data_file = getData(data_filename)
# puts "data file is #{data_file}"

codap = CODAPObject.new()
plugin = PluginAPIObject.new()

codap.setup_one(:chrome)

codap.visit(url)
sleep(2)
codap.switch_to_iframe(PLUGIN_API_TESTER_FRAME)
create_data_context(plugin, data_context)
create_collection_with_attributes(plugin, data_file, data_context)

create_graph(plugin, data_context,"num_x cat_legend","","Height","Eyes")
sleep(3)



# #Create Graphs, cannot string them
# {
#     "action": "create",
#     "resource": "component",
#     "values": {
#                "type": "graph",
#                "name": "Cat Legend",
#                "dimensions": {
#                               "width": 210,
#                               "height": 210
#                              },
#                "position": "top",
#                "dataContext": "SmokeTestData",
#                "legendAttributeName": "YesNo"
#               }
# }
#     {
#         "action": "create",
#     "resource": "component",
#     "values": {
#     "type": "graph",
#     "name": "Cat x",
#     "dimensions": {
#     "width": 210,
#     "height": 210
# },
#     "position": "top",
#     "dataContext": "SmokeTestData",
#     "xAttributeName": "YesNo"
# }
# }
# {
#     "action": "create",
#     "resource": "component",
#     "values": {
#     "type": "graph",
#     "name": "Cat y",
#     "dimensions": {
#     "width": 200,
#     "height": 200
# },
#     "position": "top",
#     "dataContext": "SmokeTestData",
#     "yAttributeName": "WinLose"
# }
# }
# {
#     "action": "create",
#     "resource": "component",
#     "values": {
#     "type": "graph",
#     "name": "Num x",
#     "dimensions": {
#     "width": 200,
#     "height": 200
# },
#     "position": "top",
#     "dataContext": "SmokeTestData",
#     "xAttributeName": "Weight"
# }
# {
#     "action": "create",
#     "resource": "component",
#     "values": {
#     "type": "graph",
#     "name": "Num y",
#     "dimensions": {
#     "width": 200,
#     "height": 200
# },
#     "position": "top",
#     "dataContext": "SmokeTestData",
#     "yAttributeName": "Height"
# }
# }
# {
#     "action": "create",
#     "resource": "component",
#     "values": {
#     "type": "graph",
#     "name": "Num xy",
#     "dimensions": {
#     "width": 200,
#     "height": 200
# },
#     "position": "top",
#     "dataContext": "SmokeTestData",
#     "yAttributeName": "Height",
#     "xAttributeName": "Weight",
#     "legendAttributeName":"Sample"
# }
# }
# {
#     "action": "create",
#     "resource": "component",
#     "values": {
#     "type": "graph",
#     "name": "Cat xy",
#     "dimensions": {
#     "width": 200,
#     "height": 200
# },
#     "position": "top",
#     "dataContext": "SmokeTestData",
#     "yAttributeName": "WinLose",
#     "xAttributeName": "YesNo",
#     "legendAttributeName":"Sample"
# }
# }
# {
#     "action": "create",
#     "resource": "component",
#     "values": {
#     "type": "graph",
#     "name": "Num x Cat y",
#     "dimensions": {
#     "width": 200,
#     "height": 200
# },
#     "position": "top",
#     "dataContext": "SmokeTestData",
#     "yAttributeName": "WinLose",
#     "xAttributeName": "Weight",
#     "legendAttributeName":"Sample"
# }
# }
# {
#     "action": "create",
#     "resource": "component",
#     "values": {
#     "type": "graph",
#     "name": "Num xy Cat legend",
#     "dimensions": {
#     "width": 200,
#     "height": 200
# },
#     "position": "top",
#     "dataContext": "SmokeTestData",
#     "yAttributeName": "Height",
#     "xAttributeName": "Weight",
#     "legendAttributeName":"WinLose"
# }
# }
# {
#     "action": "create",
#     "resource": "component",
#     "values": {
#     "type": "graph",
#     "name": "NumCat x Cat y Cat legend",
#     "dimensions": {
#     "width": 200,
#     "height": 200
# },
#     "position": "top",
#     "dataContext": "SmokeTestData",
#     "yAttributeName": "Height",
#     "xAttributeName": "NumCat",
#     "legendAttributeName":"Eyes"
# }
# }
# #Add data
# {
#     "action": "create",
#     "resource": "dataContext[SmokeTestData].item",
#     "values": [
#     {
#         "Sample": "1",
#     "YesNo": "yes",
#     "WinLose": "win",
#     "Height": "57",
#     "Weight": "115",
#     "Width": "11",
#     "Eyes": "blue",
#     "NumCat":"3"
# }
# ]
# }
