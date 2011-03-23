# Template defines the entities that need transcribing
class Template
  include MongoMapper::Document
  
  key :name, String
  timestamps!
  
  many :assets
  many :entities
end
