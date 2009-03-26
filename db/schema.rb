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

ActiveRecord::Schema.define(:version => 20090326071601) do

  create_table "categories", :force => true do |t|
    t.integer "parent_id"
    t.string  "title"
    t.text    "description"
    t.string  "navigation"
    t.string  "photo"
    t.string  "category_type"
  end

  create_table "category_fields", :force => true do |t|
    t.integer "category_id"
    t.string  "name"
    t.string  "field_type"
    t.text    "collection"
  end

  create_table "event_logs", :force => true do |t|
    t.integer  "user_id"
    t.string   "action"
    t.text     "content"
    t.string   "ip_address"
    t.string   "user_agent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_photos", :force => true do |t|
    t.integer  "event_id"
    t.string   "title"
    t.string   "photo"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_versions", :force => true do |t|
    t.integer  "event_id"
    t.integer  "version"
    t.integer  "location_id"
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.date     "date_start"
    t.date     "date_end"
    t.time     "time_start"
    t.time     "time_end"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "event_versions", ["event_id"], :name => "index_event_versions_on_event_id"

  create_table "events", :force => true do |t|
    t.integer  "location_id"
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.date     "date_start"
    t.date     "date_end"
    t.time     "time_start"
    t.time     "time_end"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
    t.integer  "version"
  end

  create_table "events_categories", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "category_id"
  end

  create_table "events_tags", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "tag_id"
  end

  create_table "events_users", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "user_id"
  end

  create_table "feedbacks", :force => true do |t|
    t.integer  "location_id"
    t.integer  "event_id"
    t.integer  "user_id"
    t.text     "content"
    t.integer  "rank"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "location_regions", :force => true do |t|
    t.integer  "location_id"
    t.decimal  "lat",         :precision => 20, :scale => 16
    t.decimal  "lng",         :precision => 20, :scale => 16
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "location_versions", :force => true do |t|
    t.integer  "location_id"
    t.integer  "version"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.string   "title"
    t.text     "description"
    t.decimal  "lat",             :precision => 20, :scale => 16
    t.decimal  "lng",             :precision => 20, :scale => 16
    t.string   "city"
    t.string   "province"
    t.string   "country"
    t.string   "status"
    t.text     "additional_info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
    t.string   "address"
  end

  add_index "location_versions", ["location_id"], :name => "index_location_versions_on_location_id"

  create_table "locations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "parent_id"
    t.string   "title"
    t.text     "description"
    t.decimal  "lat",             :precision => 20, :scale => 16
    t.decimal  "lng",             :precision => 20, :scale => 16
    t.string   "city"
    t.string   "province"
    t.string   "country"
    t.string   "status"
    t.text     "additional_info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
    t.string   "address"
    t.integer  "version"
  end

  create_table "locations_categories", :id => false, :force => true do |t|
    t.integer "location_id"
    t.integer "category_id"
  end

  create_table "locations_tags", :id => false, :force => true do |t|
    t.integer "location_id"
    t.integer "tag_id"
  end

  create_table "messages", :force => true do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.string   "title"
    t.text     "content"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.integer  "event_id"
    t.string   "album_type"
    t.string   "photo_url"
    t.string   "original_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.integer  "user_id"
    t.string   "object_type"
    t.integer  "object_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.string   "keyword"
    t.string   "permalink"
    t.text     "sorted_by_relevance"
    t.text     "sorted_by_added"
    t.text     "sorted_by_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "displayname"
    t.string   "city"
    t.string   "province"
    t.string   "country"
    t.string   "status"
    t.string   "activation_key"
    t.datetime "activated_at"
    t.string   "password_reset_key"
    t.date     "last_logged_in"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auto_login_hash"
  end

  create_table "users_friends", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "friend_id"
  end

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "votable_id"
    t.string   "votable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "score"
  end

end
