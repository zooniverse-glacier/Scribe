task :sample_weather_bootstrap => :environment do
  Template.delete_all
  Entity.delete_all
  Asset.delete_all
  
  template = Template.create( :name => "My Transcription Template",
                              :description => "A template for transcribing weather recordds",
                              :project => "My great project",
                              :display_width => 600,
                              :default_zoom => 1.5)
                          
  
  
  weather_entity = Entity.create( :name => "Weather Observation",
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
                          
  air_temperature = Field.new(:name => "Air",
                              :field_key => "air_temperature",
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
  weather_entity.fields << air_temperature                              
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

  location_entity.fields << latitude_field
  location_entity.fields << longitude_field
  location_entity.save
  
  template.entities << date_entity
  template.entities << location_entity
  template.entities << weather_entity
  
  template.save 

  #generate a single asset and a single user for testing just now
  voyage = AssetCollection.create(:title => "HMS Attack", :author => "", :extern_ref => "http://en.wikipedia.org/wiki/HMS_Attack_(1911)")
  
  Asset.create(:location => "/images/1.jpeg", :display_width => 800, :height => 2126, :width => 1388, :template => template, :asset_collection => voyage)
  Asset.create(:location => "/images/2.jpeg", :display_width => 800, :height => 2107, :width => 1380, :template => template, :asset_collection => voyage)

  ZooniverseUser.create()
  
end