require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "forgot password sends a new password" do
    user = User.create!(email: "forgot@example.com", password: "oldpass", role: "student")

    post forgot_password_path, params: { email: user.email }

    assert_redirected_to login_path
    assert_equal "mật khẩu mới đã được gửi trong mail", flash[:notice]
    assert_not_equal "oldpass", user.reload.password
  end
end
