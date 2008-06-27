class Release < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :book
end
