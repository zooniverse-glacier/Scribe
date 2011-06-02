require 'test_helper'

class TranscriptionTest < ActiveSupport::TestCase
  context "A Transcription" do
    setup do
      @transcription = Factory :transcription
    end
    
    should_associate :asset, :zooniverse_user, :annotations
    should_have_keys :page_data, :created_at, :updated_at
  
  end
end
