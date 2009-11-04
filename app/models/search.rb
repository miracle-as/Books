class Search < ActiveRecord::Base
  def books
    @books ||= find_books
  end
  
  def authors
    @authors ||= find_authors
  end
  
  private
  def find_books
    Book.find(:all, :order => 'name', :conditions => ["books.name LIKE ? OR books.description LIKE ?", "%#{keywords}%", "%#{keywords}%"])
  end
  
  def find_authors
    Author.find(:all, :order => 'name', :conditions => ["authors.name LIKE ?", "%#{keywords}%"])
  end
end
