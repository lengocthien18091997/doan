class SessionsController < ApplicationController

  skip_before_action :authorization, only: [:new, :create]

  # GET /login
  def new
  end

  # POST /login
  def create
    user = User.find_by(email: params[:email])
    if user && user.password == params[:password]
      token = generate_session_token(user.id)
      session_user = user.sessions.create!(
          user_id: user.id,
          ip_address: request.remote_ip,
          user_agent: request.user_agent,
          session_token: token
      )
      session[:session_token] = session_user.session_token
      flash[:notice] = "Đăng nhập thành công!"
      redirect_to root_path
    else
      flash.now[:alert] = "Sai email hoặc mật khẩu!"
      render :new, status: :unprocessable_entity
    end
  end

  def generate_session_token(user_id)
    token = SecureRandom.hex(16)
    timestamp = Time.now.to_i           # thời gian hiện tại dạng số giây
    "#{token}-#{user_id}-#{timestamp}" # ghép thành 1 chuỗi duy nhất
  end

  def destroy
    Session.where(session_token: session[:session_token]).delete_all
    session[:session_token] = nil
    @current_user = nil
    flash[:notice] = "Đã đăng xuất!"
    redirect_to login_path
  end
end

