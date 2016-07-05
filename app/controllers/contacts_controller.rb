class ContactsController < ApplicationController
  def index
  end

  def new
  	@contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if user_signed_in?
      @contact.name = current_user.name
      @contact.email = current_user.email
    end
    if @contact.save
      UserMailer.mail_jill(@contact).deliver
      redirect_to root_path, notice: 'Email sent.'
    else
      redirect_to new_contact_path, alert: 'Email could not be sent.'
    end
  end


	def contact_params
		params.require(:contact).permit(:name, :email, :subject, :body)
	end
end
