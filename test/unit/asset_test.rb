require 'test_helper'

class AssetTest < ActiveSupport::TestCase
  context "An Asset" do
    setup do
      @asset = Factory :asset, :width => 100, :height => 200, :display_width => 50
    end
    
    should_associate :template, :transcriptions
    should_have_keys :height, :width, :display_width, :location, :template_id, :created_at, :updated_at
    
    should "Calculate the correct display_height" do
      assert_equal @asset.display_height, 100
    end
  end
end
