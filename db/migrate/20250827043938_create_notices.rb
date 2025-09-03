class CreateNotices < ActiveRecord::Migration[7.1]
  def change
    create_table :notices do |t|
      t.string :title
      t.text :body
      t.date :due_on
      t.boolean :require_submission
      t.datetime :published_at

      t.timestamps
    end
  end
end
