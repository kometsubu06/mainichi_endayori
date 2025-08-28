class BackfillNoticesOrganization < ActiveRecord::Migration[7.1]
  def up
    # 1) デフォルト園を確保
    org_id = select_value("SELECT id FROM organizations ORDER BY id ASC LIMIT 1")
    unless org_id
      execute "INSERT INTO organizations (name, created_at, updated_at) VALUES ('デフォルト園', NOW(), NOW())"
      org_id = select_value("SELECT id FROM organizations ORDER BY id ASC LIMIT 1")
    end

    # 2) 不整合データをすべてデフォルト園に寄せる
    #   - NULL
    #   - 0 など存在しないID
    #   - 参照先 organizations に行が存在しないID
    execute <<~SQL
      UPDATE notices
      LEFT JOIN organizations ON notices.organization_id = organizations.id
      SET notices.organization_id = #{org_id}
      WHERE organizations.id IS NULL;
    SQL

    # 3) 外部キー & NOT NULL を付与
    add_foreign_key :notices, :organizations unless foreign_key_exists?(:notices, :organizations)
    change_column_null :notices, :organization_id, false

    # （任意）クエリ最適化
    add_index :notices, [:organization_id, :due_on] unless index_exists?(:notices, [:organization_id, :due_on])
  end

  def down
    change_column_null :notices, :organization_id, true
    remove_foreign_key :notices, :organizations if foreign_key_exists?(:notices, :organizations)
    remove_index :notices, column: [:organization_id, :due_on] if index_exists?(:notices, [:organization_id, :due_on])
  end
end