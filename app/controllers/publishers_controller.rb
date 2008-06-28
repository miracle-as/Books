class PublishersController < ApplicationController
  def index
    @publishers = Publisher.all(:order => 'name')
  end
  
  def show
    @publisher = Publisher.find(params[:id])
    @books = @publisher.books.all(:order => 'name')
  end
end
