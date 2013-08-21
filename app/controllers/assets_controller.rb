class AssetsController < ApplicationController
  
  def show
    @asset = Asset.find(params[:id])
    binding.pry
    respond_to do |format|
      format.html
      format.json { render :json => @asset.to_json }
    end
  end
  
  def show_next
    @asset = Asset.find(params[:id])
    next_asset = Asset.where(:asset_collection_id => @asset.asset_collection_id, :order => @asset.order+1).first
    redirect_to(:action => :show, :id => next_asset.id)
  end
  
  def show_prev
    @asset = Asset.find(params[:id])
    prev_asset = Asset.where(:asset_collection_id => @asset.asset_collection_id, :order => @asset.order-1).first
    redirect_to(:action => :show, :id => prev_asset.id)
  end
  
  
end