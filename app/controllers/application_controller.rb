# ApplicationController inherits from ActionController::Base and
# all other controllers inherits from it. It allows the configuration
# of things such as request forgery protection and filtering of
# sensitive request parameters.
#
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by uid: session[:user_id] if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def authorize
    logged_in? ? true : access_denied
  end

  def authorize_student
    session[:student_user] ? true : access_denied
  end

  def access_denied
    flash[:alert] = 'You must sign in to perform this action.'
    redirect_to new_user_session_path(origin: request.original_url) and return false
  end
end
