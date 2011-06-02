class ZooniverseUser
  include MongoMapper::Document
  
  key :zooniverse_user_id, Integer, :required => true
  key :name, String, :required => true
  key :public_name, String
  key :email, String
  key :admin, Boolean, :default => false
  
  timestamps!
  
  many :transcriptions
  
  # True if user is an admin or moderator
  def privileged?
    self.admin?
  end
end