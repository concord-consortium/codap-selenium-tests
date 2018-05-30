require './codap_object'
require './pluginAPItest/plugin_api_object'
require 'csv'

$expected_screenshots_dir = "#{Dir.home}/Sites/data_creation_graphs_results/expected_screenshots/"
$test_screenshots_dir = "#{Dir.home}/Sites/data_creation_graphs_results/test_screenshots/"
url = "https://codap.concord.org/releases/staging/?di=https://concord-consortium.github.io/codap-data-interactives//DataInteractiveAPITester/index.html"
data_filename = "./SmokeTestData.csv"

`rm -rf #{$test_screenshots_dir}`
`mkdir -p #{$test_screenshots_dir}`

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
  # puts "message is: #{json_message}"
  plugin.sendMessage(json_message)
  plugin.checkResponse
end

# #Create Collection with Attributes
def create_collection_with_attributes(plugin, attributes, types, context_name)
  puts "In create collection with attributes"
  i=0

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
  # puts "collection with attribute message is: #{json_message}"
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

  puts "message is: #{message}"
  json_message = message.gsub(/[']/,'"') #JSON needs to be in double quotes
  json_message = json_message.gsub('"[','[')
  json_message = json_message.gsub(']"',']')
  # puts "collection with attribute message is: #{json_message}"
  plugin.sendMessage(json_message)
  plugin.checkResponse
end

# Add data by item
def add_data_by_item(plugin, context_name, item )

  message = "{
      'action': 'create',
      'resource': 'dataContext[#{context_name}].item',
      'values': [
      {
      'Sample': '#{item[0]}',
      'YesNo': '#{item[1]}',
      'WinLose': '#{item[2]}',
      'Height': '#{item[3]}',
      'Weight': '#{item[4]}',
      'Width': '#{item[5]}',
      'Eyes': '#{item[6]}',
      'NumCat':'#{item[7]}'
  }]}"
  json_message = message.gsub(/[']/,'"') #JSON needs to be in double quotes
  # puts "collection with attribute message is: #{json_message}"
  plugin.sendMessage(json_message)
  plugin.checkResponse
end

# Add data by case
def add_data_by_case(plugin, context_name, item )

  message = "{
    'action': 'create',
    'resource': 'dataContext[#{context_name}].collection[#{context_name}].case',
    'values': [
    {
        'values': {
          'Sample': '#{item[0]}',
          'YesNo': '#{item[1]}',
          'WinLose': '#{item[2]}',
          'Height': '#{item[3]}',
          'Weight': '#{item[4]}',
          'Width': '#{item[5]}',
          'Eyes': '#{item[6]}',
          'NumCat':'#{item[7]}'
         }}]}"

  json_message = message.gsub(/[']/,'"') #JSON needs to be in double quotes
  # puts "collection with attribute message is: #{json_message}"
  plugin.sendMessage(json_message)
  plugin.checkResponse
end

def graph_test_by_item(url, data_context, data_file, attributes, types, graph_types)
  codap = CODAPObject.new()
  plugin = PluginAPIObject.new()
  codap.setup_one(:firefox)
  codap.visit(url)
  sleep(10)
  plugin_iframe = codap.find(PLUGIN_API_TESTER_FRAME)
  codap.switch_to_iframe(plugin_iframe)
  create_data_context(plugin, data_context)
  sleep(2)
  create_collection_with_attributes(plugin, attributes, types, data_context)

  graph_types.each do |hash|
    create_graph(plugin, data_context, hash[:name],hash[:y_attr],hash[:x_attr],hash[:legend_attr],hash[:y2_attr])
    sleep(0.5)
  end
  data_rows = data_file.drop(2)

  count=1
  data_rows.each do |item|
    add_data_by_item(plugin,data_context, item)
    if count==1 || count==(data_rows.length)/2 || count==(data_rows.length)
      codap.save_screenshot($test_screenshots_dir,"item_screenshot_#{count}")
    end
    count=count+1
  end
end

def graph_test_by_case(url, data_context, data_file, attributes, types, graph_types)
  codap = CODAPObject.new()
  plugin = PluginAPIObject.new()
  codap.setup_one(:firefox)
  codap.visit(url)
  sleep(10)
  plugin_iframe = codap.find(PLUGIN_API_TESTER_FRAME)
  codap.switch_to_iframe(plugin_iframe)
  sleep(2)
  create_data_context(plugin, data_context)
  sleep(2)
  create_collection_with_attributes(plugin, attributes, types, data_context)

  graph_types.each do |hash|
    create_graph(plugin, data_context, hash[:name],hash[:y_attr],hash[:x_attr],hash[:legend_attr],hash[:y2_attr])
    sleep(0.5)
  end
  data_rows = data_file.drop(2)

  count=1 #keeps track of how many data points have been added to know when to take screenshots
  data_rows.each do |item|
    add_data_by_case(plugin,data_context, item)
    if count==1 || count==(data_rows.length)/2 || count==(data_rows.length)
      codap.save_screenshot($test_screenshots_dir,"case_screenshot_#{count}")
    end
    count=count+1
  end
end


# graph_types =[{graph name, y-axis attr, x-axis attr, legend attr, y2-axis attr}] all elements in string
graph_types = [{:name=>'Cat Legend', :y_attr=>'',:x_attr=>'',:legend_attr=>'Eyes',:y2_attr=>''},
               {:name=>'Cat X',:y_attr=>'',:x_attr=>'YesNo',:legend_attr=>'',:y2_attr=>''},
               {:name=>'Cat Y',:y_attr=>'YesNo',:x_attr=>'',:legend_attr=>'',:y2_attr=>''},
               {:name=>'Num X',:y_attr=>'',:x_attr=>'Weight',:legend_attr=>'',:y2_attr=>''},
               {:name=>'Num Y',:y_attr=>'Height',:x_attr=>'',:legend_attr=>'',:y2_attr=>''},
               {:name=>'Num X Num Y Num Legend',:y_attr=>'Height',:x_attr=>'Weight',:legend_attr=>'Sample',:y2_attr=>''},
               {:name=>'Cat X Cat Y Num Legend',:y_attr=>'NumCat',:x_attr=>'Eyes',:legend_attr=>'Sample',:y2_attr=>''},
               {:name=>'Cat X Cat Y Cat Legend',:y_attr=>'Eyes',:x_attr=>'NumCat',:legend_attr=>'WinLose',:y2_attr=>''},
               {:name=>'Num X Num Y Cat Legend',:y_attr=>'Height',:x_attr=>'Weight',:legend_attr=>'Eyes',:y2_attr=>''},
               {:name=>'Num X Cat Y',:y_attr=>'Sample',:x_attr=>'Eyes',:legend_attr=>'',:y2_attr=>''},
               {:name=>'Cat X Num Y',:y_attr=>'Weight',:x_attr=>'Eyes',:legend_attr=>'',:y2_attr=>''},
               {:name=>'Num X Num YR',:y_attr=>'Height',:x_attr=>'Sample',:legend_attr=>'',:y2_attr=>'Weight'},
               {:name=>'Num X 2Num Y',:y_attr=>'[\'Height\',\'Weight\']',:x_attr=>'Sample',:legend_attr=>'',:y2_attr=>''}
]

data_context = "SmokeTestData"
data_file = getData(data_filename)
# puts "data file is #{data_file}"
attributes = data_file[0] #assumes first line of csv file has the attribute names
types = data_file[1] #assumes second line of csv file has the type of the attribute

begin
  attempt = 0
  max_attempts = 5

  graph_test_by_item(url, data_context,data_file, attributes, types, graph_types)
rescue => e
  puts '::ERROR::'
  puts e
  attempt +=1
  if attempt< max_attempts
    puts "RETRYING (#{attempt})..."
    retry
  end
end

begin
  attempt = 0
  max_attempts = 5

graph_test_by_case(url, data_context,data_file, attributes, types, graph_types)
rescue => e
  puts '::ERROR::'
  puts e
  attempt +=1
  if attempt< max_attempts
    puts "RETRYING (#{attempt})..."
    retry
  end
end

sleep(3)
