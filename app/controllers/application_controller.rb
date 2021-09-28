class ApplicationController < ActionController::Base

    include Pundit

    helper_method :current_user, :logged_in?
    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    def logged_in?
        !!current_user
    end

    def require_user
        if !logged_in?
            flash[:alert] = "You must be logged in to perform the action"
            redirect_to login_path
        end
    end
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

end
