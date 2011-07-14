require 'factory_girl'

Factory.sequence :name do |n|
  "0000000".split('').zip("#{n}".reverse.split('')).reverse.collect{ |a| a[1] || a[0] }.join
end

Factory.define :asset do |a|
  a.height              1200
  a.width               600
  a.location  "http://imageserver.org/assets/1.jpg"
  a.ext_ref   "ref"
  a.display_width       400
end

Factory.define :template do |t|
  t.name                { "#{ Factory.next(:name) }" }
  t.description         "Something interesting"
  t.default_zoom        2.0
  t.entities            { |entity| [entity.association(:entity)] }
end

Factory.define :zooniverse_user do |z|
  z.zooniverse_user_id  1234
  z.name                "monkey"
  z.public_name         "Monkey Man"
  z.email               "monkey@gmail.com"
end

Factory.define :asset_collection do |ac|
  ac.title              "music"
  ac.composer           "me"
  ac.cat_no             "2"
end

Factory.define :admin_user, :class => ZooniverseUser do |z|
  z.zooniverse_user_id  1234
  z.name                "monkey"
  z.public_name         "Monkey Man"
  z.email               "monkey@gmail.com"
  z.admin               true
end

Factory.define :transcription do |t|
  t.page_data           { }
end

Factory.define :entity do |e|
  e.name                { "#{ Factory.next(:name) }" }
  e.description         "Something useful"
  e.help                "Something helpful"
  e.resizeable          true
  e.width               200
  e.height              50
  e.bounds              []
  e.zoom                1.5
end

Factory.define :text_field, :class => Field do |f|
  f.name                { "#{ Factory.next(:name) }" }
  f.field_key           "field_name_key"
  f.kind                "text"
  f.initial_value       "initial value"
  f.options             {}
end

Factory.define :annotation do |a|
  a.bounds              {}
  a.data                {}
end
