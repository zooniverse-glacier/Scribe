require 'test_helper'

class TranscriptionTest < ActiveSupport::TestCase
  context "A Transcription" do
    setup do
      @asset = Factory :asset
      @user  = Factory :zooniverse_user       
      @transcription = Factory :transcription, :zooniverse_user => @user, :asset => @asset

    end
    
    should_associate :asset, :zooniverse_user, :annotations
    should_have_keys :page_data, :created_at, :updated_at
    
    should "incremented classification count" do
      assert_equal @transcription.asset.classification_count, 1
    end
  end
end
