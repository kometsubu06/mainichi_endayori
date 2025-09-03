class AddUniqueIndexToNoticeReads < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def up
    # 既存の非ユニークindexがあれば削除（無ければ何もしない）
    remove_index :notice_reads, [:user_id, :notice_id] if index_exists?(:notice_reads, [:user_id, :notice_id])

    adapter = ActiveRecord::Base.connection.adapter_name.downcase

    if adapter.include?('mysql')
      # MySQL: 自己結合で重複行を削除
      execute <<~SQL
        DELETE a
        FROM notice_reads a
        INNER JOIN notice_reads b
          ON a.user_id = b.user_id
         AND a.notice_id = b.notice_id
         AND a.id > b.id;
      SQL

      # MySQL では CONCURRENTLY は不可。ふつうにユニークインデックスを追加
      add_index :notice_reads,
                [:user_id, :notice_id],
                unique: true,
                name: 'index_notice_reads_on_user_id_and_notice_id_unique'

    elsif adapter.include?('postgres')
      # PostgreSQL: CONCURRENTLY を使ってロックを最小化
      add_index :notice_reads,
                [:user_id, :notice_id],
                unique: true,
                algorithm: :concurrently,
                name: 'index_notice_reads_on_user_id_and_notice_id_unique'
    else
      # それ以外は汎用的に（小規模テーブル想定）
      add_index :notice_reads,
                [:user_id, :notice_id],
                unique: true,
                name: 'index_notice_reads_on_user_id_and_notice_id_unique'
    end
  end

  def down
    remove_index :notice_reads, name: 'index_notice_reads_on_user_id_and_notice_id_unique' if index_exists?(:notice_reads, name: 'index_notice_reads_on_user_id_and_notice_id_unique')

    # 必要なら非ユニークindexを戻す（任意）
    add_index :notice_reads, [:user_id, :notice_id] unless index_exists?(:notice_reads, [:user_id, :notice_id])
  end
end
