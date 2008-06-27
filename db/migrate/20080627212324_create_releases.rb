class CreateReleases < ActiveRecord::Migration
  def self.up
    create_table :releases do |t|
      t.references :publisher
      t.references :book
      t.timestamps
    end
  end

  def self.down
    drop_table :releases
  end
end
