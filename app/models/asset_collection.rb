class AssetCollection
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, :type => String, :required => true
  field :author, :type => String, :required => false
  field :extern_ref, :type => String

  field :has_thumbnails, :type => Boolean, :default => false

  has_many :assets 
  
  def front_page
    self.assets.where.order(:order).first
  end
  
  def next_unseen_for_user(user)
    seen = user.transcriptions.collect{|t| t.asset_id}
    self.assets.active.where(:id.nin=>seen).first
  end
  
  def remaining_active
    self.assets.where(:done=>false).count 
  end
  
  def active?
    self.remaining_active != 0 
  end 
end