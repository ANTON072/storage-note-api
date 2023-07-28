# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_27_075809) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "storage_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["storage_id", "name"], name: "index_categories_on_storage_id_and_name", unique: true
    t.index ["storage_id"], name: "index_categories_on_storage_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.bigint "storage_id", null: false
    t.string "name", null: false
    t.string "description"
    t.string "image_url"
    t.bigint "category_id"
    t.integer "item_count", null: false
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "purchase_location"
    t.string "price"
    t.string "unit_name"
    t.integer "alert_threshold"
    t.boolean "is_favorite"
    t.index ["category_id"], name: "index_stocks_on_category_id"
    t.index ["created_by_id"], name: "index_stocks_on_created_by_id"
    t.index ["name"], name: "index_stocks_on_name"
    t.index ["storage_id"], name: "index_stocks_on_storage_id"
    t.index ["updated_by_id"], name: "index_stocks_on_updated_by_id"
  end

  create_table "storages", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "description"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_storages_on_slug", unique: true
  end

  create_table "user_storages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "storage_id", null: false
    t.integer "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["storage_id"], name: "index_user_storages_on_storage_id"
    t.index ["user_id"], name: "index_user_storages_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "firebase_uid", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "photo_url"
    t.integer "state", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["firebase_uid"], name: "index_users_on_firebase_uid", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "categories", "storages"
  add_foreign_key "stocks", "categories"
  add_foreign_key "stocks", "storages"
  add_foreign_key "stocks", "users", column: "created_by_id"
  add_foreign_key "stocks", "users", column: "updated_by_id"
  add_foreign_key "user_storages", "storages"
  add_foreign_key "user_storages", "users"
end
