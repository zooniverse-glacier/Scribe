require 'test_helper'

class AnnotationTest < ActiveSupport::TestCase
  context "An Annotion" do
    setup do
      @annotion = Factory :annotation
    end
    
    should_associate :transcription, :entity
    should_have_keys :bounds, :data, :created_at, :updated_at
    
  end
end