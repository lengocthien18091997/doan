class Support < ActiveRecord::Base
  belongs_to :user

  enum status: { open: "open", processing: "processing", closed: "closed" }
  enum category: { account: "account", payment: "payment", other: "other" }

  validates :category, :comment, presence: true
end

