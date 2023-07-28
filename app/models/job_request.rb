class JobRequest < ApplicationRecord
  belongs_to :user
  belongs_to :text_file
end
