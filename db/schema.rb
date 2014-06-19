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

ActiveRecord::Schema.define(version: 20140617192507) do

  create_table "activities", force: true do |t|
    t.string   "fromUser"
    t.string   "toUser"
    t.string   "activity_type"
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

  create_table "category_product", id: false, force: true do |t|
    t.integer "product",  null: false
    t.integer "category", null: false
  end

  add_index "category_product", ["category"], name: "category", using: :btree
  add_index "category_product", ["product"], name: "product", using: :btree

  create_table "category_shopstyle_category", id: false, force: true do |t|
    t.integer "category",                       null: false
    t.string  "shopstyle_category", limit: 250, null: false
  end

  create_table "color_palette", id: false, force: true do |t|
    t.integer "r",     null: false
    t.integer "g",     null: false
    t.integer "b",     null: false
    t.integer "color", null: false
  end

  create_table "colors", id: false, force: true do |t|
    t.integer "id",                     null: false
    t.string  "name",       limit: 250, null: false
    t.float   "percentage",             null: false
  end

  add_index "colors", ["id"], name: "id", using: :btree

  create_table "price_log", id: false, force: true do |t|
    t.integer  "product",             null: false
    t.datetime "date",                null: false
    t.string   "currency", limit: 10, null: false
    t.float    "price",               null: false
  end

  add_index "price_log", ["product"], name: "product", using: :btree

  create_table "product_color", id: false, force: true do |t|
    t.integer "product_id",           null: false
    t.integer "color",      limit: 1, null: false
    t.float   "percentage",           null: false
  end

  add_index "product_color", ["color"], name: "color", using: :btree
  add_index "product_color", ["percentage"], name: "percentage", using: :btree
  add_index "product_color", ["product_id"], name: "product_id_2", using: :btree

  create_table "products", force: true do |t|
    t.string   "local_id",                             limit: 256,  default: "-1", null: false
    t.string   "local_image_id",                       limit: 250,  default: "0",  null: false
    t.string   "name",                                 limit: 250,  default: "",   null: false
    t.float    "price",                                             default: 0.0,  null: false
    t.float    "sale_price",                                        default: 0.0,  null: false
    t.integer  "in_sale",                              limit: 1,    default: 0,    null: false
    t.datetime "in_sale_date"
    t.string   "currency",                             limit: 250,  default: "",   null: false
    t.float    "display_price",                                     default: 0.0,  null: false
    t.float    "previous_display_price",                            default: 0.0,  null: false
    t.integer  "shipping_free",                        limit: 1,    default: 0,    null: false
    t.integer  "shipping_price",                                    default: -1,   null: false
    t.integer  "in_stock",                             limit: 1,    default: -1,   null: false
    t.integer  "product_in_api",                       limit: 1,    default: 1,    null: false
    t.integer  "brand",                                             default: -1,   null: false
    t.integer  "retailer_id",                                       default: -1,   null: false
    t.text     "search_tags",                                                      null: false
    t.string   "source",                               limit: 20,   default: "",   null: false
    t.float    "ctr",                                               default: 0.0,  null: false
    t.integer  "likes",                                             default: 0,    null: false
    t.integer  "likes_week",                                        default: 0,    null: false
    t.integer  "likes_local",                                       default: -1,   null: false
    t.integer  "likes_processed",                      limit: 1,    default: 0,    null: false
    t.string   "buy_url",                              limit: 1024, default: "",   null: false
    t.string   "crawler_url",                          limit: 2048
    t.string   "local_page_url",                       limit: 1024, default: "",   null: false
    t.string   "image_url",                            limit: 1024, default: "",   null: false
    t.integer  "width_original",                                    default: -1,   null: false
    t.integer  "height_original",                                   default: -1,   null: false
    t.integer  "width",                                             default: -1,   null: false
    t.integer  "height",                                            default: -1,   null: false
    t.integer  "show_product",                         limit: 1,    default: 0,    null: false
    t.integer  "image_processed",                      limit: 1,    default: 0,    null: false
    t.integer  "image_result",                         limit: 1,    default: -1,   null: false
    t.integer  "image_folder",                                      default: 0,    null: false
    t.string   "image_hash",                           limit: 80,   default: "",   null: false
    t.integer  "image_pure_white",                     limit: 1,    default: 0,    null: false
    t.datetime "palette_processed",                                                null: false
    t.integer  "left_x",                                            default: -1,   null: false
    t.integer  "right_x",                                           default: -1,   null: false
    t.integer  "top_y",                                             default: -1,   null: false
    t.integer  "bottom_y",                                          default: -1,   null: false
    t.integer  "ftp_transfer_processed",               limit: 1,    default: 0,    null: false
    t.datetime "ftp_transfer_datetime",                                            null: false
    t.integer  "ftp_transfer_deleted_source",          limit: 1,    default: 0,    null: false
    t.datetime "ftp_transfer_deleted_source_datetime",                             null: false
    t.integer  "similarity_processed",                 limit: 1,    default: 0,    null: false
    t.integer  "similarity_result",                    limit: 1,    default: -1,   null: false
    t.integer  "manually_processed",                   limit: 1,    default: 0,    null: false
    t.integer  "manually_result",                      limit: 1,    default: -1,   null: false
    t.integer  "active_processed",                     limit: 1,    default: 0,    null: false
    t.integer  "active_result",                        limit: 1,    default: -1,   null: false
    t.integer  "categories_processed",                 limit: 1,    default: 0,    null: false
    t.date     "local_extract_date",                                               null: false
    t.datetime "vigme_inserted",                                                   null: false
    t.datetime "product_updated",                                                  null: false
    t.datetime "crawler_updated"
    t.datetime "url_extractor_updated"
    t.datetime "inStockUpdated"
    t.datetime "inStockUpdated2"
    t.string   "image_s3_file_name"
    t.string   "image_s3_content_type"
    t.integer  "image_s3_file_size"
    t.datetime "image_s3_updated_at"
    t.string   "image_s3_url"
  end

  add_index "products", ["brand"], name: "brand", using: :btree
  add_index "products", ["crawler_url"], name: "crawlerUrl", length: {"crawler_url"=>333}, using: :btree
  add_index "products", ["ctr"], name: "ctr", using: :btree
  add_index "products", ["display_price"], name: "priceCZK", using: :btree
  add_index "products", ["display_price"], name: "priceCZK_2", using: :btree
  add_index "products", ["id", "image_pure_white", "show_product", "display_price"], name: "id+pureWhite+showProduct", unique: true, using: :btree
  add_index "products", ["image_hash"], name: "image_hash", using: :btree
  add_index "products", ["image_pure_white", "show_product", "in_sale"], name: "idx3", using: :btree
  add_index "products", ["image_pure_white", "show_product", "shipping_free"], name: "idx", using: :btree
  add_index "products", ["image_pure_white", "show_product"], name: "idx2", using: :btree
  add_index "products", ["image_pure_white"], name: "image_pure_white", using: :btree
  add_index "products", ["in_sale"], name: "inSale", using: :btree
  add_index "products", ["in_sale_date"], name: "inSaleDate", using: :btree
  add_index "products", ["likes"], name: "likes", using: :btree
  add_index "products", ["likes"], name: "likes_2", using: :btree
  add_index "products", ["local_extract_date"], name: "extractDate", using: :btree
  add_index "products", ["local_id"], name: "localId", using: :btree
  add_index "products", ["product_updated"], name: "shopstyle_updated", using: :btree
  add_index "products", ["retailer_id"], name: "retailerIdIndex", using: :btree
  add_index "products", ["shipping_free"], name: "shipping_free", using: :btree
  add_index "products", ["show_product"], name: "show_product", using: :btree
  add_index "products", ["source"], name: "country", using: :btree
  add_index "products", ["url_extractor_updated"], name: "extractorUpdated", using: :btree

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

  create_table "shopstyle_product_category", id: false, force: true do |t|
    t.integer "product",                          null: false
    t.string  "category", limit: 250,             null: false
    t.integer "original", limit: 1,   default: 0, null: false
  end

  add_index "shopstyle_product_category", ["category"], name: "category", using: :btree
  add_index "shopstyle_product_category", ["category"], name: "category_2", using: :btree
  add_index "shopstyle_product_category", ["category"], name: "category_3", using: :btree
  add_index "shopstyle_product_category", ["product"], name: "product", using: :btree

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

end
