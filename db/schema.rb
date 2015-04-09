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

ActiveRecord::Schema.define(version: 20150409145647) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "room_number"
    t.boolean  "checked_in"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["room_number"], name: "index_customers_on_room_number", using: :btree

  create_table "lockers", force: :cascade do |t|
    t.string   "number"
    t.string   "size"
    t.boolean  "assigned"
    t.integer  "reservation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lockers", ["number"], name: "index_lockers_on_number", using: :btree
  add_index "lockers", ["reservation_id"], name: "index_lockers_on_reservation_id", using: :btree

  create_table "reservations", force: :cascade do |t|
    t.string   "number"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reservations", ["customer_id"], name: "index_reservations_on_customer_id", using: :btree
  add_index "reservations", ["number"], name: "index_reservations_on_number", using: :btree

end
