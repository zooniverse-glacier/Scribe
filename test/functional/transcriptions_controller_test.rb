require 'test_helper'

class TranscriptionsControllerTest < ActionController::TestCase
  context "Transcriptions controller" do
    setup do
      @controller = TranscriptionsController.new
      @request    = ActionController::TestRequest.new
      @response   = ActionController::TestResponse.new   
    end
    
    context "#new not logged in" do
      setup do
        @template = Factory :template
        @asset_collection = Factory :asset_collection
        @asset = Factory :asset, :asset_collection=>@asset_collection

        get :new
      end
      
      should respond_with :redirect
      
      should "redirect_to '/cas server'" do
        assert_redirected_to "https://login.zooniverse.org/login?service=http%3A%2F%2Ftest.host%2Ftranscriptions%2Fnew"
      end
    end
    
    context "#new logged in" do
      setup do
        @template = Factory :template
        @asset = Factory :asset

        standard_cas_login_without_stub
        CASClient::Frameworks::Rails::Filter.stubs(:filter).returns(true)
        get :new
      end
      
      should respond_with :success
    end
  end
end
