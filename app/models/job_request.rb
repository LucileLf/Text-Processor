class JobRequest < ApplicationRecord
  STATUS = ["initiated", "in progress", "finished"]
  belongs_to :text_file
  belongs_to :job
  has_one_attached :file
  has_one :user, through: :text_file
end
