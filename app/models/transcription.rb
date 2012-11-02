# A Transcription is a user-transcription of an Asset and is composed of many Annotations
class Transcription
  include MongoMapper::Document
  
  after_save :update_classification_count
  
  key :page_data , Hash 
  
  timestamps!
  
  belongs_to :asset
  belongs_to :zooniverse_user
  
  many :annotations
  
  
  def update_classification_count
    self.asset.increment_classification_count
  end
  
  def add_annotations_from_json(new_annotations)
     unless new_annotations.blank?
      new_annotations.values.collect do |ann|
        # TODO: change this from a smart key to a legitimate id
        entity = Entity.find_by_name ann["kind"]
        if entity
          self.annotations << Annotation.create(:data => ann[:data], :entity => entity, :bounds => ann[:bounds], :transcription => self)
        else
          puts "could not find entity type #{ann['kind']}"
        end
      end
    end
  end
end