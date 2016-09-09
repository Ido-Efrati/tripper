# @author Ido Efrati

class UsersController < ApplicationController

	def new
    	@user = User.new
	end

	# POST /user
	# POST /user.json
	# Creates a new user via the sign up form. Upon secessful creation the user will have a session
  # and will be redirected to his or her notes
	def create
 	 	@user = User.new(user_params)
  	respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to Trip, notice: 'Account successfully created.' }
        format.json { render action: 'show', status: :created, location: Trip }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Checks that given email is associated with a registered account
  def exists
    user_exists = !!User.exists?(email: params[:email])
    respond_to do |format|
      format.html
      format.json {render json: user_exists }
    end
  end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(id: session[:user_id])
    end

    # a user creation requires a name, email, password and password confirmation.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
