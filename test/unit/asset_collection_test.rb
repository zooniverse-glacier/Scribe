class AssetCollectionTest < ActiveSupport::TestCase
  
  context "An asset collection" do
    setup do 
      @asset_collection = FactoryGirl.create :asset_collection
      @asset1           = FactoryGirl.create :asset , :asset_collection => @asset_collection, :order => 1, :done=>true
      @asset2           = FactoryGirl.create :asset , :asset_collection => @asset_collection, :order => 2
      @asset3           = FactoryGirl.create :asset , :asset_collection => @asset_collection, :order => 3
    end
    
    should "report the correct front page" do 
      assert_equal @asset_collection.front_page , @asset1
    end
    
    should "report the correct number of active assets" do 
      assert_equal @asset_collection.remaining_active , 2
    end
    
    should "report that it is active" do 
      assert @asset_collection.active?
    end
    
    context "from which a user requests an asset" do
      setup do 
        @user = FactoryGirl.create :zooniverse_user 
        @transcription1 = Transcription.create(:zooniverse_user=>@user, :asset=>@asset1) 
      end
      
      should "return the next unseen asset " do 
        assert_equal @asset_collection.next_unseen_for_user(@user), @asset2
      end
      
      context "and all the assets are done " do
        setup do
          [@asset1,@asset2,@asset3].each{|a| a.done=true; a.save}
        end
        
        should "return nil" do
          assert_nil @asset_collection.next_unseen_for_user(@user)
        end
        
        should "report that their are no assets" do
          assert !@asset_collection.active?
        end
        
      end
      
      context "and the user has seen all the assets" do 
        setup do
          @transcription2 = Transcription.create(:zooniverse_user=>@user, :asset=>@asset2) 
          @transcription3 = Transcription.create(:zooniverse_user=>@user, :asset=>@asset3) 
        end
        
        should "return nil" do 
          assert_nil @asset_collection.next_unseen_for_user(@user)
        end
      end
      
    end
  end
end