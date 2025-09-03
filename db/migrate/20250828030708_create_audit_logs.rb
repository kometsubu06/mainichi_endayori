class CreateAuditLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :audit_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action, null: false           # 'notice.read', 'notice.remind' など
      t.bigint :notice_id                     # 対象のお知らせ
      t.datetime :occurred_at, null: false     # = read_at 等の実行時刻
      t.json :metadata                        # MySQL/PG両対応。defaultは付けない

      t.timestamps
    end
    add_index :audit_logs, [:user_id, :occurred_at]
    add_index :audit_logs, :action
    add_index :audit_logs, :notice_id
  end
end
