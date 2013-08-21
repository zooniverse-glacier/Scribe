class TranscriptionsController < ApplicationController
  before_filter CASClient::Frameworks::Rails::Filter, :only => [:new, :index, :edit]
  before_filter :check_or_create_zooniverse_user, :only => [:new, :index, :edit]
  before_filter :get_or_assign_collection, :get_or_assign_asset, :only => [:new]
  after_filter :clear_session, :only =>[ :create ]
  
  def new
    @user = current_zooniverse_user
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
    @user = current_zooniverse_user
  end
  
  def create 
    transcription_params = params[:transcription]
    page_data = transcription_params[:page_data]    
    asset = Asset.find(page_data[:asset_id])
   
    transcription = Transcription.create( :zooniverse_user => current_zooniverse_user,
                                          :asset => asset, 
                                          :page_data => page_data)
                                            
    annotations = transcription_params[:annotations]
    
    transcription.add_annotations_from_json(annotations)
    
    puts "#{transcription.to_json}"
    respond_to do |format|
      format.js { render :nothing => true, :status => :created }
    end
  end
  
  
  def update
     transcription = Transcription.find(params[:id])
     logger.error "count not find transcription to update" unless transcription
     
     transcription_params = params[:transcription]
     
     transcription.annotations.delete_all
     transcription.add_annotations_from_json( transcription_params[:annotations])
     
     respond_to do |format|
       format.js { render :nothing => true, :status => :created }
     end
  end
  
  def get_or_assign_collection
    @collection = AssetCollection.find(session[:collection_id]) if session[:collection_id]
    unless @collection and @collection.active? 
      @collection = Asset.next_unseen_for_user(current_zooniverse_user).try(:asset_collection)
      if @collection
        session[:collection_id] = @collection.id
      else
        self.clear_session
        flash[:notice]= "You have already seen everything"
        redirect_to :root
      end
    end
  end
  
  def get_or_assign_asset
    @asset=Asset.find(session[:asset_id]) if session[:asset_id]
    #if we have no asset in the session
    unless @asset
      #try to get a new one from the current collection
      @asset = @collection.next_unseen_for_user current_zooniverse_user
      session[:asset_id] = @asset.id
    end
  end
  
  def clear_session
    [:asset_id, :collection_id].each {|a| session[a]=nil}
  end
end

