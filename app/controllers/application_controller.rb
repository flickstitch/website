class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :store_location

  # redirect to current page after sign in
  def store_location
    # after registration is another special case - do not redirect to "current page"
    logger.error "DDDDDDDDDDDDDDDDDDDDDDDDD #{params[:controller]}"
    session[:user_return_to] = request.url unless ["devise/passwords", "devise/sessions", "devise/registrations"].include?(params[:controller])
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end
        
  # redirect when unauthorized
  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      redirect_to root_path, :alert => "You don't have permission to do that."
    else
      redirect_to new_user_session_url, :alert => exception.message
    end
  end
end
