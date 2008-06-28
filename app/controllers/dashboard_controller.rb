class DashboardController < ApplicationController
  def index
    @books = Book.all(:limit => 5, :order => 'created_at DESC', :include => [ :authors, :small_image ])
    @loans = current_user.loans.active.all(:order => 'check_out', :include => {:book => [ :authors, :small_image ]}) if logged_in?
  end
end