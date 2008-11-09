class AddDescriptionToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :description, :text
  end

  def self.down
    remove_column :books, :description
  end
end
