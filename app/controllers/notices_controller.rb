class NoticesController < ApplicationController
  before_action :authenticate_user!
  require 'set'
  def index
    base = Notice.where(organization_id: current_user.organization_id)
                 .visible_to_guardian
                 .order(due_on: :asc) 
    
    @notices =
      if params[:filter] == 'unread'
        base.where.not(id: NoticeRead.where(user_id: current_user.id).select(:notice_id))
      else
        base
      end

    # 自分が既読にした notice_id を一括取得して Set 化（O(1) 判定）
    @read_ids = NoticeRead.where(user_id: current_user.id)
                          .pluck(:notice_id)
                          .to_set
  end

  def show
    @notice = Notice.where(organization_id: current_user.organization_id).visible_to_guardian.find(params[:id])

  # 既読レコードを作成（なければ）
    nr = NoticeRead.find_or_create_by(user_id: current_user.id, notice_id: @notice.id) do |r|
      r.read_at = Time.zone.now
    end

  # 初回だけ監査ログ
    if nr.previously_new_record?
      AuditLog.create!(
        user: current_user,
        action: 'notice.read',
        notice_id: @notice.id,
        occurred_at: nr.read_at || Time.zone.now,
        metadata: { via: 'show' }
      )
    end

    @unread = false
  rescue ActiveRecord::RecordNotFound
    redirect_to notices_path, alert: "このお知らせは見つからないか、まだ公開されていません。"
  end
end