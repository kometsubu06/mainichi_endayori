class Notice < ApplicationRecord
  has_many :notice_reads, dependent: :destroy
  belongs_to :organization
  scope :published, -> { where("published_at IS NULL OR published_at <= ?", Time.current) }
  scope :deadline_order, -> {
    order(Arel.sql("CASE WHEN due_on IS NULL THEN 1 ELSE 0 END ASC"),
          :due_on => :asc,
          :published_at => :desc)
  }
end
