# A collection of Annotations makes up a Transcription
class Annotation
  include MongoMapper::Document
  
  timestamps!
  
  belongs_to :transcription
  belongs_to :entity
end