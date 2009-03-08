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

ActiveRecord::Schema.define(:version => 20090307114640) do

  create_table "apis", :force => true do |t|
    t.integer  "data_group_id"
    t.string   "description"
    t.string   "type"
    t.text     "method_specs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_groups", :force => true do |t|
    t.text     "description"
    t.string   "name"
    t.string   "icon_file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_points", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.text     "link"
    t.integer  "api_id"
    t.integer  "scraper_id"
    t.string   "entity_type"
    t.text     "additional_links"
    t.text     "data_summary"
    t.text     "original_data"
    t.decimal  "lng",              :precision => 15, :scale => 10
    t.decimal  "lat",              :precision => 15, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scraper_tasks", :force => true do |t|
    t.string   "name"
    t.integer  "scraper_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scrapers", :force => true do |t|
    t.integer  "data_group_id"
    t.string   "name"
    t.string   "namespace"
    t.text     "script"
    t.integer  "default_scraper_task_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
