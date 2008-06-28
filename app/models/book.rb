require 'open-uri'

class Book < ActiveRecord::Base
  has_many :authorships
  has_many :authors, :through => :authorships
  has_many :releases
  has_many :publishers, :through => :releases
  has_many :loans
  has_many :users, :through => :loans

  belongs_to :small_image, :class_name => "Image", :foreign_key => "small_image_id"
  belongs_to :medium_image, :class_name => "Image", :foreign_key => "medium_image_id"
  belongs_to :large_image, :class_name => "Image", :foreign_key => "large_image_id"

  validate :must_be_valid_isbn
  validates_uniqueness_of :isbn

  before_validation :cleanup_isbn
  after_create :initialize_from_amazon
  
  def current_loan
    loans.select { |l| l.check_in.blank? }.first
  end
  
  def isbn_10
    ISBN_Tools.hyphenate_isbn10(self.isbn)
  end
  
  def isbn_13
    ISBN_Tools.hyphenate_isbn13(ISBN_Tools.isbn10_to_isbn13(self.isbn))
  end
  
  protected
  def must_be_valid_isbn
    errors.add :isbn, 'must be valid' unless ISBN_Tools.is_valid?(self.isbn)
  end
  
  def cleanup_isbn
    self.isbn = ISBN_Tools.isbn13_to_isbn10(self.isbn) if ISBN_Tools.is_valid_isbn13?(self.isbn)
    self.isbn = ISBN_Tools.cleanup(self.isbn)
  end
  
  def initialize_from_amazon
    return unless self.name.blank?
    xml = open("http://webservices.amazon.com/onca/xml?Service=AWSECommerceService&SubscriptionId=1VMAHZW8XQ31ER6CAWG2&Operation=ItemLookup&ResponseGroup=Medium&ItemId=#{self.isbn}").read
    doc = Hpricot.parse(xml)

    (doc/:item).collect do |item|
      self.amazon_detail_page_url = (item/:detailpageurl).innerHTML
      self.name = (item/:title).innerHTML
      self.pages = (item/:numberofpages).innerHTML
      self.published = (item/:publicationdate).innerHTML

      self.small_image = xml_to_image(item/:smallimage)
      self.medium_image = xml_to_image(item/:mediumimage)
      self.large_image = xml_to_image(item/:largeimage)

      publisher = (item/:publisher).innerHTML
      publisher = Publisher.find_or_create_by_name(publisher)
      self.publishers << publisher

      (item/:author).each do |author_element|
        name = author_element.innerHTML
        author = Author.find_or_create_by_name(name)
        self.authors << author
      end

      self.save
    end
  end
  
  def xml_to_image(xml)
    Image.create do |image|
      image.url = (xml/:url).first.innerHTML
      image.width = (xml/:width).first.innerHTML
      image.height = (xml/:height).first.innerHTML
    end
  end
end
