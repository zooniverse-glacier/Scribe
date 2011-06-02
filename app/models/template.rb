# Template defines the entities that need transcribing
class Template
  include MongoMapper::Document
  
  key :name, String
  key :description, String
  key :project, String

  key :default_zoom, Float
  
  timestamps!
  
  many :assets
  many :entities
end
