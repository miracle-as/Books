class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.name :string
      t.isbn :string
      t.pages :integer
      t.published :date

      t.timestamps
    end
  end

  def self.down
    drop_table :books
  end
end
