# The image being transcribed
class Asset
  include MongoMapper::Document
  include Randomizer
  
  # What is the native size of the image
  key :height, Integer, :required => true
  key :width, Integer, :required => true
  
  # What size should the image be displayed at
  key :display_width, Integer, :required => true
  
  key :location, String, :required => true
  key :template_id, ObjectId
  
  timestamps!
  
  belongs_to :template
  many :transcriptions
  
  # FIXME this obviously needs fixing
  def self.next_for_transcription
    return self.random(:limit => 1)
  end
  
  # Don't want the image to be squashed
  def display_height
    (display_width.to_f / width.to_f) * height
  end
end
