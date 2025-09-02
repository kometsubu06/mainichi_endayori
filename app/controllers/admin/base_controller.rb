class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :require_admin!

  private

  def require_admin!
    unless current_user&.role == "admin"
      redirect_to root_path, alert: "管理者のみアクセスできます"
    end
  end
end