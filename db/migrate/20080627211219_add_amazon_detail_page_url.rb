class AddAmazonDetailPageUrl < ActiveRecord::Migration
  def self.up
    add_column :books, :amazon_detail_page_url, :string
  end

  def self.down
    remove_column :books, :amazon_detail_page_url
  end
end