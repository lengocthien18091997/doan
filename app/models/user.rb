class User < ActiveRecord::Base
  has_one :teacher_profile, dependent: :destroy
  accepts_nested_attributes_for :teacher_profile
  has_many :student_requests, class_name: "Request", foreign_key: "student_id", dependent: :destroy
  has_many :teacher_requests, class_name: "Request", foreign_key: "teacher_id", dependent: :destroy
  has_many :timetables, foreign_key: "teacher_id", dependent: :destroy
  has_many :supports, dependent: :destroy
  has_many :sessions, dependent: :destroy

  # has_secure_password

  enum role: { student: "student", teacher: "teacher", admin: "admin" }

  validates :email, :password, presence: true
  validates :email, uniqueness: true

  def locked?
    is_locked
  end
end
