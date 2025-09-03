class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    org_id = current_user.organization_id
    @child  = current_user.respond_to?(:guardian?) && current_user.guardian? ? current_user.children.first : nil
    @school = current_user.organization&.name || "園"

    @highlight = pick_highlight(org_id)

    # 1) 提出依頼：未提出 & 期限が近い順（保護者のみ）
    @urgent_submissions =
      if current_user.respond_to?(:guardian?) && current_user.guardian?
        child_ids = current_user.children.pluck(:id)
        submitted_ids = Submission.where(child_id: child_ids).select(:submission_request_id)
        base = SubmissionRequest.where(organization_id: org_id)
        base = base.status_published if SubmissionRequest.respond_to?(:statuses) && SubmissionRequest.statuses.key?("published")
        base.where.not(id: submitted_ids)
            .where(due_on: Date.current..(Date.current + 7))
            .order(:due_on, :id)
            .limit(3)
      else
        SubmissionRequest.none
      end

    # 2) 重要お知らせ：締切付き（7日以内）を優先、なければ締切付きすべて
    notices_base = Notice.visible_to_guardian.where(organization_id: org_id)
    @read_ids = NoticeRead.where(user_id: current_user.id).pluck(:notice_id).to_set
    with_due_soon = notices_base.where.not(due_on: nil)
                                .where(due_on: Date.current..(Date.current + 7))
                                .order(:due_on, :id)
                                .limit(3)
    @important_notices = with_due_soon.presence ||
                         notices_base.where.not(due_on: nil).order(:due_on, :id).limit(3)

    # 3) 最新のお知らせ：新着10件
    @recent_notices = notices_base.order(created_at: :desc).limit(10)
  end

  private

  # 提出依頼(未提出)で期限が近いものを最優先 → それが無ければ締切付きお知らせ
  def pick_highlight(org_id)
    # 1) 未提出の提出依頼（保護者のみ）
    if current_user.respond_to?(:guardian?) && current_user.guardian?
      child_ids = current_user.children.pluck(:id)
      if child_ids.any?
        req_base = SubmissionRequest.where(organization_id: org_id)
        req_base = req_base.status_published if SubmissionRequest.respond_to?(:statuses) && SubmissionRequest.statuses.key?('published')

        submitted = Submission.where(child_id: child_ids).select(:submission_request_id)
        urgent_req = req_base.where.not(id: submitted)
                             .where(due_on: Date.current..(Date.current + 7))
                             .order(:due_on, :id).first
        if urgent_req
          return {
            kind: :request,
            title: "提出依頼：#{urgent_req.title}",
            subtitle: urgent_req.due_on ? "締切：#{I18n.l(urgent_req.due_on)}" : nil,
            path: submission_path(urgent_req), # ※routesに合わせて submission_request_path にする場合あり
            badge: "未提出",
            icon: "fa-bell"
          }
        end
      end
    end

    # 2) 締切つきお知らせ
    urgent_notice = Notice.where(organization_id: org_id).visible_to_guardian.where.not(due_on: nil).order(:due_on, :id).first
    if urgent_notice
      {
        kind: :notice,
        title: urgent_notice.title,
        subtitle: urgent_notice.due_on ? "締切：#{I18n.l(urgent_notice.due_on)}" : nil,
        path: notice_path(urgent_notice),
        badge: urgent_notice.require_submission ? "提出あり" : "お知らせ",
        icon: "fa-bullhorn"
      }
    end
  end
end