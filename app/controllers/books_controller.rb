class BooksController < ApplicationController
  before_filter :login_required, :only => [:new, :create, :edit, :update]
  
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
      redirect_to @book
    else
      @book = Book.new if params[:book] == { 'isbn' => '' }
      render :action => 'new'
    end
  end
  
  def edit
    @book = Book.find(params[:id])
  end
  
  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(params[:book])
      redirect_to @book
    else
      render :action => 'edit'
    end
  end
  
  def notify
    @book = Book.find(params[:id])
    @book.notify!
    redirect_to @book
  end
end