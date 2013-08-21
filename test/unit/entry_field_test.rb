require 'test_helper'

class EntryFieldTest < ActiveSupport::TestCase
  context "A Field" do
    setup do
      @entry_field = FactoryGirl.create :text_field
    end
    
    should_associate :entity
    should_have_keys :name, :field_key, :kind, :initial_value, :options
    
  end
end