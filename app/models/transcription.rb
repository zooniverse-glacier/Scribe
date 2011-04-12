# A Transcription is a user-transcription of an Asset and is composed of many Annotations
class Transcription
  include MongoMapper::Document
  
  key :page_data , Hash 
  
  timestamps!
  
  belongs_to :asset
  belongs_to :zooniverse_user
  many :annotations
end