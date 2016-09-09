# @author Ido Efrati

class SessionsController < ApplicationController

  # Checks if user already signed in (i.e there is a session). If there is a session the user will be redirected to his/her notes
  # else the user will be redirected to login page
  def new
    if signed_in?
      redirect_to trips_path
    end
  end

  # Authenticate user email and password. If sucessful then create a session for the user, otherwise alert error message.
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to trips_path
    else
      redirect_to signin_path, :flash => { :error => "Invalid email/password combination" }
    end
  end

  # Destroy the session and redirect the user to the login page
  def destroy
    sign_out
    redirect_to root_url
  end

end

