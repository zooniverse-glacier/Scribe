class AssetCollection
  include MongoMapper::Document
  key :title, String, :required => true
  key :author, String, :required => false
  key :extern_ref, String

  key :has_thumbnails, Boolean, :default => false

  many :assets 
  
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