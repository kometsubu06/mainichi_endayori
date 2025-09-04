class HardenNoticesOrganizationFk < ActiveRecord::Migration[7.1]
  def change
    change_column_null :notices, :organization_id, false
    add_index :notices, :organization_id unless index_exists?(:notices, :organization_id)
    unless foreign_key_exists?(:notices, :organizations)
      add_foreign_key :notices, :organizations, validate: false
      validate_foreign_key :notices, :organizations
    end
  end
end
