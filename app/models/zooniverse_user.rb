class ZooniverseUser
  include Mongoid::Document
  include Mongoid::Timestamps

  
  field :zooniverse_user_id, :type => Integer, :required => true
  field :name, :type => String, :required => true
  field :public_name, :type => String
  field :email, :type => String
  field :admin, :type => Boolean, :default => false
  
  has_many :transcriptions
  
  # True if user is an admin or moderator
  def privileged?
    self.admin?
  end
end