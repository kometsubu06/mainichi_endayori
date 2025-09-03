class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :require_admin!

  helper_method :admin_user?
  private
  def admin_user?
    current_user&.respond_to?(:admin?) && current_user.admin?
  end

  def require_admin!
    is_admin = current_user&.respond_to?(:admin?) ? current_user.admin? : current_user&.role.to_s == "admin"
    return if is_admin

    respond_to do |format|
      format.html        { redirect_to root_path, alert: "管理者のみアクセスできます。", status: :see_other } # 303
      format.turbo_stream{ redirect_to root_path, alert: "管理者のみアクセスできます。", status: :see_other }
      format.json        { render json: { error: "forbidden" }, status: :forbidden }
    end
    return
  end
end