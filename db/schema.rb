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

ActiveRecord::Schema.define(version: 20140609215320) do

  create_table "activities", force: true do |t|
    t.string   "fromUser"
    t.string   "toUser"
    t.string   "type"
    t.string   "product"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brands", force: true do |t|
    t.integer "local_id",                   null: false
    t.string  "name",           limit: 250, null: false
    t.string  "seo_name",       limit: 250, null: false
    t.string  "source",         limit: 20,  null: false
    t.string  "url",            limit: 250, null: false
    t.text    "synonyms",                   null: false
    t.integer "products_count",             null: false
  end

  add_index "brands", ["local_id"], name: "local_id", using: :btree
  add_index "brands", ["name"], name: "name", using: :btree

  create_table "categories", force: true do |t|
    t.integer "parent",               null: false
    t.string  "name",     limit: 250, null: false
    t.string  "seo_name", limit: 50,  null: false
    t.string  "synonyms", limit: 250, null: false
  end

  add_index "categories", ["parent"], name: "parent", using: :btree

  create_table "category_shopstyle_category", id: false, force: true do |t|
    t.integer "category",                       null: false
    t.string  "shopstyle_category", limit: 250, null: false
  end

  create_table "retailers", force: true do |t|
    t.integer "local_id",                                             null: false
    t.text    "name",                                                 null: false
    t.text    "url",                                                  null: false
    t.text    "local_url",                                            null: false
    t.integer "shipping_free",               limit: 1,  default: 0,   null: false
    t.integer "shipping_free_minimum_price",                          null: false
    t.float   "shipping_price",                         default: 0.0, null: false
    t.string  "source",                      limit: 30,               null: false
    t.integer "active",                      limit: 1,  default: 1,   null: false
  end

  create_table "shopstyle_categories", id: false, force: true do |t|
    t.string  "id",        limit: 250,      null: false
    t.string  "parent_id", limit: 250,      null: false
    t.text    "name",      limit: 16777215, null: false
    t.string  "source",    limit: 20,       null: false
    t.integer "active",    limit: 1,        null: false
  end

  add_index "shopstyle_categories", ["id"], name: "id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end