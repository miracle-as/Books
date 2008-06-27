class Publisher < ActiveRecord::Base
  has_many :releases
  has_many :books, :through => :releases
end
