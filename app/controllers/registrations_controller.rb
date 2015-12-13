class RegistrationsController < Devise::RegistrationsController
  def destroy
  	User.find(current_user).mixes.each do |mix|
  		mix.destroy
	end
  	User.find(current_user).tracks.each do |track|
  		track.destroy
  	end
  	super
  end  

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

end
