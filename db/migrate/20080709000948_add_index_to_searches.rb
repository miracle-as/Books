class AddIndexToSearches < ActiveRecord::Migration
  def self.up
    add_index :searches, :keywords
  end

  def self.down
    remove_index :searches, :keywords
  end
end
