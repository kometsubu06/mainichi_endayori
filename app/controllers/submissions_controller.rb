class SubmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_children_ids
  before_action :set_request, only: [:show, :mark_done]

  # 一覧：締切順＋未提出上位
  def index
    base = SubmissionRequest.for_org(current_user.organization_id)
    base = base.status_published if SubmissionRequest.respond_to?(:statuses)

    # 自分の子の提出状況をまとめて取得
    done_pairs = Submission.where(child_id: @children_ids)
                           .group(:submission_request_id)
                           .count # { request_id => 件数(=提出済み子数) }

    # 未提出フラグ（自分の子のうち一人でも未提出なら未提出扱い）
    @requests = base
      .select(<<~SQL)
        submission_requests.*,
        CASE
          WHEN #{@children_ids.empty? ? '1=1' : "COALESCE((SELECT COUNT(*) FROM submissions s WHERE s.submission_request_id = submission_requests.id AND s.child_id IN (#{@children_ids.join(',')})), 0)"} >= #{[@children_ids.size, 1].max}
          THEN 1 ELSE 0
        END AS my_done
      SQL
      .order(Arel.sql('my_done ASC'), :due_on, :id)  # 未提出(0)が上位 → 締切 → id

    # ビュー用のハッシュ（高速）
    @done_map = done_pairs
  end

  # 詳細
  def show
    # 自分の子供に対する提出状況
    @my_done = Submission.exists?(submission_request_id: @request.id, child_id: @children_ids)
  end

  # 提出済みにする（= 子ごとに Submission を作成）
  # - 子が1人：その子で作成
  # - 子が複数：params[:child_id] があればその子、無ければ 422 を返す（UXは後で整える）
  def mark_done
    child_id = params[:child_id]&.to_i
    if @children_ids.empty?
      return head :forbidden  # 保護者で子が紐づいていない
    elsif @children_ids.many?
      unless child_id && @children_ids.include?(child_id)
        return respond_child_required
      end
    else
      child_id = @children_ids.first
    end

    begin
      sub = Submission.find_or_create_by!(submission_request_id: @request.id, child_id: child_id) do |s|
        s.submitted_by = current_user.id
        s.submitted_at = Time.zone.now
        s.status = :done
      end
      # 監査ログ（初回のみ）
      if sub.previously_new_record? || sub.saved_change_to_status?
        AuditLog.create!(
          user: current_user,
          action: 'submission.mark_done',
          notice_id: nil,                 # 依頼は notice ではないので nil
          occurred_at: sub.submitted_at || Time.zone.now,
          metadata: { submission_request_id: @request.id, child_id: child_id }
        )
      end
    rescue ActiveRecord::RecordNotUnique
      # 競合はOK扱い
    end

    respond_ok
  end

  private

  def set_children_ids
    @children_ids = current_user.children.pluck(:id)
  end

  def set_request
    @request = SubmissionRequest.for_org(current_user.organization_id).find(params[:id])
  end

  def respond_ok
    respond_to do |f|
      f.json { render json: { status: 'ok' }, status: :ok }
      f.turbo_stream do
        # 一覧/詳細の状態を置き換える（後述のパーシャル利用）
        render turbo_stream: turbo_stream.update('submission-flash', '提出済みにしました')
      end
      f.html { redirect_back fallback_location: submission_path(@request), notice: '提出済みにしました' }
    end
  end

  def respond_child_required
    respond_to do |f|
      f.json { render json: { error: 'child_id is required' }, status: :unprocessable_entity }
      f.html { redirect_to submission_path(@request), alert: 'お子さまを選択してください' }
    end
  end
end
