require 'test_helper'

class TemplatesControllerTest < ActionController::TestCase
  context "Templates controller" do
    setup do
      @controller = TemplatesController.new
      @request    = ActionController::TestRequest.new
      @response   = ActionController::TestResponse.new   
    end
    
    
    context "#show for an asset" do
      setup do
        standard_cas_login
        @template = Factory :template
        @asset = Factory :asset, :template => @template
        get :show, { :asset_id => @asset.id, :format => "json" }
      end
      
      should respond_with 200
      
      should "be have correct template structure" do
        template = JSON.parse(@response.body)
        %w{default_zoom description name project entities}.each do |element|
          assert_equal @template.send(element), template[element]
        end
      end      
      
      should "be have correct template entities" do
        template = JSON.parse(@response.body)
        assert template['entities'].is_a?(Array)
        assert_equal template['entities'].length, 0
      end
      
      should "have correct entity structure" do
        
      end
    end
  end
end
