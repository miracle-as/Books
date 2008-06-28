class BooksController < ApplicationController
  before_filter :login_required, :only => :create
  
  def per_page
    10
  end
  
  def index
    @books = Book.paginate(:order => 'name', :include => [ :authors, :loans, :small_image ], :page => params[:page], :per_page => per_page)
    @book = Book.new
  end

  def show
    @book = Book.find(params[:id])
    @loans = @book.loans.all(:order => 'check_out DESC')
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(params[:book])
    if @book.save && !@book.name.blank?
      redirect_to books_url
    else
      @book = Book.new if params[:book] == { 'isbn' => '' }
      render :action => 'new'
    end
  end
end