class Guardianship < ApplicationRecord
  belongs_to :guardian, class_name: "User", foreign_key: :user_id
  belongs_to :child
  validates :child_id, uniqueness: { scope: :user_id }
end
