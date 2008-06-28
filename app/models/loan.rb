class Loan < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  
  named_scope :active, :conditions => { :check_in => nil }
end
