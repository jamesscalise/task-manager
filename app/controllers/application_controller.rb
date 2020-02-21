class ApplicationController < ActionController::Base
    helper_method :current_user
  helper_method :logged_in?

  def logged_in?
    if session[:user_id]
      true
    else
      false
    end
  end

  def current_user
    if logged_in?
      User.find(session[:user_id])
    end
  end
end
