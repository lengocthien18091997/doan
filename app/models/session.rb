class Session < ActiveRecord::Base
  belongs_to :user

  before_create :set_create_and_expire_dates
  before_update :update_expire_date

  validates :session_token, uniqueness: true, presence: true

  private

  def set_create_and_expire_dates
    self.created_at = Time.now
    self.expires_at = Time.now + 1.hours
  end

  def update_expire_date
    self.updated_at = Time.now
    self.expires_at = 1.hours.from_now
  end
end

