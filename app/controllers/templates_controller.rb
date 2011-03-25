class TemplatesController < ApplicationController
  def index
    @templates = Template.all
  end
  
  def new
    @template = Template.new
  end
  
  def template_for_asset
     #@asset= Asset.find(params[:id])
     respond_to do |format|
        format.json {
          render :json => Template.first.to_json(:include=>{:entities =>{:include => :fields}})
        }
     end
  end
  
  def show
    @template = Template.find(params[:id])
  end
end
