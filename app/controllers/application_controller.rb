# @author Ido Efrati

class ApplicationController < ActionController::Base

  include SessionsHelper

  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception

  add_flash_types :error, :success

  private
  # Enfore user only has access to site content if logged in, else directed to login
  def require_login
    unless current_user
      flash[:notice] = "You must be logged in to access this section."
      redirect_to login_url
    end
  end

end
