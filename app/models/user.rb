class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { guardian: 0, teacher: 1, admin: 9 }, _default: :guardian

  belongs_to :organization, optional: true
  # 先行しておく関連（後で実体を足す想定。未定ならコメントアウト可）
  # has_many :guardianships
  # has_many :children, through: :guardianships
end
