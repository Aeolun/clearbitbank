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

ActiveRecord::Schema.define(version: 2018_05_13_111816) do

  create_table "accounts", force: :cascade do |t|
    t.string "account_id"
    t.string "name"
    t.string "official_name"
    t.string "subtype"
    t.string "type"
    t.decimal "balance_available"
    t.decimal "balance_current"
    t.decimal "balance_limit"
    t.date "last_loaded"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_accounts_on_item_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "company_id"
    t.string "name"
    t.string "legal_name"
    t.string "domain"
    t.string "sector"
    t.string "industry_group"
    t.string "industry"
    t.text "description"
    t.integer "founded_year"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "item_id"
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "account_id"
    t.decimal "amount"
    t.integer "category_id"
    t.date "date"
    t.string "name"
    t.boolean "pending"
    t.string "transaction_id"
    t.string "transaction_type"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["company_id"], name: "index_transactions_on_company_id"
  end

end
