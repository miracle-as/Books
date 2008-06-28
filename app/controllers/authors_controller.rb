class AuthorsController < ApplicationController
  def index
    @authors = Author.all(:order => 'name')
  end
  
  def show
    @author = Author.find(params[:id])
    @books = @author.books.all(:order => 'name', :include => [ :loans, :small_image ])
  end
end
