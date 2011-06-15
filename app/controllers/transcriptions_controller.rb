class TranscriptionsController < ApplicationController
  before_filter CASClient::Frameworks::Rails::Filter, :except => :create 
   
  
  def new
    @asset = Asset.next_for_transcription
    @user = current_zooniverse_user
  end

  def show
    @transcription = Transcription.find(params[:id])
  end

  def index 
    @transcriptions = Transcription.all
    
  end

  def edit 
    @transcription = Transcription.find(params[:id])
    @asset = @transcription.asset
    @user  = current_zooniverse_user
  end

  def create 
    transcription_params = params[:transcription]
    page_data = transcription_params[:page_data]    
    asset = Asset.find(page_data[:asset_id])
    puts "saving with #{current_zooniverse_user.to_json}"
    
    transcription = Transcription.create( :zooniverse_user => ZooniverseUser.find(page_data[:zooniverse_user_id]),
                                          :asset => asset, 
                                          :page_data => page_data)
                                            
    annotations = transcription_params[:annotations]
    
    unless annotations.blank?
      annotations.values.collect do |ann|
        entity = Entity.find_by_name ann["kind"]
        if entity
          transcription.annotations << Annotation.create(:data => ann[:data], :entity => entity, :bounds => ann[:bounds])
        else
          logger.error("could not find entity type #{ann['kind']}")
        end
      end
    end                                      
    
    respond_to do |format|
      format.js { render :nothing => true, :status => :created }
    end
  end
end

