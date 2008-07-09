class AddIndexesToLoans < ActiveRecord::Migration
  def self.up
    add_index :loans, :user_id
    add_index :loans, :book_id
  end

  def self.down
    remove_index :loans, :book_id
    remove_index :loans, :user_id
  end
end
