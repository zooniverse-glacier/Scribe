# An Entity is the 'thing' being transcribed e.g. a weather observation and is composed of many Fields
class Entity
  include MongoMapper::Document
  
  # For the UI - can be used to build a tutorial
  key :name, String
  key :description, String
  key :help, String
  
  # Can this entity be resized in the UI?
  key :resizeable, Boolean, :default => false
  key :width, Integer
  key :height, Integer
  key :bounds, Array
  key :zoom, Float
    
  timestamps!
  
  belongs_to :template
  many :fields
end