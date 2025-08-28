class NoticesController < ApplicationController
  before_action :authenticate_user!
  def index
    base = Notice.where(organization_id: current_user.organization_id)
                 .order(due_on: :asc) # 並び替えはあなたの既存ロジックに合わせてOK
    # もし enum で公開状態があるなら:
    base = base.published if Notice.respond_to?(:statuses) && Notice.statuses.key?('published')

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
    @notice = Notice.find(params[:id])
    @unread = !NoticeRead.exists?(user_id: current_user.id, notice_id: @notice.id)
  end
end
