class SubmissionRequest < ApplicationRecord
  belongs_to :organization
  has_many :submissions, dependent: :destroy

  enum status: { published: 0, archived: 1 }, _prefix: true
  scope :for_org, ->(org_id) { where(organization_id: org_id) }
end
