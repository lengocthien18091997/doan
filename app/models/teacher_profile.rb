class TeacherProfile < ActiveRecord::Base
  belongs_to :user

  validates :education_level, :hourly_rate, presence: true, allow_nil: true
  validates :hourly_rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

end

