class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def index
    @notifications = current_user.notifications.order(created_at: :desc).limit(100)
  end

  def read
    notification = current_user.notifications.find(params[:id])
    @notification.mark_read!
    respond_to do |f|
      f.turbo_stream
      f.html { redirect_to notifications_path, notice: '既読にしました' }
      f.json { head :ok }
    end
  end

  def read_all
    current_user.notifications.unread.update_all(
      read_at: Time.current, updated_at: Time.current
    )
    @notifications = current_user.notifications.order(created_at: :desc).limit(100)
    respond_to do |f|
      f.turbo_stream
      f.html { redirect_to notifications_path, notice: 'すべて既読にしました' }
      f.json { head :ok }
    end
  end
end
