class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :store_location

  # redirect to current page after sign in
  def store_location
    session[:user_return_to] = request.url unless params[:controller] == "devise/sessions"
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end
        
  # redirect when unauthorized
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to new_user_session_url, :alert => exception.message
  end
end
