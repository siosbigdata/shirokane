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

ActiveRecord::Schema.define(version: 20140114071623) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "graphs", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.integer  "graph_type"
    t.integer  "term"
    t.string   "y"
    t.integer  "analysis_type"
    t.integer  "useval"
    t.integer  "linewidth"
    t.integer  "y_min"
    t.integer  "y_max_time"
    t.integer  "y_max_day"
    t.integer  "y_max_month"
    t.string   "y_unit"
    t.integer  "useshadow"
    t.integer  "usetip"
    t.integer  "usepredata"
    t.integer  "uselastyeardata"
    t.string   "template"
    t.string   "merge_graph"
    t.string   "merge_linecolor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "graphtemplates", force: true do |t|
    t.string   "linecolor"
    t.string   "bgfrom"
    t.string   "bgto"
    t.string   "textcolor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "linecolor_pre"
    t.string   "linecolor_last"
  end

  create_table "groupgraphs", force: true do |t|
    t.integer  "group_id"
    t.integer  "graph_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "dashboard"
    t.integer  "view_rank"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "parameter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vieworder"
    t.integer  "columntype"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "title"
    t.string   "mail"
    t.integer  "group_id"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

end
