require 'test_helper'

class EntityTest < ActiveSupport::TestCase
  context "An Entity" do
    setup do
      @entity = FactoryGirl.create :entity
    end
    
    should_associate :template, :entry_fields
    should_have_keys :name, :description, :help, :height, :resizeable, :width, :bounds, :zoom, :created_at, :updated_at
    
  end
end
