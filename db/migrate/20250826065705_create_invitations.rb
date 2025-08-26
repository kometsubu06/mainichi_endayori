class CreateInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :invitations do |t|
      t.string :code, null: false
      t.string :email
      t.bigint :organization_id
      t.integer :role, default: 0, null: false
      t.datetime :expires_at
      t.datetime :used_at
      t.bigint :child_id

      t.timestamps
    end
    add_index :invitations, :code, unique: true
    add_index :invitations, :organization_id
    add_index :invitations, :child_id
  end
end
