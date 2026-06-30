class Tuition < ActiveRecord::Base
  belongs_to :student, class_name: 'User'
  belongs_to :teacher, class_name: 'User'
  belongs_to :timetable, class_name: 'Timetable', optional: true

  STATUSES = %w[new deposit payed]

  validates :amount, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: STATUSES }
end

