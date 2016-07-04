class NotificationsController < ApplicationController
  def index
  	@notifications = Notification.select { |user_id| Notifiactions.user_id == current_user }
  end
end
