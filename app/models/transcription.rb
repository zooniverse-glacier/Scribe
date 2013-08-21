# A Transcription is a user-transcription of an Asset and is composed of many Annotations
class Transcription
  include Mongoid::Document
  include Mongoid::Timestamps

  
  after_save :update_classification_count
  
  field :page_data, :type => Hash 
  
  belongs_to :asset
  belongs_to :zooniverse_user
  
  has_many :annotations
  
  
  def update_classification_count
    self.asset.increment_classification_count
  end
  
  def add_annotations_from_json(new_annotations)
     unless new_annotations.blank?
      new_annotations.values.collect do |ann|
        # TODO: change this from a smart key to a legitimate id
        entity = Entity.where(:name => ann["kind"]).first
        if entity
          self.annotations << Annotation.create(:data => ann[:data], :entity => entity, :bounds => ann[:bounds], :transcription => self)
        else
          puts "could not find entity type #{ann['kind']}"
        end
      end
    end
  end
end