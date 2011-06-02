require 'test_helper'

class ZooniverseUserTest < ActiveSupport::TestCase
  context "A Zooniverse User" do
    setup do
      @zooniverse_user = Factory :zooniverse_user
    end
    
    should_associate  :transcriptions
    should_have_keys :zooniverse_user_id, :name, :public_name, :email, :admin, :created_at, :updated_at
        
    should "not be privileged" do
      assert !@zooniverse_user.privileged?
    end
  end
  
  context "An Admin Zooniverse User" do
    setup do
      @zooniverse_user = Factory :admin_user
    end
      
    should "be privileged" do
      assert @zooniverse_user.privileged?
    end
  end
end
