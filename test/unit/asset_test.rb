require 'test_helper'

class AssetTest < ActiveSupport::TestCase
  context "An Asset" do
    setup do
      @asset = FactoryGirl.create :asset, :width => 100, :height => 200, :display_width => 50
    end
    
    should_associate :template, :transcriptions
    should_have_keys :height, :width, :display_width, :location, :template_id, :created_at, :updated_at
    
    should "Calculate the correct display_height" do
      assert_equal @asset.display_height, 100
    end
    
    context "when incrementing classification count" do
      setup do 
        @asset.increment_classification_count
      end
      
      should "increment its classification count" do 
        assert_equal @asset.classification_count ,1 
      end
      
      context "and the asset is almost at the classification limit" do 
        setup do
           @asset.classification_count = Asset.classification_limit  
           @asset.increment_classification_count
        end
        
        should "set the asset to done" do 
          assert @asset.done
        end
      end
    end
  end
  
  context "When selecting an asset to show a user" do 
    setup do 
      @asset1 = FactoryGirl.create :asset
      @asset2 = FactoryGirl.create :asset
      @user   = FactoryGirl.create :zooniverse_user 
      @transcription = Transcription.create(:zooniverse_user=>@user, :asset=>@asset1) 
    end
    
    should "return an unseen asset" do
      assert_equal Asset.next_unseen_for_user(@user), @asset2
    end
    
    context "and all the assets are done" do 
      setup do 
        @asset1.done = true
        @asset2.done = true
        @asset1.save
        @asset2.save
      end
      
      should "return nil" do
        assert_nil  Asset.next_unseen_for_user(@user)
      end
    end
    
    context "and the user has seen them all" do
      setup do 
        @transcription2 = Transcription.create(:zooniverse_user=>@user, :asset=>@asset2)
      end
      
      should "return nil" do 
        assert_nil Asset.next_unseen_for_user(@user)
      end
    end
    
  end
end
