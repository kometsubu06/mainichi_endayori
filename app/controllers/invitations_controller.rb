class InvitationsController < ApplicationController
  before_action :redirect_if_signed_in, only: [:new, :create]

  def new
  end

  def create
    code = params[:code].to_s.strip
    inv  = Invitation.usable.find_by(code: code)

    unless inv
      redirect_to invite_path, alert: "招待コードが無効か、期限切れです" and return
    end

    user = User.find_or_initialize_by(email: params[:email].to_s.strip.downcase)
    user.name  = params[:name].to_s.strip
    user.role  ||= inv.role || :guardian
    user.organization_id ||= inv.organization_id
    user.password = params[:password] if user.new_record? || params[:password].present?

    ActiveRecord::Base.transaction do
      user.save!
      inv.mark_used!
    end

    sign_in(user)
    redirect_to after_signup_path, notice: "登録が完了しました"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to invite_path, alert: e.record.errors.full_messages.join(", ")
  end

  private

  def redirect_if_signed_in
    redirect_to after_signup_path, notice: "すでにログイン済みです" if user_signed_in?
  end

  # ログイン後の遷移先（あとで Today/Notices に差し替えOK）
  def after_signup_path
    main_app.respond_to?(:notices_path) ? notices_path : root_path
  end
end