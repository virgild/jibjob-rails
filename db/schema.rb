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

ActiveRecord::Schema.define(version: 20150329201514) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_logs", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",       limit: 8, null: false
    t.string   "event",                   null: false
    t.string   "url",                     null: false
    t.inet     "ip_address"
    t.integer  "user_agent_id"
    t.jsonb    "metadata"
    t.datetime "created_at",              null: false
  end

  create_table "password_recoveries", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",    limit: 8
    t.string   "token",                null: false
    t.datetime "created_at"
  end

  create_table "publication_views", id: :bigserial, force: :cascade do |t|
    t.integer  "resume_id",  limit: 8,                         null: false
    t.inet     "ip_addr",                                      null: false
    t.string   "url",                                          null: false
    t.string   "referrer"
    t.string   "user_agent"
    t.datetime "created_at",                                   null: false
    t.decimal  "lat",                  precision: 9, scale: 6
    t.decimal  "lng",                  precision: 9, scale: 6
    t.string   "city"
    t.string   "state"
    t.string   "country"
  end

  add_index "publication_views", ["resume_id"], name: "index_publication_views_on_resume_id", using: :btree

  create_table "resumes", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",                 limit: 8,                 null: false
    t.string   "name",                                              null: false
    t.text     "content",                                           null: false
    t.string   "guid",                                              null: false
    t.integer  "status",                            default: 0,     null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "pdf_file_name"
    t.string   "pdf_content_type"
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.integer  "edition",                           default: 0,     null: false
    t.string   "slug",                                              null: false
    t.boolean  "is_published",                      default: false, null: false
    t.string   "access_code"
    t.integer  "pdf_edition",                       default: 0,     null: false
    t.integer  "pdf_pages"
    t.integer  "publication_views_count", limit: 8, default: 0,     null: false
    t.string   "theme"
  end

  add_index "resumes", ["slug"], name: "index_resumes_on_slug", unique: true, using: :btree

  create_table "signup_confirmations", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",      limit: 8
    t.string   "token",                  null: false
    t.datetime "confirmed_at"
  end

  create_table "signups", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id",    limit: 8
    t.inet     "ip_address"
    t.string   "user_agent"
    t.json     "extras"
    t.datetime "created_at",           null: false
  end

  create_table "user_agents", force: :cascade do |t|
    t.string "agent_id",     null: false
    t.string "agent_string", null: false
  end

  add_index "user_agents", ["agent_id"], name: "index_user_agents_on_agent_id", unique: true, using: :btree

  create_table "users", id: :bigserial, force: :cascade do |t|
    t.string   "username",        null: false
    t.string   "email"
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "timezone"
    t.string   "default_role"
    t.string   "auth_provider"
    t.string   "auth_uid"
    t.string   "auth_name"
    t.string   "auth_token"
    t.string   "auth_secret"
    t.datetime "auth_expires"
  end

  add_index "users", ["auth_provider", "auth_uid"], name: "index_users_on_auth_provider_and_auth_uid", using: :btree
  add_index "users", ["auth_provider"], name: "index_users_on_auth_provider", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
