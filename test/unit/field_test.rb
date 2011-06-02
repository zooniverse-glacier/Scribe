require 'test_helper'

class FieldTest < ActiveSupport::TestCase
  context "A Field" do
    setup do
      @field = Factory :text_field
    end
    
    should_associate :entity
    should_have_keys :name, :field_key, :kind, :initial_value, :options
    
  end
end