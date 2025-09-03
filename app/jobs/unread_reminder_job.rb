class UnreadReminderJob < ApplicationJob
  queue_as :default

  SUPPRESSION_WINDOW = 4.hours # 直近4時間に同種通知があれば抑止

  def perform(when_tag: nil)
    User.find_each do |user|
      org_id = user.organization_id
      next unless org_id

      base = Notice.where(organization_id: org_id)
      base = base.published if Notice.respond_to?(:statuses) && Notice.statuses.key?('published')

      # 未読抽出（1ユーザーあたり上限）
      unread = base
        .where.not(id: NoticeRead.where(user_id: user.id).select(:notice_id))
        .order(due_on: :asc, id: :asc)
        .limit(50)

      next if unread.blank?

      # 直近に同種通知があれば抑止（when_tagは見ない：DB依存を避けるため）
      next if user.notifications
               .where(kind: :unread_digest)
               .where('created_at >= ?', Time.zone.now - SUPPRESSION_WINDOW)
               .exists?

      body_lines = unread.first(5).map do |n|
        due = n.due_on ? "（締切: #{I18n.l(n.due_on, format: :short)}）" : ''
        "- #{n.title}#{due}"
      end
      body_lines << "…ほか#{unread.size - 5}件" if unread.size > 5

      notification = user.notifications.create!(
        kind: :unread_digest,
        title: '未読のお知らせがあります',
        body: body_lines.join("\n"),
        metadata: { count: unread.size, when: when_tag }
      )

      # （任意）リアルタイムに🔔件数を更新・一覧先頭に挿入
      broadcast_increment(user, notification)
    rescue => e
      Rails.logger.error("[UnreadReminderJob] user_id=#{user.id} when_tag=#{when_tag} error=#{e.class}: #{e.message}")
      next
    end
  end

  private

  def broadcast_increment(user, notification)
    # ActionCable/Turbo Streams を有効にしている場合のみ効く（未設定でも安全に無視されます）
    if defined?(NotificationsChannel)
      # 件数を更新
      NotificationsChannel.broadcast_update_to(
        user,
        target: 'notification-count',
        html: ApplicationController.render(inline: "<%= #{user.notifications.unread.count} %>")
      )
      # 一覧を開いている人には項目を先頭に追加
      NotificationsChannel.broadcast_prepend_to(
        user,
        target: 'notifications-list',
        partial: 'notifications/item',
        locals: { notification: notification }
      )
    end
  end
end