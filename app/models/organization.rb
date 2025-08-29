class Organization < ApplicationRecord
  has_many :users
  has_many :children
  has_many :notices
  has_many :submission_requests
  has_many :events
end
