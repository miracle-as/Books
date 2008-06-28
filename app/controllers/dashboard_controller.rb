class DashboardController < ApplicationController
  def index
    @books = Book.all(:limit => 5, :order => 'created_at DESC', :include => [ :authors, :loans, :small_image ])
    @loans = current_user.loans.all(:order => 'check_out', :conditions => { :check_in => nil }, :include => {:book => [ :authors, :loans, :small_image ]})
  end
end
