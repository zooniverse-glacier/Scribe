require 'factory_girl'

Factory.sequence :name do |n|
  "0000000".split('').zip("#{n}".reverse.split('')).reverse.collect{ |a| a[1] || a[0] }.join
end

Factory.define :asset, :class => Asset do |a|
  a.height              1200
  a.width               600
  a.location  "http://imageserver.org/assets/1.jpg"
  a.display_width       400
end

Factory.define :zooniverse_user do |z|
  z.zooniverse_user_id  1234
  z.name                "monkey"
  z.public_name         "Monkey Man"
  z.email               "monkey@gmail.com"
end

Factory.define :admin_user, :class => ZooniverseUser do |z|
  z.zooniverse_user_id  1234
  z.name                "monkey"
  z.public_name         "Monkey Man"
  z.email               "monkey@gmail.com"
  z.admin               true
end
