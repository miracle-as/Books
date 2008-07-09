class AddIndexesToAuthorships < ActiveRecord::Migration
  def self.up
    add_index :authorships, :book_id
    add_index :authorships, :author_id
  end

  def self.down
    remove_index :authorships, :author_id
    remove_index :authorships, :book_id
  end
end
