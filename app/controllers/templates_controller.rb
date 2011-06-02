class TemplatesController < ApplicationController
  before_filter CASClient::Frameworks::Rails::GatewayFilter
  before_filter :require_privileged_user
  
  def index
    @templates = Template.all
  end
  
  def new

  end
  
  def create
    puts params
    template = params['template']
    entities_data = template['entities'].values
    
    puts "template"
    puts template
    puts "entites"
    puts entities_data
    entities=entities_data.collect do |e|
      puts "fields"
      puts e['fields'].values
      fields_data = e["fields"].values
      fields = fields_data.collect do |f|
        f=Field.new(:name=>f["f_name"], :field_key=>f["f_name"], :kind=>f["f_type"])
      end
      Entity.create(:name=>e['name'], :description=>e['description'], :help=>e['help'], :fields=>fields, :default_zoom=>e['default_zoom'])
    #           Entity.create(:name)
    end
    
    Template.create(:name=>template['name'], :description=>template['description'],:entities=>entities)
    
    redirect_to '/transcribe'
  end
  
  def template_for_asset
     #@asset= Asset.find(params[:id])
     respond_to do |format|
        format.json {
          render :json => Template.all.last.to_json(:include=>{:entities =>{:include => :fields}})
        }
     end
  end
  
  def show
    @template = Template.find(params[:id])
  end
end
