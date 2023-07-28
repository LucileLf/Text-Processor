class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :text_files
  has_many :job_requests, through: :text_files
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
