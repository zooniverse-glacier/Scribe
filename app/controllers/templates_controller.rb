class TemplatesController < ApplicationController
  before_filter CASClient::Frameworks::Rails::GatewayFilter
  before_filter :require_privileged_user, :except => [ :show ]
  
  def index
    @templates = Template.all
  end
  
  def show
    @asset = Asset.find(params[:asset_id])
    
    respond_to do |format|
      format.json {
        render :json => @asset.template.to_json(:include => { :entities => { :include => :fields }})
      }
    end
  end
  
  def new

  end
  
  def create
    template = params['template']
    entities_data = template['entities'].values

    entities=entities_data.collect do |e|
      fields_data = e["fields"].values
      fields = fields_data.collect do |f|
        f=Field.new(:name=>f["f_name"], :field_key=>f["f_name"], :kind => f["f_type"])
      end
      Entity.create(:name=>e['name'], :description => e['description'], :help=>e['help'], :fields=>fields, :default_zoom=>e['default_zoom'])
    end
    
    Template.create(:name => template['name'], :description => template['description'], :entities => entities)
    
    redirect_to '/transcribe'
  end
end
