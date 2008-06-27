class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :url
      t.integer :width
      t.integer :height

      t.timestamps
    end
    
    remove_column :books, :small_image_url
    remove_column :books, :medium_image_url
    remove_column :books, :large_image_url
    
    add_column :books, :small_image_id, :integer
    add_column :books, :medium_image_id, :integer
    add_column :books, :large_image_id, :integer
  end

  def self.down
    remove_column :books, :large_image_id
    remove_column :books, :medium_image_id
    remove_column :books, :small_image_id
    add_column :books, :large_image_url, :string
    add_column :books, :medium_image_url, :string
    add_column :books, :small_image_url, :string
    drop_table :images
  end
end
