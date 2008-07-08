class UsersController < ApplicationController
  before_filter :must_be_self_or_admin, :except => [:index, :show, :new, :create]

  def index
    @users = User.all(:order => 'login')
  end
  
  def show
    @user = User.find(params[:id])
    @books = @user.loans.collect(&:book)
  end
  
  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
            redirect_back_or_default('/')
      flash[:notice] = 'Thanks for signing up!'
    else
      flash[:error]  = "We couldn't set up that account, sorry. Please try again, or contact an admin."
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Changes to user saved.'[:user_saved]
      redirect_to edit_user_url(@user)
    else
      render :action => 'edit'
    end
  end
  
  protected
  def must_be_self_or_admin
    return true if current_user.admin? || current_user.id.to_s == params[:id]
    access_denied
  end
end
