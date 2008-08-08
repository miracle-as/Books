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
  after_save :initialize_from_webservices

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

  def load_from_webservices!
    return true if initialize_from_amazon
    initialize_from_saxo
  end

  protected
  def must_be_valid_isbn
    errors.add :isbn, 'is invalid' unless ISBN_Tools.is_valid?(self.isbn)
  end

  def cleanup_isbn
    self.isbn = ISBN_Tools.isbn13_to_isbn10(self.isbn) if ISBN_Tools.is_valid_isbn13?(self.isbn)
    self.isbn = ISBN_Tools.cleanup(self.isbn)
  end
  
  # Called on after_save and only runs if necessary
  def initialize_from_webservices
    return unless self.name.blank?
    load_from_webservices!
  end

  def initialize_from_saxo
    doc = get_saxo_response

    return false if doc.nil?
    
    item = doc.at('itemdata')
    if item
      self.name = (item/:title).innerHTML
      self.pages = (item/:pagecount).innerHTML
      self.published = (item/:releasedate).innerHTML

      item_id = (item/:id).first.innerHTML
      self.small_image = Image.create(:url => "http://images.saxo.com/ItemImage.aspx?ItemID=#{item_id}&Height=75", :height => 75)
      self.medium_image = Image.create(:url => "http://images.saxo.com/ItemImage.aspx?ItemID=#{item_id}&Height=160", :height => 160)
      
      publisher = ((item/:publisher)/:name).innerHTML
      publisher = Publisher.find_or_create_by_name(publisher)
      self.publisher = publisher

      (item/:author).each do |author_element|
        name = (author_element/:name).innerHTML
        author = Author.find_or_create_by_name(name)
        self.authors << author unless self.author_ids.include?(author.id)
      end

      self.save
      return true
    end
    false
  end

  def initialize_from_amazon
    doc = get_amazon_response
    
    return false if doc.nil?

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
      return true
    end
    false
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
    # First we look up the item id using the isbn number
    xml = open("http://api.saxo.com/v1/ItemService.asmx/FindItem?developerKey=#{SAXO_CONF['developer_key']}&sessionKey=&keyword=#{self.isbn}&keywordType=ISBN")
    doc = Hpricot.parse(xml)

    return if doc.nil?
    item_id = (doc/"itemresult/items/item/id").innerHTML
    
    # Then we look up the details
    detail_url = "http://api.saxo.com/v1/ItemService.asmx/GetItemData?developerKey=#{SAXO_CONF['developer_key']}&sessionKey=&itemId=#{item_id}"
    begin
      xml = open(detail_url)
      doc = Hpricot.parse(xml)
    rescue
      logger.debug { "SAXO call failed: #{detail_url}" }
      logger.debug { "from response:\n#{doc}" }
      return nil
    end 
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
