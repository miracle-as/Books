module Factory
  def self.create_user(login)
    password = login * ((6 / login.size).to_i + 1)
    User.create!(:login => login, :email => "#{login}@example.com", :password => password, :password_confirmation => password)
  end
  
  def self.create_book(title)
    Book.create!(:name => title, :isbn => generate_valid_isbn)
  end
  
  protected
  def self.generate_valid_isbn
    @@isbn_counter ||= 100000001 # 9 digit number
    @@isbn_counter += 1
    @@isbn_counter.to_s + ISBN_Tools.compute_isbn10_check_digit(@@isbn_counter.to_s)
  end
end