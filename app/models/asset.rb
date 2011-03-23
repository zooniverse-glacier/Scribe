# The image being transcribed
class Asset
  include MongoMapper::Document
  # What is the native size of the image
  key :height, Integer
  key :width, Integer
  # What size should the image be displayed at
  key :display_height, Integer
  key :display_width, Integer
  
  key :location, String
  key :template_id, ObjectId
  
  timestamps!
  
  belongs_to :template
  many :transcriptions

  def self.next_for_transcription
    return first
  end
end
