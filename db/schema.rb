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

ActiveRecord::Schema.define(version: 20150818204511) do

  create_table "courses", force: :cascade do |t|
    t.string   "quarter"
    t.string   "year"
    t.string   "course"
    t.string   "instructor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media", force: :cascade do |t|
    t.string   "title"
    t.string   "director"
    t.string   "call_number"
    t.string   "year"
    t.string   "file_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "course_id"
    t.integer  "media_id"
  end

  add_index "reports", ["course_id"], name: "index_reports_on_course_id"
  add_index "reports", ["media_id"], name: "index_reports_on_media_id"

  create_table "users", force: :cascade do |t|
    t.string   "name",       default: ""
    t.string   "email",      default: ""
    t.string   "uid",        default: "", null: false
    t.string   "provider",   default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["name"], name: "index_users_on_name", unique: true
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true

end
