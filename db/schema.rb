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

ActiveRecord::Schema.define(version: 20150115163953) do

  create_table "activities", force: true do |t|
    t.string   "fromUser"
    t.string   "toUser"
    t.string   "activity_type"
    t.string   "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "list_id"
    t.text     "purchase_url"
    t.integer  "confirmed"
    t.string   "receipt_file_name"
    t.string   "receipt_content_type"
    t.integer  "receipt_file_size"
    t.datetime "receipt_updated_at"
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
    t.integer "product_id",  null: false
    t.integer "category_id", null: false
    t.integer "post_id"
  end

  add_index "category_product", ["category_id"], name: "category", using: :btree
  add_index "category_product", ["product_id"], name: "product", using: :btree

  create_table "category_shopstyle_category", id: false, force: true do |t|
    t.integer "category",                       null: false
    t.string  "shopstyle_category", limit: 250, null: false
  end

  create_table "celebrities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "celebrity_type"
    t.integer  "user_id"
  end

  create_table "celebrity_products", force: true do |t|
    t.text     "url"
    t.string   "source_url"
    t.integer  "celebrity_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "available",    default: -1
  end

  create_table "chats", force: true do |t|
    t.integer  "user_1"
    t.integer  "user_2"
    t.string   "post_id"
    t.integer  "complete"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "keywords", force: true do |t|
    t.string   "word"
    t.integer  "retailer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lists", force: true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log", force: true do |t|
    t.integer  "user",                    null: false
    t.string   "action",      limit: 20,  null: false
    t.string   "description", limit: 250, null: false
    t.datetime "date",                    null: false
  end

  create_table "messages", force: true do |t|
    t.integer  "chat_id"
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.text     "description"
    t.decimal  "price",              precision: 10, scale: 0
    t.integer  "user_id"
    t.integer  "sold",                                        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "name"
  end

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
    t.string   "extractor_url",                        limit: 2048
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
  add_index "products", ["ctr"], name: "ctr", using: :btree
  add_index "products", ["display_price"], name: "priceCZK", using: :btree
  add_index "products", ["display_price"], name: "priceCZK_2", using: :btree
  add_index "products", ["extractor_url"], name: "crawlerUrl", length: {"extractor_url"=>255}, using: :btree
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
  add_index "products", ["local_id"], name: "localId", length: {"local_id"=>255}, using: :btree
  add_index "products", ["product_updated"], name: "shopstyle_updated", using: :btree
  add_index "products", ["retailer_id"], name: "retailerIdIndex", using: :btree
  add_index "products", ["shipping_free"], name: "shipping_free", using: :btree
  add_index "products", ["show_product"], name: "show_product", using: :btree
  add_index "products", ["source"], name: "country", using: :btree
  add_index "products", ["url_extractor_updated"], name: "extractorUpdated", using: :btree

  create_table "rankings", force: true do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.string   "time_period"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "retailers", force: true do |t|
    t.integer "local_id",                               default: 0,   null: false
    t.text    "name",                                                 null: false
    t.text    "url",                                                  null: false
    t.text    "local_url",                                            null: false
    t.integer "shipping_free",               limit: 1,  default: 0,   null: false
    t.integer "shipping_free_minimum_price",            default: 0,   null: false
    t.float   "shipping_price",                         default: 0.0, null: false
    t.string  "source",                      limit: 30,               null: false
    t.integer "active",                      limit: 1,  default: 1,   null: false
    t.integer "claimed"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

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
    t.string   "email"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "gender"
    t.integer  "admin"
    t.integer  "active"
    t.integer  "retailer_id"
    t.integer  "user_type"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "signup_process",         default: 0
    t.string   "preference"
    t.string   "authentication_token"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree

end
