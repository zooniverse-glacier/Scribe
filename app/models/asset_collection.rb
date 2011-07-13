class AssetCollection
  include MongoMapper::Document
  key :title, String, :required => true
  key :composer, String, :required => false
  key :cat_no , String, :required =>true 
  
  many :assets 


  def front_page
    self.assets.where.order(:order).first
  end
end