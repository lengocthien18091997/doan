class CreateCommissionFees < ActiveRecord::Migration[7.0]
  def change
    create_table :commission_fees do |t|
      t.references :timetable, null: false, foreign_key: true, index: { unique: true }
      t.references :teacher, null: false, foreign_key: { to_table: :users }
      t.references :student, null: false, foreign_key: { to_table: :users }
      t.integer :amount, null: false
      t.string :status, null: false, default: "new"
      t.timestamps
    end
  end
end