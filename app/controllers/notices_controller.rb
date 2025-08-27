class NoticesController < ApplicationController
  before_action :authenticate_user!
  def index
    @notices = Notice
      .where("published_at IS NULL OR published_at <= ?", Time.current)
      .order(Arel.sql("CASE WHEN due_on IS NULL THEN 1 ELSE 0 END, due_on ASC, published_at DESC"))
  end

  def show
    @notice = Notice.find(params[:id])
  end
end
