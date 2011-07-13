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
  key :ext_ref , String , :required =>true
  key :order , Integer, :required =>true
  key :template_id, ObjectId
  
  key :done, Boolean, :default =>false 
  key :classification_count, Integer , :default=>0
  
  scope :active, :conditions => { :done => false }
  
  timestamps!
  
  belongs_to :template
  belongs_to :asset_collection
  
  many :transcriptions
  
  # FIXME this obviously needs fixing
  def self.next_for_transcription
    return Asset.random(:limit => 1).first
  end
  
  def self.next_unseen_for_user(user)
    #seen = user.transcriptions.collect{|t| t.asset_id}
    #Asset.active.where(:id.nin=>seen).first
    Asset.random(:limit => 1).first
  end
  
  # Don't want the image to be squashed
  def display_height
    (display_width.to_f / width.to_f) * height
  end
  
  def increment_classificaiton_count
    self.classification_count = self.classification_count+1
    if self.classification_count > 5
      self.done=true
    end
    self.save 
  end
end
