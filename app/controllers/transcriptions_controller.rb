class TranscriptionsController < ApplicationController
  
  skip_before_filter :login_required
    skip_before_filter :login_from_cookie
    before_filter CASClient::Frameworks::Rails::GatewayFilter, :only => :new
    before_filter :check_or_create_zooniverse_user, :only => :new
  
  def new
    @user = current_zooniverse_user
    @asset = Asset.next_unseen_for_user(@user)
    puts "#{current_zooniverse_user}"
  end

  def show
    @transcription = Transcription.find(params[:id])
  end

  def index 
    @transcriptions = current_zooniverse_user.transcriptions.all
    
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
   
    transcription = Transcription.create( :zooniverse_user => current_zooniverse_user,
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
    
    puts "#{transcription.to_json}"
    respond_to do |format|
      format.js { render :nothing => true, :status => :created }
    end
  end
end

