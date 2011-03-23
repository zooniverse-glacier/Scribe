# The idea of the field is that it defines the layout of the thing being transcribed at the most fine level. e.g. a text-field
class Field
  include MongoMapper::EmbeddedDocument
  
  key :kind, String
  key :name, String
  key :label, String
  key :options, Hash
  
  belongs_to :entity
end