module Admin::NoticesHelper
  def notice_status_label(notice)
    return "下書き"   if notice.published_at.nil?
    return "予約公開" if notice.published_at > Time.current
    "公開中"
  end
end
