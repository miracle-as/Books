class User < ActiveRecord::Base
  has_many :loans
  has_many :books, :through => :loans

  def name_or_login
    name.blank? ? login : name
  end
end