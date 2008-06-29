class LoansController < ApplicationController
  before_filter :login_required

  def index
    @loans = current_user.loans.active.all(:order => 'check_out', :include => {:book => [ :authors, :loans, :small_image ]})
  end

  def create
    book = Book.find(params[:book_id])
    loan = book.loans.create(:user => current_user, :check_out => Time.now)
    flash[:notice] = 'Your loan has been registered.'[:loan_registered]
    redirect_to book
  end
  
  def destroy
    loan = Loan.find(params[:id])
    loan.update_attribute :check_in, Time.now
    flash[:notice] = 'You have returned the book.'[:book_returned]
    redirect_to loan.book
  end
end
