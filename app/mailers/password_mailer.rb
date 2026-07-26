class PasswordMailer < ApplicationMailer
  default from: "no-reply@vnedu.local"

  def new_password_email(user, new_password)
    @user = user
    @new_password = new_password
    mail(to: @user.email, subject: "Mật khẩu mới của bạn")
  end
end
