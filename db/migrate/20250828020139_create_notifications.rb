class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :kind, null: false, default: 0
      t.string :title, null: false
      t.text :body
      t.json :metadata, null: false
      t.datetime :read_at
      t.datetime :scheduled_at

      t.timestamps
    end
    add_index :notifications, [:user_id, :created_at]
    add_index :notifications, :read_at
  end
end