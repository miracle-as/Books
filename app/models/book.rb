require 'open-uri'

class Book < ActiveRecord::Base
  has_many :authorships
  has_many :authors, :through => :authorships
  
  validate :must_be_valid_isbn
  validates_uniqueness_of :isbn

  before_validation :convert_isbn_to_isbn10
  after_create :initialize_from_amazon
  
  def author_names
    self.authors.collect(&:name).join(', ')
  end
  
  protected
  def must_be_valid_isbn
    errors.add :isbn, 'must be valid' unless ISBN_Tools.is_valid?(self.isbn.to_s)
  end
  
  def convert_isbn_to_isbn10
    self.isbn = ISBN_Tools.isbn13_to_isbn10(self.isbn.to_s).to_i if ISBN_Tools.is_valid_isbn13?(isbn.to_s)
  end
  
  def initialize_from_amazon
    return unless self.name.blank?
    xml = open("http://webservices.amazon.com/onca/xml?Service=AWSECommerceService&SubscriptionId=1VMAHZW8XQ31ER6CAWG2&Operation=ItemLookup&ResponseGroup=Medium&ItemId=#{self.isbn}").read
    doc = Hpricot.parse(xml)

    (doc/:item).collect do |item|
      self.name = (item/:title).innerHTML
      self.pages = (item/:numberofpages).innerHTML
      self.published = (item/:publicationdate).innerHTML
      puts 'Publisher: ' + (item/:publisher).innerHTML

      (item/:author).each do |author_element|
        name = author_element.innerHTML
        author = Author.find_or_create_by_name(name)
        self.authors << author
      end

      self.save
    end
  end
end
