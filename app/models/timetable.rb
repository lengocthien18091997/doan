class Timetable < ActiveRecord::Base
  has_one :commission_fee, dependent: :destroy
  belongs_to :teacher, class_name: "User"
  belongs_to :student, class_name: "User"
  has_one :tuition, dependent: :destroy

  enum status: { open: Constant::TIMETABLE_STATUS_OPEN, deposit: Constant::TIMETABLE_STATUS_DEPOSIT, closed: Constant::TIMETABLE_STATUS_CLOSED }

end

