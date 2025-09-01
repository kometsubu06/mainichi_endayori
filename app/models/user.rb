class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, #registerable,
         :recoverable, :rememberable, :validatable

  enum role: { guardian: 0, teacher: 1, admin: 9 }, _default: :guardian

  belongs_to :organization, optional: true
  has_many :notifications, dependent: :destroy
  has_many :notice_reads, dependent: :destroy
  has_many :read_notices, through: :notice_reads, source: :notice
  has_many :guardianships, dependent: :destroy
  has_many :children, through: :guardianships

  # 日本語表示用ヘルパー
  def role_i18n
    I18n.t("activerecord.attributes.user.roles.#{role}", default: role)
  end
end
