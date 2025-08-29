class Admin::DashboardController < ApplicationController
  def show
    @org = current_user.organization
    @notices_count = @org.notices.count
    @requests_count = @org.submission_requests.count
  end
end
