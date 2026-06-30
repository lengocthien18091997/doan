class CreateSessions < ActiveRecord::Migration[7.1]
  def up
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :session_token, null: false, index: { unique: true }
      t.string :ip_address
      t.string :user_agent
      t.datetime :expires_at
      t.timestamps
    end
  end

  def down
    drop_table :sessions
  end
end
