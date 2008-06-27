class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string :name
      t.string :isbn
      t.integer :pages
      t.date :published

      t.timestamps
    end
  end

  def self.down
    drop_table :books
  end
end
