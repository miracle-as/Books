require 'open-uri'

class Book < ActiveRecord::Base
  acts_as_taggable_on :tags
  
  has_many :authorships
  has_many :authors, :through => :authorships
  belongs_to :publisher
  has_many :loans
  has_many :users, :through => :loans

  belongs_to :small_image, :class_name => "Image", :foreign_key => "small_image_id"
  belongs_to :medium_image, :class_name => "Image", :foreign_key => "medium_image_id"
  belongs_to :large_image, :class_name => "Image", :foreign_key => "large_image_id"

  validate :must_be_valid_isbn
  validates_uniqueness_of :isbn

  before_validation :cleanup_isbn
  after_save :initialize_from_amazon, :initialize_from_saxo 

  def current_loan
    @current_loan ||= loans.active.first
  end

  def isbn_10
    ISBN_Tools.hyphenate_isbn10(self.isbn)
  end

  def isbn_13
    ISBN_Tools.hyphenate_isbn13(ISBN_Tools.isbn10_to_isbn13(self.isbn))
  end
  
  def notify!
    Notifications.deliver_new_book(self)
    self.notification_sent = true
    self.save
  end

  protected
  def must_be_valid_isbn
    errors.add :isbn, 'is invalid' unless ISBN_Tools.is_valid?(self.isbn)
  end

  def cleanup_isbn
    self.isbn = ISBN_Tools.isbn13_to_isbn10(self.isbn) if ISBN_Tools.is_valid_isbn13?(self.isbn)
    self.isbn = ISBN_Tools.cleanup(self.isbn)
  end

  def initialize_from_saxo
    return unless self.name.blank?
    doc = get_saxo_response

    return if doc.nil?
    
    item = doc.at('item')
    if item
      self.name = (item/:title).innerHTML

      (item/:author).each do |author_element|
        name = (author_element/:name).innerHTML
        author = Author.find_or_create_by_name(name)
        self.authors << author unless self.author_ids.include?(author.id)
      end

      self.save
    end

  end

  def initialize_from_amazon
    return unless self.name.blank?
    doc = get_amazon_response
    
    return if doc.nil?

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
      self.publisher = publisher

      (item/:author).each do |author_element|
        name = author_element.innerHTML
        author = Author.find_or_create_by_name(name)
        self.authors << author unless self.author_ids.include?(author.id)
      end

      self.save
    end
  end
  
  def get_amazon_response
    %w(webservices.amazon.com webservices.amazon.co.uk webservices.amazon.de).each do |domain|
      xml = open("http://#{domain}/onca/xml?Service=AWSECommerceService&SubscriptionId=#{AMAZON_CONF['subscription_id']}&Operation=ItemLookup&ResponseGroup=Medium&ItemId=#{self.isbn}").read
      doc = Hpricot.parse(xml)
      return doc if (doc/:item).size > 0
    end
    nil
  end
  
  def get_saxo_response
    xml = open("http://api.saxo.com/v1/ItemService.asmx/FindItem?developerKey=#{SAXO_CONF['developer_key']}&sessionKey=&keyword=#{self.isbn}&keywordType=ISBN")
    doc = Hpricot.parse(xml)
  end
  
  def xml_to_image(xml)
    Image.create do |image|
      image.url = (xml/:url).first.innerHTML
      image.width = (xml/:width).first.innerHTML
      image.height = (xml/:height).first.innerHTML
    end
  rescue
    nil
  end
end
