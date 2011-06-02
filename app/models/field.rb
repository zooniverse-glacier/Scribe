# The idea of the field is that it defines the layout of the thing being transcribed at the most fine level. e.g. a text-field
class Field
  include MongoMapper::EmbeddedDocument
  
  key :name, String
  key :field_key, String
  key :kind, String # text/select
  key :initial_value, String
  
  # This options hash has the descripition of the field with options.
  key :options, Hash
  key :validations, Array
  
  # TODO - should validate within scope of entity
  # validates_uniqueness_of :field_key, :scope => 'entity_id' ?
  
  belongs_to :entity
end