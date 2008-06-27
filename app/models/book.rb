class Book < ActiveRecord::Base
  has_many :authorships
  has_many :authors, :through => :authorships
  
  validates_presence_of :name
  
  def author_names
    self.authors.collect(&:name).join(', ')
  end
end
