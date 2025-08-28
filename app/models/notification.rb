class Notification < ApplicationRecord
  belongs_to :user
  enum kind: { unread_digest: 0, submission_reminder: 1 }
  scope :unread, -> { where(read_at: nil) }

  # DBデフォルトを置かない代わりにアプリ側でnilを防ぐ
  before_validation :ensure_metadata

  def mark_read! = update!(read_at: Time.current)

  private
  def ensure_metadata
    self.metadata ||= {}
  end
end
