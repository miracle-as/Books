class LoansController < ApplicationController
  def index
    @my_loans = current_user.loans.active.all(:order => 'check_out', :include => {:book => [ :authors, :loans, :small_image ]})
    @loans = Loan.active.all(:conditions => ['NOT(loans.user_id = ?)', current_user.id], :order => 'users.login, loans.created_at', :include => [:user, {:book => [ :authors, :loans, :small_image ]}])
    @loans = @loans.group_by(&:user)
  end

  def create
    book = Book.find(params[:book_id])
    loan = book.loans.create(:user => current_user, :check_out => Time.now)
    flash[:notice] = 'Your loan has been registered.'[:loan_registered]
    redirect_to book
  end
  
  def destroy
    loan = Loan.find(params[:id])
    loan.return!
    flash[:notice] = 'You have returned the book.'[:book_returned]
    redirect_to loan.book
  end
end
