class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :job_requests
  has_many :text_files, through: :job_requests
  has_many_attached :file
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
