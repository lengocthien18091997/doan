class Review < ActiveRecord::Base
  belongs_to :request

  enum role: { teacher: 0, student: 1 }
  enum star: {
      one: 1,
      two: 2,
      three: 3,
      four: 4,
      five: 5
  }

end


