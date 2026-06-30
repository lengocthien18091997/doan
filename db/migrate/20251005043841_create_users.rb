class CreateUsers < ActiveRecord::Migration[7.1]
  def up
    # ======================
    # USERS
    # ======================
    create_table :users do |t|
      t.string  :full_name
      t.string  :email, null: false, index: { unique: true }
      t.string  :password, null: false
      t.boolean :is_locked, default: false
      t.string  :phone_number
      t.string  :role, null: false, default: "student"   # enum: student, teacher, admin
      t.string  :gender
      t.date    :date_of_birth

      t.timestamps
    end

    # ======================
    # TEACHER PROFILE
    # ======================
    create_table :teacher_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.text    :bio
      t.string  :education_level
      t.integer :experience_years
      t.decimal :hourly_rate, precision: 10, scale: 2
      t.string  :location
      t.jsonb   :subjects, default: []
      t.jsonb   :availability, default: []

      t.timestamps
    end

    # ======================
    # REQUESTS
    # ======================
    create_table :requests do |t|
      t.references :student, null: false, foreign_key: { to_table: :users }
      t.references :teacher, null: false, foreign_key: { to_table: :users }

      t.string  :subject
      t.string  :grade_level
      t.text    :requirement_detail
      t.decimal :budget, precision: 10, scale: 2
      t.string  :location
      t.jsonb   :schedule, default: {}
      t.timestamp :create_date, default: -> { "CURRENT_TIMESTAMP" }
      t.string  :status, default: "open"   # enum: open, accepted, rejected, closed

      t.timestamps
    end

    # ======================
    # TIMETABLES
    # ======================
    create_table :timetables do |t|
      t.references :teacher, null: false, foreign_key: { to_table: :users }
      t.references :student, null: false, foreign_key: { to_table: :users }

      t.string  :subject
      t.jsonb   :schedule, default: {}
      t.string  :status, default: "open"   # enum: open, closed

      t.timestamps
    end

    # ======================
    # SUPPORTS
    # ======================
    create_table :supports do |t|
      t.references :user, null: false, foreign_key: true

      t.string  :category
      t.text    :comment
      t.string  :status, default: "open"   # enum: open, processing, closed
      t.timestamp :created_at, default: -> { "CURRENT_TIMESTAMP" }
    end
  end

  def down
    # Xóa bảng theo thứ tự phụ thuộc (ngược lại với up)
    drop_table :supports
    drop_table :timetables
    drop_table :requests
    drop_table :teacher_profiles
    drop_table :users
  end
end
