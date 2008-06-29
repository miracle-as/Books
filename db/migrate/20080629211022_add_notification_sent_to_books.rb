class AddNotificationSentToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :notification_sent, :boolean, :default => false
  end

  def self.down
    remove_column :books, :notification_sent
  end
end
