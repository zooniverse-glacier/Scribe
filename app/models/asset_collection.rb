class AssetCollection
  include MongoMapper::Document
  key :title, String, :required => true
  key :composer, String, :required => false
  key :cat_no , String, :required =>true 
  
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