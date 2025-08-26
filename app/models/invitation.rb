class Invitation < ApplicationRecord
  enum role: { guardian: 0, teacher: 1, admin: 9 }

  belongs_to :organization, optional: true
  belongs_to :child, optional: true  # 子ども個別招待を将来使うなら

  validates :code, presence: true, uniqueness: true

  scope :usable, -> { where(used_at: nil).where("expires_at IS NULL OR expires_at > ?", Time.current) }

  def mark_used!
    update!(used_at: Time.current)
  end
end
