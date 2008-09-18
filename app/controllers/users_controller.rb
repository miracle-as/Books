class UsersController < ApplicationController
  def index
    @users = User.all(:order => 'login')
  end
  
  def show
    @user = User.find(params[:id])
    @active_loans = @user.loans.active.collect(&:book).sort_by(&:name)
    @all_loans = @user.loans.collect(&:book).sort_by(&:name)
    
    @inactive_loans = @all_loans - @active_loans
  end
end
