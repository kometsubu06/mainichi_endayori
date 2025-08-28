class CreateGuardianships < ActiveRecord::Migration[7.1]
  def change
    create_table :guardianships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :child, null: false, foreign_key: true
      t.string :relationship, null: false

      t.timestamps
    end
    # 同じ保護者と同じ子どもの重複登録を防ぐ
    add_index :guardianships, [:user_id, :child_id], unique: true
  end
end
