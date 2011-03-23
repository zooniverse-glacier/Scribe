# An Entity is the 'thing' being transcribed e.g. a weather observation and is composed of many Fields
class Entity
  include MongoMapper::Document
  
  key :name, String
  timestamps!
  
  belongs_to :template
  many :fields
end