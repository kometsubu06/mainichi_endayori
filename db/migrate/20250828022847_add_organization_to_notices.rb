class AddOrganizationToNotices < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:notices, :organization_id)
      add_reference :notices, :organization, null: true, index: true
    end

    # 念のためインデックスだけ保証（あるならスキップ）
    add_index :notices, [:organization_id, :due_on] unless index_exists?(:notices, [:organization_id, :due_on])
  end
end