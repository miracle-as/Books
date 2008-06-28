require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  context "on GET to :index when not logged in" do
    setup do
      get :index
    end
    
    should_assign_to :books
    should_not_assign_to :loans
    should_respond_with :success
    should_render_template :index
    should_not_set_the_flash
  end
  
  context "on GET to :index when logged in" do
    setup do
      login_as(:quentin)
      get :index
    end
    
    should_assign_to :books
    should_assign_to :loans
    should_respond_with :success
    should_render_template :index
    should_not_set_the_flash
  end
end
