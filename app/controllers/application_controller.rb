require 'pry'

class ApplicationController < ActionController::Base
  include ApplicationHelper
  include UserHelper
  include QrHelper

  before_action :authorization
  helper_method :current_user

  def after_sign_in_path_for(user)
    if user.role == 'teacher'
      request_list_path
    else
      root_path
    end
  end


  private

  def current_user
    return @current_user if @current_user.present?
    token = session[:session_token]
    if token
      session_record = Session.find_by(session_token: token)
      if session_record && session_record.expires_at > Time.now
        @current_user = session_record.user
      end
    end
  end

  def authorization
    redirect_to login_path unless current_user
  end
end
