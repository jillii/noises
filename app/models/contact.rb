class Contact < ActiveRecord::Base
	validates :body, presence: true
	validates :email, presence: true
end
