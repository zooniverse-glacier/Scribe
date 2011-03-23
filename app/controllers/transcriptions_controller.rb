class TranscriptionsController < ApplicationController
  def new
    @asset = Asset.next_for_transcription
  end
  
  def add_entity
    # FIX ME - need to assign this dynamically
    @template = Template.first
    @annotation = Annotation.new
    @view_params = params
  end
end
