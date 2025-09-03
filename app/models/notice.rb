class Notice < ApplicationRecord
  has_many :notice_reads, dependent: :destroy
  belongs_to :organization
  has_many_attached :images
  
  # ✅ 公開済み（過去〜現在に公開されたもの）
  scope :published, -> { where.not(published_at: nil).where("published_at <= ?", Time.current) }

  # ✅ 下書き（未公開）
  scope :drafts, -> { where(published_at: nil) }

  # ✅ 保護者に見せて良いもの（= published と同義）
  scope :visible_to_guardian, -> { published }

  # 期限ありを前方に、その中で due_on 昇順 → 同日なら公開日の新しい順
  scope :deadline_order, -> {
    order(
      Arel.sql("CASE WHEN due_on IS NULL THEN 1 ELSE 0 END ASC") # 期限あり優先
    ).order(due_on: :asc, published_at: :desc)
  }

  # 便利メソッド
  def published?
    published_at.present? && published_at <= Time.current
  end

  validates :title, presence: true
  def states_label
    return "下書き" if published_at.nil?
    return "予約公開" if published_at > Time.current
    "公開中"
  end
  validate :images_content_type

  def images_content_type
    return if images.blank?
    images.each do |img|
      unless img.content_type.in?(%w[image/png image/jpeg image/jpg image/gif image/webp])
        errors.add(:images, "はPNG/JPEG/GIF/WebPのみアップロードできます")
      end
    end
  end
end
