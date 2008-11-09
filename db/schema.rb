# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081109141750) do

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorships", :force => true do |t|
    t.integer  "book_id",    :limit => 11
    t.integer  "author_id",  :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorships", ["book_id"], :name => "index_authorships_on_book_id"
  add_index "authorships", ["author_id"], :name => "index_authorships_on_author_id"

  create_table "books", :force => true do |t|
    t.string   "name"
    t.string   "isbn"
    t.integer  "pages",                  :limit => 11
    t.date     "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "amazon_detail_page_url"
    t.integer  "publisher_id",           :limit => 11
    t.integer  "small_image_id",         :limit => 11
    t.integer  "medium_image_id",        :limit => 11
    t.integer  "large_image_id",         :limit => 11
    t.boolean  "notification_sent",                    :default => false
    t.text     "description"
  end

  create_table "images", :force => true do |t|
    t.string   "url"
    t.integer  "width",      :limit => 11
    t.integer  "height",     :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "loans", :force => true do |t|
    t.integer  "user_id",    :limit => 11
    t.integer  "book_id",    :limit => 11
    t.datetime "check_out"
    t.datetime "check_in"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "loans", ["user_id"], :name => "index_loans_on_user_id"
  add_index "loans", ["book_id"], :name => "index_loans_on_book_id"

  create_table "publishers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.string   "keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["keywords"], :name => "index_searches_on_keywords"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",        :limit => 11
    t.integer  "taggable_id",   :limit => 11
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
    t.integer  "tagger_id",     :limit => 11
    t.string   "tagger_type"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login",      :limit => 40
    t.string   "name",       :limit => 100, :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                     :default => false
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
