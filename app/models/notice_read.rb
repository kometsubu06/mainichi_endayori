class NoticeRead < ApplicationRecord
  belongs_to :user
  belongs_to :notice
  validates :user_id, uniqueness: { scope: :notice_id }
  before_create { self.read_at ||= Time.current }
end
