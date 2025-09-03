class Child < ApplicationRecord
  belongs_to :organization
  #belongs_to :classroom
  has_many :guardianships, dependent: :destroy
  has_many :users, through: :guardianships
end
