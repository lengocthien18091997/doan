class User < ActiveRecord::Base
  require 'bcrypt'

  has_one :teacher_profile, dependent: :destroy
  accepts_nested_attributes_for :teacher_profile
  has_many :student_requests, class_name: "Request", foreign_key: "student_id", dependent: :destroy
  has_many :teacher_requests, class_name: "Request", foreign_key: "teacher_id", dependent: :destroy
  has_many :student_tuitions, class_name: "Tuition", foreign_key: "student_id", dependent: :destroy
  has_many :teacher_tuitions, class_name: "Tuition", foreign_key: "teacher_id", dependent: :destroy
  has_many :timetables, foreign_key: "teacher_id", dependent: :destroy
  has_many :supports, dependent: :destroy
  has_many :sessions, dependent: :destroy

  enum role: { student: Constant::ROLE_STUDENT, teacher: Constant::ROLE_TEACHER, admin: Constant::ROLE_ADMIN }

  validates :email, :password, presence: true
  validates :email, uniqueness: true

  before_save :encrypt_password, if: :will_save_change_to_password?

  def locked?
    is_locked
  end

  def password_matches?(plain_password)
    if encrypted_password?
      BCrypt::Password.new(password).is_password?(plain_password)
    else
      password == plain_password
    end
  rescue BCrypt::Errors::InvalidHash
    false
  end

  def encrypted_password?
    password.to_s.match?(/\A\$2[aby]\$\d{2}\$[.\/A-Za-z0-9]{53}\z/)
  end

  private

  def encrypt_password
    return if encrypted_password?

    self.password = BCrypt::Password.create(password)
  end
end
