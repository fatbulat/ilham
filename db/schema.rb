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

ActiveRecord::Schema.define(version: 20150425173107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string   "title",                       null: false
    t.string   "description"
    t.string   "picture"
    t.text     "body",                        null: false
    t.integer  "user_id",                     null: false
    t.integer  "category_id"
    t.boolean  "published",   default: false, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "author"
    t.string   "source"
  end

  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "episodes", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "body"
    t.integer  "fiction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "episodes", ["fiction_id"], name: "index_episodes_on_fiction_id", using: :btree

  create_table "fictions", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "body"
    t.integer  "genre_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price",                  precision: 8, scale: 2
    t.string   "cover",      limit: 255
  end

  create_table "genres", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "genres", ["name"], name: "index_genres_on_name", unique: true, using: :btree

  create_table "gifts", force: :cascade do |t|
    t.integer  "presentee_id",                 null: false
    t.integer  "present_id",                   null: false
    t.boolean  "paid",         default: false, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "user_id"
  end

  add_index "gifts", ["presentee_id", "present_id"], name: "index_gifts_on_presentee_id_and_present_id", unique: true, using: :btree
  add_index "gifts", ["presentee_id"], name: "index_gifts_on_presentee_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.string   "operator",     limit: 255
    t.string   "paymentType",  limit: 255
    t.string   "phone",        limit: 12
    t.string   "sign",         limit: 255
    t.decimal  "profit",                   precision: 10, scale: 4
    t.decimal  "sum",                      precision: 10, scale: 4
    t.integer  "unitpayId"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",       limit: 255
    t.integer  "payable_id"
    t.string   "payable_type"
  end

  add_index "payments", ["payable_type", "payable_id"], name: "index_payments_on_payable_type_and_payable_id", using: :btree
  add_index "payments", ["unitpayId"], name: "index_payments_on_unitpayId", unique: true, using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "cover",       limit: 255
    t.text     "description"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer  "reader_id"
    t.integer  "fiction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "paid",       default: false, null: false
  end

  add_index "purchases", ["fiction_id"], name: "index_purchases_on_fiction_id", using: :btree
  add_index "purchases", ["reader_id", "fiction_id"], name: "index_purchases_on_reader_id_and_fiction_id", unique: true, using: :btree
  add_index "purchases", ["reader_id"], name: "index_purchases_on_reader_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "taggings", ["post_id"], name: "index_taggings_on_post_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "name",                   limit: 255, default: "",    null: false
    t.string   "surname",                limit: 255, default: "",    null: false
    t.boolean  "admin",                              default: false, null: false
    t.boolean  "writer",                             default: false, null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "taggings", "posts"
  add_foreign_key "taggings", "tags"
end
