class CreateChildren < ActiveRecord::Migration[7.1]
  def change
    create_table :children do |t|
      t.string :name, null: false
      t.references :organization, null: false, foreign_key: true
      #t.references :classroom, null: false, foreign_key: true

      t.timestamps
    end
    add_index :children, [:organization_id, :name]
  end
end
