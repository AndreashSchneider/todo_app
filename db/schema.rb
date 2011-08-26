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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110824120743) do

  create_table "aufgaben", :force => true do |t|
    t.date     "erfasst"
    t.string   "projekt"
    t.text     "aufgabe"
    t.text     "erklaerung"
    t.text     "information"
    t.string   "zustaendig"
    t.string   "status"
    t.date     "erledigt_am"
    t.integer  "zeit"
    t.string   "heute_bearbeiten_kz"
    t.string   "nur_heute_interessant"
    t.string   "mantis_nummer"
    t.string   "privat"
    t.integer  "aufgabe_id"
    t.date     "termin"
    t.date     "aend_dat"
    t.integer  "reihenfolge"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "comments", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.string   "category"
    t.string   "farbe"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kartei", :force => true do |t|
    t.date     "anl_dat"
    t.date     "aend_dat"
    t.text     "question"
    t.text     "answer"
    t.string   "sparte"
    t.integer  "folder"
    t.integer  "kapitel"
    t.string   "not_known_today"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projekte", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin"
  end

  create_table "vw_vokabelns", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
