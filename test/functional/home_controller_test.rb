require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  context "Home controller" do
    setup do
      @controller = HomeController.new
      @request    = ActionController::TestRequest.new
      @response   = ActionController::TestResponse.new   
    end
    
    context "#index logged in" do
      setup do
        standard_cas_login_without_stub
        CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(true)
        get :index
      end
      
      should respond_with :success
    end
    
    context "#index not logged in" do
      setup do
        get :index
      end
      
      should respond_with :redirect
      
      should "redirect_to '/cas server with gateway set to true'" do
        assert_redirected_to 'https://login.zooniverse.org/login?service=http%3A%2F%2Ftest.host%2F&gateway=true'
      end
    end
  end
end