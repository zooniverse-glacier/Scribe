class AssetCollectionsController < ApplicationController

  #refactor this 
  def index 
    @books = AssetCollection.all.select{|b| b.assets.count>0}
  end
  
  def show
    @book = AssetCollection.find(params[:id])
    respond_to do |format|
         format.html
         format.json { render :json => @book.to_json(:include =>:assets) }
       end    
  end
end
