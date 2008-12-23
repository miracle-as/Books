class BooksController < ApplicationController
  def per_page
    10
  end
  
  def index
    if params[:tag]
      @books = Book.paginate_tagged_with(params[:tag], :order => 'name', :page => params[:page], :per_page => per_page)
    else
      @books = Book.paginate(:order => 'name', :include => [ :authors, :loans, :small_image ], :page => params[:page], :per_page => per_page)
    end
    @book = Book.new
  end

  def show
    @book = Book.find(params[:id])
    @loans = @book.loans.all(:order => 'check_out DESC')
    @tags = @book.tags
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
    Book.send_notifications
    flash[:notice] = 'New book-notification sent.'[:new_book_notification_sent]
    redirect_to book_path(params[:id])
  end
  
  def reload
    @book = Book.find(params[:id])
    if @book.load_from_webservices!
      flash[:notice] = 'Data reloaded.'[:data_reloaded]
    else
      flash[:warning] = 'No data found.'[:no_data_found]
    end
    redirect_to @book
  end
  
  protected
  def authorized?(action=nil, resource=nil, *args)
    return true if logged_in? && current_user.admin?
    false
  end
end
