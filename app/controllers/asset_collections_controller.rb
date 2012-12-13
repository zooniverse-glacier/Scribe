class AssetCollectionsController < ApplicationController

  #refactor this 
  def index 
    @collections = AssetCollection.all.select{|b| b.assets.count>0}
  end
  
  def show
    @collection = AssetCollection.find(params[:id])
    if @collection.has_thumbnails 
#      redirect_to :controller => :asset_collections, :action => :show_grid, :id => @collection.id
      redirect_to show_grid_asset_collections_path(:id => @collection.id)
    else  
      respond_to do |format|
        format.html
        format.json { render :json => @collection.to_json(:include =>:assets) }
      end    
    end
  end

  def show_grid
    @collection = AssetCollection.find(params[:id])
    #render :text => @collection.inspect
  end

  def filter
    conditions = {}
    conditions[:chapman_code] = params[:chapman_code] unless params[:chapman_code].blank?
    conditions[:difficulty] = params[:difficulty] unless params[:difficulty].blank?
    @collections = AssetCollection.where(:conditions => conditions, :start_date => {:$gte => params[:input_date]}, :end_date => {:$lte => params[:input_date]}).all
    render :index
  end

end
