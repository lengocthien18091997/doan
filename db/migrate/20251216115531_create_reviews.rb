class CreateReviews < ActiveRecord::Migration[7.1]
  def up
    create_table :reviews do |t|
      t.references :request, null: false, foreign_key: true
      t.integer :role, null: false
      t.integer :star, null: false
      t.string :comment
    end
  end

  def down
    drop_table :reviews
  end
end
