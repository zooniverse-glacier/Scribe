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
        %w{default_zoom description name project}.each do |element|
          assert_equal @template.send(element), template[element]
        end
      end      
      
      should "be have correct template entities" do
        template = JSON.parse(@response.body)
        assert template['entities'].is_a?(Array)
        assert_equal template['entities'].length, 1
      end
      
      should "have correct entity structure" do
        template = JSON.parse(@response.body)
        entity = template['entities'].first
        %w{bounds description}.each do |element|
          assert_equal @template.entities.first.send(element), entity[element]
        end
        
        assert entity['fields'].is_a?(Array)
      end
    end
  end
end
