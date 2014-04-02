# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140402073702) do

  create_table "posts", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "content"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"

  create_table "tags", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["slug"], name: "index_tags_on_slug", unique: true
  add_index "tags", ["type"], name: "index_tags_on_type"

end
