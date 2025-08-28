class NoticeReadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notice
  def create
    return head :forbidden if @notice.organization_id != current_user.organization_id

    # 既読済みなら冪等に200
    if NoticeRead.exists?(user_id: current_user.id, notice_id: @notice.id)
      return respond_ok
  end
  # 競合に強い作成：UNIQUE違反はOK扱いで救済
    begin
      NoticeRead.find_or_create_by!(user_id: current_user.id, notice_id: @notice.id) do |nr|
        nr.read_at = Time.current
      end
    rescue ActiveRecord::RecordNotUnique
      return respond_ok
    end

    respond_ok
  end

  private

  def set_notice
    @notice = Notice.find(params[:notice_id])
  end

  def respond_ok
    respond_to do |format|
      format.json { render json: { status: 'ok', read: true }, status: :ok }
      # Turboでバッジだけ差し替える（部分テンプレに notice と unread を渡す）
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          dom_id(@notice, :badge),
          partial: 'notices/badge',
          locals: { notice: @notice, unread: false }
        )
      end
      format.html { redirect_back fallback_location: notice_path(@notice), notice: '既読にしました' }
    end
  end
end
