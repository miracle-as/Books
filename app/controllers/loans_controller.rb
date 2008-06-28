class LoansController < ApplicationController
  before_filter :login_required

  def index
    @loans = current_user.loans.all(:order => 'check_out', :conditions => { :check_in => nil }, :include => {:book => [ :authors, :loans, :small_image ]})
  end

  def create
    book = Book.find(params[:book_id])
    loan = book.loans.create(:user => current_user, :check_out => Time.now)
    redirect_to book
  end
  
  def destroy
    loan = Loan.find(params[:id])
    loan.update_attribute :check_in, Time.now
    redirect_to loans_url
  end
end
