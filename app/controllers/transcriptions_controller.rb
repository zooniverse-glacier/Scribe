class TranscriptionsController < ApplicationController
  def new
    @asset = Asset.next_for_transcription
  end

  def show
    @transcription = Transcription.find(params[:id])
  end

  def create 
    transcription = params["transcription"]
    page_data     = transcription["page_data"]
    
    annotations = transcription["annotations"].values.collect do |ann|
      entity = Entity.find_by_name ann["kind"]
      logger.info("bounds are #{ann['bounds']}")
      Annotation.create(:data=>ann[:data],:entity=>entity, :bounds=>ann['bounds'] );
    end
    
    asset = Asset.find(page_data["asset_id"])
    user  = ZooniverseUser.first
    saved_transcription =Transcription.create(:zooniverse_user => ZooniverseUser.first, :asset=>asset, :annotations=>annotations, :page_data=>page_data)
    redirect_to saved_transcription
  end
  
  def transcribe 
    @asset= Asset.first
    @user = ZooniverseUser.first
  end
end

