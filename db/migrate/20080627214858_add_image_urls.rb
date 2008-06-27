class AddImageUrls < ActiveRecord::Migration
  def self.up
    add_column :books, :small_image_url, :string
    add_column :books, :medium_image_url, :string
    add_column :books, :large_image_url, :string
  end

  def self.down
    remove_column :books, :large_image_url
    remove_column :books, :medium_image_url
    remove_column :books, :small_image_url
  end
end
