require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  context "on GET to :show when not logged in" do
    setup do
      get :show, :id => books(:mmm)
    end

    should_assign_to :book
    should_assign_to :loans
    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash
  end
  
  context "on GET to :index when not logged in" do
    setup do
      get :index
    end

    should_assign_to :books
    should_assign_to :book
    should_respond_with :success
    should_render_template :index
    should_not_set_the_flash
  end
end
