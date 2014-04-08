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

ActiveRecord::Schema.define(version: 20140403181629) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "writefully_authorships", force: true do |t|
    t.integer  "user_id"
    t.hstore   "data"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "writefully_authorships", ["site_id"], name: "index_writefully_authorships_on_site_id", using: :btree
  add_index "writefully_authorships", ["user_id"], name: "index_writefully_authorships_on_user_id", using: :btree

  create_table "writefully_posts", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.string   "type"
    t.text     "content"
    t.hstore   "details"
    t.datetime "published_at"
    t.integer  "position"
    t.string   "locale",                default: "en"
    t.integer  "translation_source_id"
    t.integer  "site_id"
    t.integer  "authorship_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "writefully_posts", ["authorship_id"], name: "index_writefully_posts_on_authorship_id", using: :btree
  add_index "writefully_posts", ["site_id"], name: "index_writefully_posts_on_site_id", using: :btree
  add_index "writefully_posts", ["slug"], name: "index_writefully_posts_on_slug", unique: true, using: :btree
  add_index "writefully_posts", ["translation_source_id"], name: "index_writefully_posts_on_translation_source_id", using: :btree

  create_table "writefully_sites", force: true do |t|
    t.string   "name"
    t.string   "access_token"
    t.string   "branch",       default: "master"
    t.hstore   "repository"
    t.string   "domain"
    t.boolean  "processing"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "writefully_sites", ["owner_id"], name: "index_writefully_sites_on_owner_id", using: :btree
  add_index "writefully_sites", ["repository"], name: "index_writefully_sites_on_repository", using: :gin

  create_table "writefully_taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "writefully_taggings", ["post_id"], name: "index_writefully_taggings_on_post_id", using: :btree
  add_index "writefully_taggings", ["tag_id"], name: "index_writefully_taggings_on_tag_id", using: :btree

  create_table "writefully_tags", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "writefully_tags", ["slug"], name: "index_writefully_tags_on_slug", unique: true, using: :btree
  add_index "writefully_tags", ["type"], name: "index_writefully_tags_on_type", using: :btree

end
