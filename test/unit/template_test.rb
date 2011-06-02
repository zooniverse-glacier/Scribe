require 'test_helper'

class TemplateTest < ActiveSupport::TestCase
  context "A Template" do
    setup do
      @template = Factory :template
    end
    
    should_associate :assets, :entities
    should_have_keys :name, :description, :project, :default_zoom, :created_at, :updated_at
  
  end
end
