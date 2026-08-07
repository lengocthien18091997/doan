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

ActiveRecord::Schema[7.1].define(version: 2026_07_26_090000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "requests", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "teacher_id", null: false
    t.string "subject"
    t.string "grade_level"
    t.text "requirement_detail"
    t.decimal "budget", precision: 10, scale: 2
    t.string "location"
    t.jsonb "schedule", default: {}
    t.datetime "create_date", precision: nil, default: -> { "now()" }
    t.string "status", default: "open"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_requests_on_student_id"
    t.index ["teacher_id"], name: "index_requests_on_teacher_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "request_id", null: false
    t.integer "role", null: false
    t.integer "star", null: false
    t.string "comment"
    t.index ["request_id"], name: "index_reviews_on_request_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "session_token", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_token"], name: "index_sessions_on_session_token", unique: true
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "supports", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "category"
    t.text "comment"
    t.string "status", default: "open"
    t.datetime "created_at", precision: nil, default: -> { "now()" }
    t.index ["user_id"], name: "index_supports_on_user_id"
  end

  create_table "teacher_profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "bio"
    t.string "education_level"
    t.integer "experience_years"
    t.decimal "hourly_rate", precision: 10, scale: 2
    t.string "location"
    t.jsonb "subjects", default: []
    t.jsonb "availability", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bank_name", comment: "Tên ngân hàng"
    t.string "bank_code", comment: "Mã ngân hàng (VCB, BIDV, ACB...)"
    t.string "bank_account_number", comment: "Số tài khoản ngân hàng"
    t.string "bank_account_name", comment: "Tên chủ tài khoản"
    t.index ["user_id"], name: "index_teacher_profiles_on_user_id"
  end

  create_table "timetables", force: :cascade do |t|
    t.bigint "teacher_id", null: false
    t.bigint "student_id", null: false
    t.string "subject"
    t.jsonb "schedule", default: {}
    t.string "status", default: "open"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.integer "request_id"
    t.index ["student_id"], name: "index_timetables_on_student_id"
    t.index ["teacher_id"], name: "index_timetables_on_teacher_id"
  end

  create_table "tuitions", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "teacher_id", null: false
    t.bigint "timetables_id", null: false
    t.integer "amount", null: false
    t.string "status", default: "new"
    t.integer "request_id"
    t.index ["student_id"], name: "index_tuitions_on_student_id"
    t.index ["teacher_id"], name: "index_tuitions_on_teacher_id"
    t.index ["timetables_id"], name: "index_tuitions_on_timetables_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name"
    t.string "email", null: false
    t.string "password", null: false
    t.boolean "is_locked", default: false
    t.string "phone_number"
    t.string "role", default: "student", null: false
    t.string "gender"
    t.date "date_of_birth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "contract_confirmed", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "requests", "users", column: "student_id"
  add_foreign_key "requests", "users", column: "teacher_id"
  add_foreign_key "reviews", "requests"
  add_foreign_key "sessions", "users"
  add_foreign_key "supports", "users"
  add_foreign_key "teacher_profiles", "users"
  add_foreign_key "timetables", "users", column: "student_id"
  add_foreign_key "timetables", "users", column: "teacher_id"
  add_foreign_key "tuitions", "timetables", column: "timetables_id"
  add_foreign_key "tuitions", "users", column: "student_id"
  add_foreign_key "tuitions", "users", column: "teacher_id"
end
