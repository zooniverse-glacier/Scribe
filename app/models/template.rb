# Template defines the entities that need transcribing
class Template
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :description, :type => String
  field :project, :type => String

  field :default_zoom, :type => Float
  
  has_many :assets
  has_many :entities
end
