# The idea of the field is that it defines the layout of the thing being transcribed at the most fine level. e.g. a text-field
class EntryField
  include Mongoid::Document
  
  field :name, :type => String
  field :field_key, :type => String
  field :kind, :type => String # text/select
  field :initial_value, :type => String
  
  # This options hash has the descripition of the field with options.
  field :options, :type => Hash
  field :validations, :type => Array
  
  # TODO - should validate within scope of entity
  # validates_uniqueness_of :field_field, type => :scope => 'entity_id' ?
  
  field :search_key, :type => String
  belongs_to :entity
end