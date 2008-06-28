class CreatePublishers < ActiveRecord::Migration
  def self.up
    create_table :publishers do |t|
      t.string :name

      t.timestamps
    end
    
    add_column :books, :publisher_id, :integer
  end

  def self.down
    remove_column :books, :publisher_id
    drop_table :publishers
  end
end
