# A Transcription is a user-transcription of an Asset and is composed of many Annotations
class Transcription
  include MongoMapper::Document
  
  after_save :update_classification_count
  
  key :page_data , Hash 
  
  timestamps!
  
  belongs_to :asset
  belongs_to :zooniverse_user
  
  many :annotations
  
  
  def update_classification_count
    self.asset.increment_classification_count
  end
end