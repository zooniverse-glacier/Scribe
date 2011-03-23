class ZooniverseUser
  include MongoMapper::Document
  
  timestamps!
  
  many :transcriptions
end