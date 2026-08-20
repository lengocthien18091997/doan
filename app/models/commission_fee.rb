class CommissionFee < ActiveRecord::Base
  belongs_to :timetable
  belongs_to :teacher, class_name: "User"
  belongs_to :student, class_name: "User"

  STATUSES = %w[new pending_admin done].freeze

  validates :amount, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: STATUSES }
  validates :timetable_id, uniqueness: true
end