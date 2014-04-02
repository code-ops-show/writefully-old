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

ActiveRecord::Schema.define(version: 20140402091415) do

  create_table "writefully_posts", force: true do |t|
    t.string   "title"
    t.string   "blurb"
    t.text     "content"
    t.string   "type"
    t.string   "slug"
    t.string   "cover"
    t.integer  "position"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "writefully_posts", ["slug"], name: "index_writefully_posts_on_slug", unique: true

  create_table "writefully_taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "writefully_taggings", ["post_id"], name: "index_writefully_taggings_on_post_id"
  add_index "writefully_taggings", ["tag_id"], name: "index_writefully_taggings_on_tag_id"

  create_table "writefully_tags", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "writefully_tags", ["slug"], name: "index_writefully_tags_on_slug", unique: true
  add_index "writefully_tags", ["type"], name: "index_writefully_tags_on_type"

end
