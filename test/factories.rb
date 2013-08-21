require 'factory_girl'

FactoryGirl.define do
  sequence :name do |n|
    "0000000".split('').zip("#{n}".reverse.split('')).reverse.collect{ |a| a[1] || a[0] }.join
  end

  factory :asset do |a|
    a.height              1200
    a.width               600
    a.location  "http://imageserver.org/assets/1.jpg"
    a.ext_ref   "ref"
    a.display_width       400
  end

  
  factory :template do |t|
    t.name                { "#{ FactoryGirl.generate(:name) }" }
    t.description         "Something interesting"
    t.default_zoom        2.0
    t.entities            { |entity| [entity.association(:entity)] }
  end
  
  factory :zooniverse_user do |z|
    z.zooniverse_user_id  1234
    z.name                "monkey"
    z.public_name         "Monkey Man"
    z.email               "monkey@gmail.com"
  end
  
  factory :asset_collection do |ac|
    ac.title              "music"
    ac.author           "me"
    ac.extern_ref         "2"
  end
  
  factory :admin_user, :class => ZooniverseUser do |z|
    z.zooniverse_user_id  1234
    z.name                "monkey"
    z.public_name         "Monkey Man"
    z.email               "monkey@gmail.com"
    z.admin               true
  end
  
  factory :transcription do |t|
    t.page_data           { }
  end
  
  factory :entity do |e|
    e.name                { "#{ FactoryGirl.generate(:name) }" }
    e.description         "Something useful"
    e.help                "Something helpful"
    e.resizeable          true
    e.width               200
    e.height              50
    e.bounds              []
    e.zoom                1.5
  end
  
  factory :text_field, :class => EntryField do |f|
    f.name                { "#{ FactoryGirl.generate(:name) }" }
    f.field_key           "field_name_key"
    f.kind                "text"
    f.initial_value       "initial value"
    f.options             {}
  end
  
  factory :annotation do |a|
    a.bounds              {}
    a.data                {}
  end

end
