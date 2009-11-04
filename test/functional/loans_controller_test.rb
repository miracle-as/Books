require File.dirname(__FILE__) + '/../test_helper'

class LoansControllerTest < ActionController::TestCase
  context "on GET to :index when not logged in" do
    setup do
      logout
      get :index
    end
    
    should_not_assign_to :loans
    should_not_assign_to :my_loans
    should_respond_with :redirect
    should_not_set_the_flash
  end
  
  context "on GET to :index when logged in" do
    setup do
      login_as(:quentin)
      get :index
    end

    should_assign_to :loans
    should_assign_to :my_loans
    should_respond_with :success
    should_render_template :index
    should_not_set_the_flash
  end
  
  context "borrowing a book" do
    setup do
      login_as(:quentin)
      Loan.delete_all # remove previous loans
      post :create, :book_id => books(:mmm).id
    end

    should_respond_with :redirect
    should "make the book return a .current_loan" do
      assert_not_nil books(:mmm).current_loan
    end
  end
  
  context "returning a book" do
    setup do
      login_as(:quentin)
      delete :destroy, :id => loans(:quentin_mmm)
    end
    
    should_respond_with :redirect
    should "set check_in" do
      loan = loans(:quentin_mmm).reload
      assert_not_nil loan.check_in
    end
    should "make book.current_loan be nil" do
      assert_nil loans(:quentin_mmm).book.current_loan
    end
  end
end