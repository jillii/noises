class UsersController < ApplicationController
	def index
	  if params[:search]    # if comments are requested by subject
      @users = User.search(params[:search]).order('name ASC')
    else # regular order
      @users = User.all.order('name ASC')
    end
	end
end
