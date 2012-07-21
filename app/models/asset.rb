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
  key :ext_ref, String
  key :order, Integer
  key :template_id, ObjectId
  
  key :done, Boolean, :default => false 
  key :classification_count, Integer , :default => 0
  
  key :thumbnail_location, String
  
  scope :active, :conditions => { :done => false }
  scope :in_collection, lambda { |asset_collection| where(:asset_collection_id => asset_collection.id)}

  timestamps!
  
  belongs_to :template
  belongs_to :asset_collection
  
  many :transcriptions
  
  # keeping this for if we need a random asset
  def self.random_for_transcription
    Asset.random(:limit => 1).first
  end
  
  def self.next_unseen_for_user(user)
    seen = user.transcriptions.collect{|t| t.asset_id}
    Asset.active.where(:id.nin => seen).first
  end
  
  def self.classification_limit
    5
  end

  # Don't want the image to be squashed
  def display_height
    (display_width.to_f / width.to_f) * height
  end
  
  def increment_classification_count
    self.classification_count = self.classification_count+1
    if self.classification_count > 5
      self.done=true
    end
    self.save 
  end
end
