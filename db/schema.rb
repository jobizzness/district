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

ActiveRecord::Schema.define(version: 20170129001544) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "articles", force: :cascade do |t|
    t.string   "title",            limit: 255,                 null: false
    t.text     "text",             limit: 65535,               null: false
    t.text     "text_short",       limit: 65535,               null: false
    t.string   "anchor",           limit: 255,                 null: false
    t.datetime "date",                                         null: false
    t.integer  "parent",           limit: 4,                   null: false
    t.integer  "priv",             limit: 4,                   null: false
    t.integer  "fb_reposts",       limit: 4,     default: 0,   null: false
    t.integer  "gp_reposts",       limit: 4,     default: 0,   null: false
    t.integer  "in_reposts",       limit: 4,     default: 0,   null: false
    t.integer  "tw_reposts",       limit: 4,     default: 0,   null: false
    t.float    "rating",           limit: 24,    default: 0.0, null: false
    t.string   "pic_file_name",    limit: 255
    t.integer  "pic_file_size",    limit: 4
    t.string   "pic_content_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles_cats", force: :cascade do |t|
    t.string  "title",            limit: 255,   null: false
    t.text    "text",             limit: 65535, null: false
    t.string  "anchor",           limit: 255,   null: false
    t.integer "priv",             limit: 4,     null: false
    t.string  "pic_file_name",    limit: 255
    t.integer "pic_file_size",    limit: 4
    t.string  "pic_content_type", limit: 255
  end

  create_table "articles_companies_connections", force: :cascade do |t|
    t.integer "id_article",  limit: 4,             null: false
    t.integer "id_company",  limit: 4,             null: false
    t.integer "connections", limit: 4, default: 1, null: false
  end

  create_table "articles_connections", force: :cascade do |t|
    t.integer "id_article1", limit: 4,             null: false
    t.integer "id_article2", limit: 4,             null: false
    t.integer "connections", limit: 4, default: 1, null: false
  end

  create_table "articles_pics", force: :cascade do |t|
    t.text    "text",              limit: 65535, null: false
    t.integer "parent",            limit: 4,     null: false
    t.integer "priv",              limit: 4,     null: false
    t.string  "path_file_name",    limit: 255
    t.integer "path_file_size",    limit: 4
    t.string  "path_content_type", limit: 255
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "attachment_file_name",    limit: 255
    t.integer  "attachment_file_size",    limit: 4
    t.string   "attachment_content_type", limit: 255
    t.integer  "project_id",              limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["project_id"], name: "index_attachments_on_project_id", using: :btree

  create_table "bids", force: :cascade do |t|
    t.string   "logo_file_name",           limit: 255
    t.string   "logo_file_size",           limit: 255
    t.string   "logo_content_type",        limit: 255
    t.string   "product_description",      limit: 255
    t.string   "factory_name",             limit: 255
    t.string   "factory_expirience",       limit: 255
    t.string   "email",                    limit: 255
    t.string   "moq_per_style",            limit: 255
    t.string   "moq_per_order",            limit: 255
    t.integer  "max_amount_colors",        limit: 4
    t.text     "total_sample_pricing",     limit: 65535
    t.decimal  "cost_sample_shipping",                   precision: 9, scale: 2
    t.decimal  "production_shipping_cost",               precision: 9, scale: 2
    t.text     "production_cost",          limit: 65535
    t.string   "lead_time_samples",        limit: 255
    t.string   "lead_time_production",     limit: 255
    t.text     "additional_info",          limit: 65535
    t.text     "payment_term_production",  limit: 65535
    t.integer  "project_id",               limit: 4
    t.string   "pdf_file_name",            limit: 255
    t.string   "pdf_file_size",            limit: 255
    t.string   "pdf_content_type",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "factory_location",         limit: 255
    t.string   "website_address",          limit: 255
    t.integer  "user_id",                  limit: 4
    t.integer  "win_id",                   limit: 4
    t.integer  "total_price",              limit: 4,                             default: 0
    t.string   "resource_id",              limit: 255
    t.boolean  "is_revised",               limit: 1,                             default: false
  end

  add_index "bids", ["project_id"], name: "index_bids_on_project_id", using: :btree

  create_table "bootsy_image_galleries", force: :cascade do |t|
    t.integer  "bootsy_resource_id",   limit: 4
    t.string   "bootsy_resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: :cascade do |t|
    t.string   "image_file",       limit: 255
    t.integer  "image_gallery_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: :cascade do |t|
    t.string  "name",             limit: 255, null: false
    t.string  "pic_old",          limit: 255, null: false
    t.integer "parent",           limit: 4,   null: false
    t.string  "pic_file_name",    limit: 255
    t.string  "pic_file_size",    limit: 255
    t.string  "pic_content_type", limit: 255
  end

  create_table "categories_connections", force: :cascade do |t|
    t.integer "category_id",    limit: 4, null: false
    t.integer "subcategory_id", limit: 4, null: false
  end

  create_table "chat_messages", force: :cascade do |t|
    t.text     "body",       limit: 65535
    t.integer  "bid_id",     limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "chat_messages", ["bid_id"], name: "index_chat_messages_on_bid_id", using: :btree
  add_index "chat_messages", ["user_id"], name: "index_chat_messages_on_user_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name",                limit: 255,                    null: false
    t.string   "address",             limit: 255,                    null: false
    t.string   "address1",            limit: 255,   default: "",     null: false
    t.string   "address2",            limit: 255,   default: "",     null: false
    t.string   "zip",                 limit: 20,    default: "",     null: false
    t.string   "city",                limit: 255,   default: "",     null: false
    t.string   "state",               limit: 255,   default: "",     null: false
    t.string   "country",             limit: 4,     default: "",     null: false
    t.string   "phone",               limit: 255,   default: "",     null: false
    t.string   "email",               limit: 255,   default: "",     null: false
    t.string   "website",             limit: 255,   default: "",     null: false
    t.string   "twitter",             limit: 255,   default: "",     null: false
    t.string   "facebook",            limit: 255,   default: "",     null: false
    t.string   "instagram",           limit: 255,   default: "",     null: false
    t.string   "pinterest",           limit: 255,   default: "",     null: false
    t.text     "description",         limit: 65535
    t.string   "avatar_old",          limit: 255,   default: "",     null: false
    t.string   "logo_old",            limit: 255,   default: "",     null: false
    t.string   "x",                   limit: 255,   default: "",     null: false
    t.string   "y",                   limit: 255,   default: "",     null: false
    t.integer  "zoom",                limit: 4,     default: 0,      null: false
    t.integer  "fb_reposts",          limit: 4,     default: 0,      null: false
    t.integer  "tw_reposts",          limit: 4,     default: 0,      null: false
    t.integer  "gp_reposts",          limit: 4,     default: 0,      null: false
    t.integer  "in_reposts",          limit: 4,     default: 0,      null: false
    t.datetime "date",                                               null: false
    t.text     "search",              limit: 65535
    t.string   "available",           limit: 255,   default: "0000", null: false
    t.string   "cats",                limit: 255,   default: "",     null: false
    t.string   "brief",               limit: 255,   default: "",     null: false
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_file_size",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.string   "logo_file_name",      limit: 255
    t.string   "logo_file_size",      limit: 255
    t.string   "logo_content_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "search_all",          limit: 65535
    t.string   "class_type",          limit: 255
  end

  create_table "companies_categories_connections", force: :cascade do |t|
    t.integer "company_id",  limit: 4, null: false
    t.integer "category_id", limit: 4, null: false
  end

  create_table "companies_pics", force: :cascade do |t|
    t.integer "id_company",       limit: 4,                null: false
    t.string  "pic_old",          limit: 255, default: "", null: false
    t.integer "position",         limit: 4,   default: 0,  null: false
    t.string  "pic_file_name",    limit: 255
    t.string  "pic_file_size",    limit: 255
    t.string  "pic_content_type", limit: 255
  end

  create_table "companies_subcategories_connections", force: :cascade do |t|
    t.integer "company_id",     limit: 4, null: false
    t.integer "subcategory_id", limit: 4, null: false
  end

  create_table "companies_tags_connections", force: :cascade do |t|
    t.integer "id_company", limit: 4, null: false
    t.integer "id_tag",     limit: 4, null: false
  end

  create_table "cont", force: :cascade do |t|
    t.integer  "author_id", limit: 4,     null: false
    t.text     "txt",       limit: 65535, null: false
    t.text     "dsc",       limit: 65535, null: false
    t.datetime "dt_edit",                 null: false
    t.string   "pos",       limit: 60,    null: false
    t.integer  "priv",      limit: 4,     null: false
  end

  add_index "cont", ["pos"], name: "pos", using: :btree

  create_table "countries", primary_key: "code", force: :cascade do |t|
    t.string "country", limit: 255, null: false
  end

  create_table "ctrl", force: :cascade do |t|
    t.string  "nm",       limit: 30,              null: false
    t.string  "val",      limit: 255,             null: false
    t.string  "txt",      limit: 255,             null: false
    t.integer "tp",       limit: 4,               null: false
    t.integer "disabled", limit: 4,   default: 0, null: false
    t.integer "priv",     limit: 4,               null: false
    t.integer "parent",   limit: 4,               null: false
  end

  create_table "ctrl_parts", force: :cascade do |t|
    t.string  "tit",  limit: 100,             null: false
    t.integer "priv", limit: 4,   default: 0, null: false
  end

  create_table "info_pages", force: :cascade do |t|
    t.string   "tit",        limit: 150,   null: false
    t.text     "text",       limit: 65535, null: false
    t.string   "trans",      limit: 150,   null: false
    t.datetime "dt_created",               null: false
    t.datetime "dt_edited",                null: false
    t.integer  "locked",     limit: 4,     null: false
    t.integer  "numviews",   limit: 4,     null: false
  end

  create_table "managers", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "managers", ["email"], name: "index_managers_on_email", unique: true, using: :btree
  add_index "managers", ["reset_password_token"], name: "index_managers_on_reset_password_token", unique: true, using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.integer  "amount",     limit: 4,   default: 0
    t.integer  "user_id",    limit: 4
    t.integer  "bid_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["bid_id"], name: "index_orders_on_bid_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "page_info", force: :cascade do |t|
    t.string  "title",       limit: 255,   null: false
    t.text    "keywords",    limit: 65535, null: false
    t.text    "description", limit: 65535, null: false
    t.string  "pos",         limit: 150,   null: false
    t.integer "author",      limit: 4,     null: false
  end

  create_table "press", force: :cascade do |t|
    t.string  "title",            limit: 255, null: false
    t.string  "pic_old",          limit: 255, null: false
    t.string  "link",             limit: 255, null: false
    t.integer "priv",             limit: 4,   null: false
    t.string  "pic_file_name",    limit: 255
    t.string  "pic_file_size",    limit: 255
    t.string  "pic_content_type", limit: 255
  end

  create_table "projects", force: :cascade do |t|
    t.string   "pdf_file_name",    limit: 255
    t.string   "pdf_file_size",    limit: 255
    t.string   "pdf_content_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",          limit: 4
    t.datetime "available_to"
    t.integer  "status",           limit: 4,   default: 0
    t.integer  "count_of_bids",    limit: 4,   default: 0
  end

  create_table "recover", force: :cascade do |t|
    t.integer  "id_user",  limit: 4,              null: false
    t.string   "token",    limit: 32,             null: false
    t.datetime "date",                            null: false
    t.integer  "finished", limit: 4,  default: 0, null: false
  end

  create_table "reserved", force: :cascade do |t|
    t.string "address", limit: 255, null: false
  end

  add_index "reserved", ["address"], name: "address", using: :btree

  create_table "shipment_photos", force: :cascade do |t|
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
    t.integer  "bid_id",            limit: 4
    t.integer  "chat_message_id",   limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "shipment_photos", ["bid_id"], name: "index_shipment_photos_on_bid_id", using: :btree
  add_index "shipment_photos", ["chat_message_id"], name: "index_shipment_photos_on_chat_message_id", using: :btree

  create_table "step1s", force: :cascade do |t|
    t.string   "overall_of_budget", limit: 255
    t.string   "business_type",     limit: 255
    t.integer  "project_id",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "hash_tags",         limit: 65535
  end

  add_index "step1s", ["project_id"], name: "index_step1s_on_project_id", using: :btree

  create_table "step2s", force: :cascade do |t|
    t.string   "type_of_product",      limit: 255
    t.integer  "samples_number",       limit: 4
    t.datetime "samples_date"
    t.string   "how_many_styles",      limit: 255
    t.string   "units_per_style",      limit: 255
    t.string   "made_in_country",      limit: 255
    t.datetime "completion_date"
    t.integer  "project_id",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "fabrics",              limit: 65535
    t.text     "artwork",              limit: 65535
    t.string   "number_of_color_ways", limit: 255
    t.string   "size_range",           limit: 255
    t.string   "desired_trims",        limit: 255
    t.string   "made_production",      limit: 255
    t.string   "distribution",         limit: 255
  end

  add_index "step2s", ["project_id"], name: "index_step2s_on_project_id", using: :btree

  create_table "step3s", force: :cascade do |t|
    t.boolean  "check_type_branding",           limit: 1,     default: false
    t.boolean  "check_type_creative_direction", limit: 1,     default: false
    t.boolean  "check_type_design",             limit: 1,     default: false
    t.boolean  "check_type_technical_design",   limit: 1,     default: false
    t.boolean  "check_type_sampling",           limit: 1,     default: false
    t.boolean  "check_type_production",         limit: 1,     default: false
    t.boolean  "check_type_website",            limit: 1,     default: false
    t.boolean  "check_type_social",             limit: 1,     default: false
    t.text     "additional_info",               limit: 65535
    t.integer  "project_id",                    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "step3s", ["project_id"], name: "index_step3s_on_project_id", using: :btree

  create_table "step4s", force: :cascade do |t|
    t.string   "contact_full_name", limit: 255
    t.string   "contact_phone",     limit: 255
    t.string   "contact_email",     limit: 255
    t.string   "contact_city",      limit: 255
    t.string   "contact_state",     limit: 255
    t.string   "contact_zip",       limit: 255
    t.integer  "project_id",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "step4s", ["project_id"], name: "index_step4s_on_project_id", using: :btree

  create_table "subcategories", force: :cascade do |t|
    t.string  "name",    limit: 255, null: false
    t.integer "type_id", limit: 4,   null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name",  limit: 255,             null: false
    t.integer "count", limit: 4,   default: 1, null: false
  end

  add_index "tags", ["name"], name: "name", unique: true, using: :btree

  create_table "tags_connections", force: :cascade do |t|
    t.integer "id_article", limit: 4, null: false
    t.integer "id_tag",     limit: 4, null: false
  end

  create_table "tariffs", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.text     "description",     limit: 65535
    t.float    "price_per_month", limit: 24,    default: 0.0
    t.integer  "duration",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_members", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.text     "about",              limit: 65535
    t.string   "post",               limit: 255
    t.string   "link_fb",            limit: 255
    t.string   "link_li",            limit: 255
    t.string   "link_tw",            limit: 255
    t.string   "link_in",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size",    limit: 4
    t.datetime "photo_updated_at"
  end

  create_table "usa_states", force: :cascade do |t|
    t.string "code", limit: 2,   null: false
    t.string "name", limit: 250, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255,                null: false
    t.string   "email",                  limit: 255,                null: false
    t.string   "facebook",               limit: 30
    t.string   "linkedin",               limit: 30
    t.datetime "date",                                              null: false
    t.string   "encrypted_password",     limit: 255,   default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "google",                 limit: 255
    t.integer  "maker_type",             limit: 4
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.integer  "tariff_id",              limit: 4,     default: 0
    t.datetime "start_tariff_at"
    t.string   "external_customer_id",   limit: 255
    t.string   "stripe_publishable_key", limit: 255
    t.string   "stripe_secret_key",      limit: 255
    t.string   "stripe_user_id",         limit: 255
    t.text     "stripe_account_status",  limit: 65535
    t.string   "stripe_currency",        limit: 255
  end

  create_table "users_connections", force: :cascade do |t|
    t.integer "user_id",    limit: 4, null: false
    t.integer "company_id", limit: 4, null: false
  end

  create_table "wins", force: :cascade do |t|
    t.integer  "project_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wins", ["project_id"], name: "index_wins_on_project_id", using: :btree

end
