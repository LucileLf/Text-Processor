class TextFile < ApplicationRecord
  has_many :job_requests
  has_one_attached :file
  belongs_to :user
end
