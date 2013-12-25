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

ActiveRecord::Schema.define(:version => 20131225164243) do

  create_table "combos", :force => true do |t|
    t.integer  "no_tricks"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "tricker_id", :default => 1
    t.string   "sequence"
  end

  create_table "elements", :force => true do |t|
    t.integer  "combo_id"
    t.integer  "trick_id"
    t.integer  "index"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "elements", ["combo_id"], :name => "index_elements_on_combo_id"
  add_index "elements", ["trick_id"], :name => "index_elements_on_trick_id"

  create_table "list_elements", :force => true do |t|
    t.integer  "combo_id"
    t.integer  "list_id"
    t.integer  "index"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "list_elements", ["combo_id"], :name => "index_list_elements_on_combo_id"
  add_index "list_elements", ["list_id"], :name => "index_list_elements_on_list_id"

  create_table "lists", :force => true do |t|
    t.integer  "tricker_id"
    t.string   "name"
    t.text     "description"
    t.string   "visibility"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "trickers", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "sampler"
    t.string   "youtube"
    t.string   "facebook"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "admin",                  :default => false
  end

  add_index "trickers", ["confirmation_token"], :name => "index_trickers_on_confirmation_token", :unique => true
  add_index "trickers", ["email"], :name => "index_trickers_on_email", :unique => true
  add_index "trickers", ["reset_password_token"], :name => "index_trickers_on_reset_password_token", :unique => true

  create_table "tricking_styles", :force => true do |t|
    t.integer  "tricker_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tricking_styles_tricks", :id => false, :force => true do |t|
    t.integer "tricking_style_id"
    t.integer "trick_id"
  end

  create_table "tricks", :force => true do |t|
    t.string   "name"
    t.string   "difficulty"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "tricker_id", :default => 1
    t.string   "trick_type", :default => "N/A"
  end

end
