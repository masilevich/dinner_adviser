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

ActiveRecord::Schema.define(version: 20140701130218) do

  create_table "course_kinds", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "course_kinds", ["name", "user_id"], name: "index_course_kinds_on_name_and_user_id", unique: true
  add_index "course_kinds", ["user_id"], name: "index_course_kinds_on_user_id"

  create_table "courses", force: true do |t|
    t.string   "name"
    t.boolean  "common"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_kind_id"
  end

  add_index "courses", ["name", "user_id"], name: "index_courses_on_name_and_user_id", unique: true
  add_index "courses", ["user_id"], name: "index_courses_on_user_id"

  create_table "courses_menus", id: false, force: true do |t|
    t.integer "course_id"
    t.integer "menu_id"
  end

  create_table "ingridients", force: true do |t|
    t.integer  "course_id"
    t.integer  "product_id"
    t.integer  "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_kinds", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "menu_kinds", ["name", "user_id"], name: "index_menu_kinds_on_name_and_user_id", unique: true
  add_index "menu_kinds", ["user_id"], name: "index_menu_kinds_on_user_id"

  create_table "menus", force: true do |t|
    t.date     "date"
    t.integer  "menu_kind_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "menus", ["user_id"], name: "index_menus_on_user_id"

  create_table "product_kinds", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_kinds", ["name", "user_id"], name: "index_product_kinds_on_name_and_user_id", unique: true
  add_index "product_kinds", ["user_id"], name: "index_product_kinds_on_user_id"

  create_table "products", force: true do |t|
    t.string   "name"
    t.boolean  "common"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "available",       default: false, null: false
    t.integer  "product_kind_id"
  end

  add_index "products", ["name", "user_id"], name: "index_products_on_name_and_user_id", unique: true
  add_index "products", ["user_id"], name: "index_products_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
