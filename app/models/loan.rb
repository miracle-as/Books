class Loan < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  
  before_create :return_previous_loan
  
  named_scope :active, :conditions => { :check_in => nil }
  
  def return!
    self.update_attribute :check_in, Time.now
  end
  
  protected
  def return_previous_loan
    previous_loan = self.book.loans.active.first
    previous_loan.return! unless previous_loan.blank?
  end
end
