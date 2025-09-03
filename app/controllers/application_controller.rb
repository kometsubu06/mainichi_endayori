class ApplicationController < ActionController::Base
  before_action :basic_auth #, if: -> {
    #Rails.env.production? && ENV["BASIC_AUTH_USER"].present? && ENV["BASIC_AUTH_PASSWORD"].present?
  #}
  before_action :authenticate_user!

  helper_method :current_organization
  def current_organization
    current_user&.organization
  end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end
  def redirect_home_not_found
    redirect_to root_path, alert: "ページが見つかりませんでした。", status: :see_other
  end
end
