class Support < ActiveRecord::Base
  belongs_to :user

  enum status: { open: Constant::SUPPORT_STATUS_OPEN, processing: Constant::SUPPORT_STATUS_PROCESSING, closed: Constant::SUPPORT_STATUS_CLOSED }
  enum category: { account: Constant::SUPPORT_CATEGORY_ACCOUNT, payment: Constant::SUPPORT_CATEGORY_PAYMENT, other: Constant::SUPPORT_CATEGORY_OTHER }

  validates :category, :comment, presence: true
end

