# An Entity is the 'thing' being transcribed e.g. a weather observation and is composed of many EntryFields
class Entity
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # For the UI - can be used to build a tutorial
  field :name, :type => String
  field :description, :type => String
  field :help, :type => String
  
  # Can this entity be resized in the UI?
  field :resizeable, :type => Boolean, :default => false
  field :width, :type => Integer
  field :height, :type => Integer
  field :bounds, :type => Array
  field :zoom, :type => Float
    
  field :search_record_type, :type => String

  belongs_to :template
  has_many :entry_fields
end