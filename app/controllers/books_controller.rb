class BooksController < ApplicationController
  def index
    @books = Book.all(:limit => 5, :order => 'created_at DESC')
    @book = Book.new
  end
  
  def show
    @book = Book.find(params[:id])
  end
  
  def new
    @book = Book.new    
  end
  
  def create
    @book = Book.new(params[:book])
    if @book.save
      redirect_to books_url
    else
      @book = Book.new if params[:book] == { 'isbn' => '' }
      render :action => 'new'
    end
  end
end