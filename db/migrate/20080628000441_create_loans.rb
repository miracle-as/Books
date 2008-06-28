class CreateLoans < ActiveRecord::Migration
  def self.up
    create_table :loans do |t|
      t.references :user
      t.references :book
      t.datetime :check_out
      t.datetime :check_in
      t.timestamps
    end
  end

  def self.down
    drop_table :loans
  end
end
