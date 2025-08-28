class CreateSubmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :submissions do |t|
      t.references :submission_request, null: false
      t.references :child, null: false
      t.bigint :submitted_by
      t.datetime :submitted_at
      t.integer :status, null: false, default: 1  # 0: pending, 1: done（作成時done想定）

      t.timestamps
    end
    add_foreign_key :submissions, :users, column: :submitted_by
    add_index :submissions, [:submission_request_id, :child_id],
              unique: true, name: 'index_submissions_on_request_and_child'
  end
end
