class RemoveRestfulAuthenticationFields < ActiveRecord::Migration
  def self.up
    remove_column :users, :crypted_password
    remove_column :users, :salt
    remove_column :users, :remember_token
    remove_column :users, :remember_token_expires_at
    remove_column :users, :email
  end

  def self.down
  end
end
