class NoticesController < ApplicationController
  before_action :authenticate_user!
  def index
  # 既読のお知らせID一覧を先に取る
  read_ids = current_user.notice_reads.pluck(:notice_id)

  # 未読と既読を分ける
  unread = Notice.published.where.not(id: read_ids)
  read   = Notice.published.where(id: read_ids)

  # 並び順ルール（締切ありを優先 → 締切日昇順 → 掲載日降順）
  order_sql = Arel.sql("CASE WHEN due_on IS NULL THEN 1 ELSE 0 END, due_on ASC, published_at DESC")

  # 未読を上、既読を下に連結して返す
  @notices = unread.order(order_sql).to_a + read.order(order_sql).to_a

  # ビューで「未読バッジ」を判定できるように既読IDを渡す
  @read_ids = read_ids
  end

  def show
    @notice = Notice.find(params[:id])
    NoticeRead.create_with(read_at: Time.current)
            .find_or_create_by!(user_id: current_user.id, notice_id: @notice.id)
  end
end
