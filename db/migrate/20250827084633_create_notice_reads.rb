class CreateNoticeReads < ActiveRecord::Migration[7.1]
  def change
    create_table :notice_reads do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notice, null: false, foreign_key: true
      t.datetime :read_at

      t.timestamps
    end
    add_index :notice_reads, [:user_id, :notice_id], unique: true
  end
end
