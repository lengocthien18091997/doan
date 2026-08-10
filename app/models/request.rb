class Request < ActiveRecord::Base
  belongs_to :student, class_name: "User"
  belongs_to :teacher, class_name: "User"
  has_one :timetable, dependent: :destroy
  has_one :tuition
  has_one :review

  enum status: {
      open: Constant::REQUEST_STATUS_OPEN,
      accepted: Constant::REQUEST_STATUS_ACCEPTED,
      # studying: Constant::REQUEST_STATUS_STUDYING,
      rejected: Constant::REQUEST_STATUS_REJECTED,
      closed: Constant::REQUEST_STATUS_CLOSED
  }

  validates :subject, :budget, presence: true
  validates :budget, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

end

