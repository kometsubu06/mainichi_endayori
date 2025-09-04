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

ActiveRecord::Schema[7.1].define(version: 2025_09_04_050030) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audit_logs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "action", null: false
    t.bigint "notice_id"
    t.datetime "occurred_at", null: false
    t.json "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action"], name: "index_audit_logs_on_action"
    t.index ["notice_id"], name: "index_audit_logs_on_notice_id"
    t.index ["user_id", "occurred_at"], name: "index_audit_logs_on_user_id_and_occurred_at"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "children", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "name"], name: "index_children_on_organization_id_and_name"
    t.index ["organization_id"], name: "index_children_on_organization_id"
  end

  create_table "guardianships", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "child_id", null: false
    t.string "relationship", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id"], name: "index_guardianships_on_child_id"
    t.index ["user_id", "child_id"], name: "index_guardianships_on_user_id_and_child_id", unique: true
    t.index ["user_id"], name: "index_guardianships_on_user_id"
  end

  create_table "invitations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "code", null: false
    t.string "email"
    t.bigint "organization_id"
    t.integer "role", default: 0, null: false
    t.datetime "expires_at"
    t.datetime "used_at"
    t.bigint "child_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id"], name: "index_invitations_on_child_id"
    t.index ["code"], name: "index_invitations_on_code", unique: true
    t.index ["organization_id"], name: "index_invitations_on_organization_id"
  end

  create_table "notice_reads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "notice_id", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notice_id"], name: "index_notice_reads_on_notice_id"
    t.index ["user_id", "notice_id"], name: "index_notice_reads_on_user_id_and_notice_id_unique", unique: true
    t.index ["user_id"], name: "index_notice_reads_on_user_id"
  end

  create_table "notices", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.date "due_on"
    t.boolean "require_submission"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id", null: false
    t.index ["organization_id", "due_on"], name: "index_notices_on_organization_id_and_due_on"
    t.index ["organization_id"], name: "index_notices_on_organization_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "kind", default: 0, null: false
    t.string "title", null: false
    t.text "body"
    t.json "metadata", null: false
    t.datetime "read_at"
    t.datetime "scheduled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["user_id", "created_at"], name: "index_notifications_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "organizations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_organizations_on_name"
  end

  create_table "submission_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.date "due_on"
    t.integer "status", default: 0, null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "due_on"], name: "index_submission_requests_on_organization_id_and_due_on"
    t.index ["organization_id"], name: "index_submission_requests_on_organization_id"
  end

  create_table "submissions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "submission_request_id", null: false
    t.bigint "child_id", null: false
    t.bigint "submitted_by"
    t.datetime "submitted_at"
    t.integer "status", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id"], name: "index_submissions_on_child_id"
    t.index ["submission_request_id", "child_id"], name: "index_submissions_on_request_and_child", unique: true
    t.index ["submission_request_id"], name: "index_submissions_on_submission_request_id"
    t.index ["submitted_by"], name: "fk_rails_f003e9ac4a"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", default: "", null: false
    t.integer "role", default: 0, null: false
    t.bigint "organization_id"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audit_logs", "users"
  add_foreign_key "children", "organizations"
  add_foreign_key "guardianships", "children"
  add_foreign_key "guardianships", "users"
  add_foreign_key "notice_reads", "notices"
  add_foreign_key "notice_reads", "users"
  add_foreign_key "notices", "organizations"
  add_foreign_key "notifications", "users"
  add_foreign_key "submission_requests", "organizations"
  add_foreign_key "submissions", "users", column: "submitted_by"
end
