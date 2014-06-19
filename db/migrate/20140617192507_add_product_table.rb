class AddProductTable < ActiveRecord::Migration
  def change
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

  end
end
