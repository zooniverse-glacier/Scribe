# A collection of Annotations makes up a Transcription
class Annotation
  include Mongoid::Document
  include Mongoid::Timestamps

  
  field :bounds, :type => Hash # this is x-rel,  y-rel, with-rel, height-rel measure (0..1)
  field :data, :type => Hash # A hash looking something like :field_key => "Some value"
  
  belongs_to :transcription
  belongs_to :entity
  
  after_save :transform_search_record
  
  def transform_search_record
    Rails.logger.debug('transform_search_record')
#    SearchRecord.from_annotation(self)
  end
  
end
