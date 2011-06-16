class BooksController < ApplicationController

  #refactor this 
  def index 
    @books = Book.all.select{|b| b.assets.count>0}
  end
  
  def show
    @book = Book.find(params[:id])
    respond_to do |format|
         format.html
         format.json { render :json => @book.to_json(:include =>:assets) }
       end    
  end
end
