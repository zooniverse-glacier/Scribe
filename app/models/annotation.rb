# A collection of Annotations makes up a Transcription
class Annotation
  include MongoMapper::Document
  
  key :bounds, Array # this is x-rel and y-rel measure (0..1)
  key :data, Hash # A hash looking something like :field_key => "Some value"
  
  timestamps!
  
  belongs_to :transcription
  belongs_to :entity
end