class CreateSubmissionRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :submission_requests do |t|
      t.string :title, null: false
      t.text :description
      t.date :due_on
      t.integer :status, null: false, default: 0   # 0: published, 1: archived 等
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
    add_index :submission_requests, [:organization_id, :due_on]
  end
end
