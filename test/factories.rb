require 'factory_girl'

Factory.sequence :name do |n|
  "0000000".split('').zip("#{n}".reverse.split('')).reverse.collect{ |a| a[1] || a[0] }.join
end

# Factory.define :asset do |a|
#   a.height              800
#   a.width            "http://imageserver.org/assets/1"
#   a.thumbnail_location  "http://imageserver.org/assets/thumbs/1"
# end
# 
# 
# key :height, Integer
# key :width, Integer
# 
# key :display_height, Integer
# key :display_width, Integer
# 
# key :location, String
# key :template_id, ObjectId
# 
# timestamps!
# 
# belongs_to :template
# many :transcriptions