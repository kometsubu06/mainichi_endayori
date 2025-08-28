class UnreadReminderJob < ApplicationJob
  queue_as :default

  def perform(when_tag: nil)
    User.find_each do |user|
      org_id = user.organization_id or next

      base = Notice.where(organization_id: org_id)
      base = base.published if Notice.respond_to?(:statuses) && Notice.statuses.key?('published')

      unread = base
        .where.not(id: NoticeRead.where(user_id: user.id).select(:notice_id))
        .order(due_on: :asc)
        .limit(50)

      next if unread.blank?

      body_lines = unread.first(5).map { |n|
        "- #{n.title}#{n.due_on ? "（締切: #{I18n.l(n.due_on, format: :short)}）" : ''}"
      }
      body_lines << "…ほか#{unread.size - 5}件" if unread.size > 5

      user.notifications.create!(
        kind: :unread_digest,
        title: '未読のお知らせがあります',
        body: body_lines.join("\n"),
        metadata: { count: unread.size, when: when_tag }
      )
    end
  end
end