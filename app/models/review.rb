class Review < ActiveRecord::Base
  belongs_to :request

  enum role: { teacher: Constant::REVIEW_ROLE_TEACHER, student: Constant::REVIEW_ROLE_STUDENT }
  enum star: {
      one: 1,
      two: 2,
      three: 3,
      four: 4,
      five: 5
  }

end


