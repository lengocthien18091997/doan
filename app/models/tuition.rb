class Tuition < ActiveRecord::Base
  belongs_to :student, class_name: 'User'
  belongs_to :teacher, class_name: 'User'
  belongs_to :timetable, class_name: 'Timetable', optional: true
  belongs_to :request, optional: true

  STATUSES = [Constant::TUITION_STATUS_NEW, Constant::TUITION_STATUS_DEPOSIT, Constant::TUITION_STATUS_PAYED]

  validates :amount, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: STATUSES }
end

