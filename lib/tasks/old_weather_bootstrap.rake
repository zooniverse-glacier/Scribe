task :old_weather_bootstrap => :environment do
  template = Template.create( :name => "Old Weather Royal Navy WWI",
                              :description => "A template definition for Royal Navy WWI logs",
                              :project => "Old Weather",
                              :display_width => 600,
                              :default_zoom => 1.5)
                          
  
  
  weather_entity = Entity.create( :name => "Weather observation",
                                  :description => "",
                                  :help => "Please fill in all of the values",
                                  :resizeable => false,
                                  :width => 450,
                                  :height => 80)
                                  
  
  wind_field = Field.new( :name => "Wind",
                          :field_key => "wind_direction",
                          :kind => "select",
                          :initial_value => "--",
                          :options => { :select => ['North', 'South', 'East', 'West'] })

  force_field = Field.new(:name => "Force",
                          :field_key => "wind_force",
                          :kind => "text",
                          :initial_value => "--",
                          :options => { :text => { :max_length => 2, :min_length => 0 } })

  weather_code_field = Field.new( :name => "Code",
                                  :field_key => "weather_code",
                                  :kind => "text",
                                  :initial_value => "--",
                                  :options => { :text => { :max_length => 10, :min_length => 0 } })
                                  
  height_1_field = Field.new( :name => "Height",
                              :field_key => "height_1",
                              :kind => "text",
                              :initial_value => "--",
                              :options => { :text => { :max_length => 3, :min_length => 0 } })         
                                  
  height_2_field = Field.new( :name => "Height",
                              :field_key => "height_2",
                              :kind => "text",
                              :initial_value => "--",
                              :options => { :text => { :max_length => 3, :min_length => 0 } })      

  air_temperature = Field.new(:name => "Air",
                              :field_key => "air_temperature",
                              :kind => "text",
                              :initial_value => "--",
                              :options => { :text => { :max_length => 3, :min_length => 0 } })                                                          
  
  bulb_temperature = Field.new( :name => "Air",
                                :field_key => "bulb_temperature",
                                :kind => "text",
                                :initial_value => "--",
                                :options => { :text => { :max_length => 3, :min_length => 0 } })                                
                                
  sea_temperature = Field.new(:name => "Air",
                              :field_key => "sea_temperature",
                              :kind => "text",
                              :initial_value => "--",
                              :options => { :text => { :max_length => 3, :min_length => 0 } })                                
                                                   
  weather_entity.fields << wind_field
  weather_entity.fields << force_field
  weather_entity.fields << weather_code_field
  weather_entity.fields << height_1_field
  weather_entity.fields << height_2_field
  weather_entity.fields << air_temperature                              
  weather_entity.fields << bulb_temperature
  weather_entity.fields << sea_temperature
  weather_entity.save

  date_entity = Entity.create(:name => "Date",
                              :description => "",
                              :help => "Please fill in the day, month and year",
                              :resizeable => true,
                              :width => 450,
                              :height => 80)
  
  date_field = Field.new( :name => "Date",
                          :field_key => "date",
                          :kind => "date",
                          :initial_value => "",
                          :options => {})
                          
  date_entity.fields << date_field
  date_entity.save
  
  location_entity = Entity.create(:name => "Location",
                                  :description => "",
                                  :help => "Please fill in the latitude and longitude or the port name",
                                  :resizeable => true,
                                  :width => 450,
                                  :height => 80)

  latitude_field = Field.new( :name => "Latitude",
                              :field_key => "latitude",
                              :kind => "text",
                              :initial_value => "--",
                              :options => {})                               

  longitude_field = Field.new(:name => "Longitude",
                              :field_key => "longitude",
                              :kind => "text",
                              :initial_value => "--",
                              :options => {})
  
  port_field = Field.new( :name => "Port",
                          :field_key => "port",
                          :kind => "text",
                          :initial_value => "--",
                          :options => {})

  location_entity.fields << latitude_field
  location_entity.fields << longitude_field
  location_entity.fields << port_field
  location_entity.save
  
  template.entities << date_entity
  template.entities << location_entity
  template.entities << weather_entity
  
  template.save 
  

  #generate a single asset and a single user for testing just now
  
  Asset.create(:location=>"/images/testPage.png", :display_height => 1024, :display_width => 658, :height => 2048, :width => 1317,  :template => template)
  ZooniverseUser.create()
  
end