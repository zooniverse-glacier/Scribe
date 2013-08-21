# The image being transcribed
class Asset
  include Mongoid::Document
  include Mongoid::Timestamps
  include Randomizer
  
  # What is the native size of the image
  field :height, :type => Integer, :required => true
  field :width, :type => Integer, :required => true
  
  # What size should the image be displayed at
  field :display_width, :type => Integer, :required => true
  
  field :location, :type => String, :required => true
  field :ext_ref, :type => String
  field :order, :type => Integer
  field :template_id, :type => BSON::ObjectId
  
  field :done, :type => Boolean, :default => false 
  field :classification_count, :type => Integer , :default => 0
  
  field :thumbnail_location, :type => String
  
  scope :active, where(:done => false)
  scope :in_collection, lambda { |asset_collection| where(:asset_collection_id => asset_collection.id)}

  
  belongs_to :template
  belongs_to :asset_collection
  
  has_many :transcriptions
  
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

  def page_number
    self.order + 1
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
