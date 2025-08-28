class Submission < ApplicationRecord
  belongs_to :submission_request
  belongs_to :child
  belongs_to :user, foreign_key: :submitted_by, optional: true

  enum status: { pending: 0, done: 1 }
  validates :submission_request_id, uniqueness: { scope: :child_id }
end
