class NoticeRead < ApplicationRecord
  belongs_to :user
  belongs_to :notice
  validates :user_id, uniqueness: { scope: :notice_id }
end
