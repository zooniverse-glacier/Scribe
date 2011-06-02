class TranscriptionsController < ApplicationController
  before_filter CASClient::Frameworks::Rails::Filter, :except => :create  
  
  def new
    @asset = Asset.next_for_transcription
    @user = current_zooniverse_user
  end

  def show
    @transcription = Transcription.find(params[:id])
  end

  def create 
    transcription_params = params[:transcription]
    page_data = transcription_params[:page_data]    
    asset = Asset.find(page_data[:asset_id])
    
    transcription = Transcription.create( :zooniverse_user => current_zooniverse_user,
                                          :asset => asset, 
                                          :page_data => page_data)
                                            
    
    annotations = transcription_params[:annotations].values.collect do |ann|
      entity = Entity.find_by_name ann["kind"]
      if entity
        transcription.annotations << Annotation.create(:data => ann[:data], :entity => entity, :bounds => ann[:bounds])
      end
    end                                            
    
    respond_to do |format|
      format.js { render :nothing => true, :status => :created }
    end

  end
end

