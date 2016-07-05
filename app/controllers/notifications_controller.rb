class NotificationsController < ApplicationController
  def index
  	@notifications = Notification.all.select { |x| x.user_id == current_user.id }
  end
end
