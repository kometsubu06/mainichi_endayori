class UnsubmittedReminderJob < ApplicationJob
  queue_as :default
  SUPPRESSION_WINDOW = 4.hours

  def perform(when_tag: nil)
    User.find_each do |user|
      org_id = user.organization_id or next
      children_ids = user.children.pluck(:id)
      next if children_ids.empty?

      base = SubmissionRequest.for_org(org_id)
      base = base.status_published if SubmissionRequest.respond_to?(:statuses)

      # 自分の子のうち、1人でも未提出なら対象
      unsubmitted = base
        .where.not(
          id: Submission.where(child_id: children_ids).select(:submission_request_id)
        )
        .order(due_on: :asc).limit(50)

      next if unsubmitted.blank?

      # 直近は抑止
      next if user.notifications.where(kind: :unread_digest) # 種別を分けたければ enum 追加
               .where('created_at >= ?', Time.zone.now - SUPPRESSION_WINDOW)
               .exists?

      lines = unsubmitted.first(5).map { |r| "- #{r.title}#{r.due_on ? "（締切: #{I18n.l(r.due_on, format: :short)}）" : ''}" }
      lines << "…ほか#{unsubmitted.size - 5}件" if unsubmitted.size > 5

      user.notifications.create!(
        kind: :submission_reminder,
        title: '未提出の依頼があります',
        body: lines.join("\n"),
        metadata: { count: unsubmitted.size, when: when_tag }
      )

      AuditLog.create!(
        user: user, action: 'submission.remind', occurred_at: Time.zone.now,
        metadata: { count: unsubmitted.size, when: when_tag }
      )
    end
  end
end