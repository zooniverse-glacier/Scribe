class TemplatesController < ApplicationController
  def index
    @templates = Template.all
  end
  
  def new
    @template = Template.new
  end
  
  def show
    @template = Template.find(params[:id])
  end
end
