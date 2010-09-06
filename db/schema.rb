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

ActiveRecord::Schema.define(:version => 20100906035600) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "subdomain"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["subdomain"], :name => "index_accounts_on_subdomain", :unique => true

  create_table "activities", :force => true do |t|
    t.integer  "account_id"
    t.integer  "applicant_id"
    t.integer  "job_id"
    t.integer  "actor_id"
    t.string   "action"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.integer  "subject2_id"
    t.string   "subject2_type"
    t.integer  "prev_stage_id"
    t.integer  "next_stage_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["account_id"], :name => "index_activities_on_account"
  add_index "activities", ["applicant_id"], :name => "index_activities_on_applicant"

  create_table "admins", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true
  add_index "admins", ["unlock_token"], :name => "index_admins_on_unlock_token", :unique => true

  create_table "applicants", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.text     "cover_letter"
    t.integer  "job_id"
    t.integer  "account_id"
    t.integer  "job_stage_id"
    t.boolean  "is_archived",               :default => false
    t.boolean  "is_starred",                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.text     "resume"
    t.string   "cover_letter_content_type", :default => "text"
    t.string   "resume_content_type"
  end

  add_index "applicants", ["account_id", "job_stage_id"], :name => "index_applicants_on_account_and_stage"
  add_index "applicants", ["job_id", "job_stage_id"], :name => "index_applicants_on_job_and_stage"

  create_table "attachments", :force => true do |t|
    t.string   "caption"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                                 :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 25
    t.string   "guid",              :limit => 10
    t.integer  "locale",            :limit => 1,  :default => 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "fk_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_assetable_type"
  add_index "ckeditor_assets", ["user_id"], :name => "fk_user"

  create_table "conversations", :force => true do |t|
    t.string   "content_type"
    t.text     "body"
    t.boolean  "outgoing"
    t.integer  "applicant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
  end

  create_table "default_job_stages", :force => true do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "default_message_templates", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_settings", :force => true do |t|
    t.string   "server"
    t.string   "port"
    t.string   "username"
    t.string   "password"
    t.boolean  "ssl",               :default => true
    t.string   "protocol"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "configurable_id"
    t.string   "configurable_type"
  end

  create_table "invitations", :force => true do |t|
    t.string  "email"
    t.string  "token"
    t.integer "inviter_id"
  end

  add_index "invitations", ["token"], :name => "index_invitations_on_token", :unique => true

  create_table "job_stages", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.integer  "position"
    t.string   "color"
    t.boolean  "is_deleted", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_stages", ["account_id"], :name => "index_job_stages_on_account"

  create_table "jobs", :force => true do |t|
    t.integer "account_id"
    t.string  "title"
    t.text    "description"
    t.string  "status"
    t.date    "creation_date"
    t.date    "expiry_date"
    t.integer "applicants_count"
  end

  add_index "jobs", ["account_id"], :name => "index_jobs_on_account"

  create_table "message_readings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.boolean  "is_read",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_templates", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "account_id"
    t.string   "uid"
    t.string   "sender_first_name"
    t.string   "sender_last_name"
    t.string   "sender_email"
    t.string   "subject"
    t.text     "content"
    t.string   "content_type"
    t.boolean  "converted",         :default => false
    t.integer  "applicant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_attachments"
    t.integer  "converter_id"
    t.string   "sender_phone"
  end

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "user_views", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "applicant_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
