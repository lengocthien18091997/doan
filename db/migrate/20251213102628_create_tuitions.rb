class CreateTuitions < ActiveRecord::Migration[7.0]
  def change
    create_table :tuitions do |t|
      t.references :student, null: false, foreign_key: { to_table: :users }
      t.references :teacher, null: false, foreign_key: { to_table: :users }
      t.references :timetables, null: false, foreign_key: { to_table: :timetables }
      t.integer :amount,        null: false        # Học phí

      t.string  :status, default: "new"         # unpaid / paid / cancelled
    end

    add_column :teacher_profiles, :bank_name, :string, comment: "Tên ngân hàng"
    add_column :teacher_profiles, :bank_code, :string, comment: "Mã ngân hàng (VCB, BIDV, ACB...)"
    add_column :teacher_profiles, :bank_account_number, :string, comment: "Số tài khoản ngân hàng"
    add_column :teacher_profiles, :bank_account_name, :string, comment: "Tên chủ tài khoản"
  end
end
