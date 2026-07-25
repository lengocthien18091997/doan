class Timetable < ActiveRecord::Base
  belongs_to :teacher, class_name: "User"
  belongs_to :student, class_name: "User"
  has_one :tuition, dependent: :destroy

  enum status: { open: "open", deposit: "deposit", closed: "closed" }

end

