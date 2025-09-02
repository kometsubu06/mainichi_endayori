class Admin::NoticesController < ApplicationController
  before_action :set_notice, only: [:show, :edit, :update, :destroy]
  def index
    @notices = current_user.organization.notices.order(created_at: :desc)
  end

  def show
    
  end

  def create
    @notice = current_user.organization.notices.new(notice_params)

    # 送信ボタンの種類で公開/下書きを決定
    if params[:commit] == '公開する'
      @notice.published_at ||= Time.current
    else
      @notice.published_at = nil # 明示的に下書き
    end

    if @notice.save
      redirect_to admin_notices_path, notice: 'お知らせを保存しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @notice = current_user.organization.notices.new
  end

  def edit
    @notice = current_user.organization.notices.find(params[:id])
  end
  def update
    @notice = current_user.organization.notices.find(params[:id])
    if params[:remove_image_ids].present?
      @notice.images.where(id: params[:remove_image_ids]).each(&:purge)
    end
    @notice.assign_attributes(notice_params)

    if params[:commit] == '公開する'
      @notice.published_at ||= Time.current
    elsif params[:commit] == '下書き保存'
      @notice.published_at = nil
    end

    if @notice.save
      redirect_to admin_notices_path, notice: 'お知らせを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @notice.destroy
    redirect_to admin_notices_path, notice: "削除しました"
  end

  private
  def set_notice
    @notice = current_user.organization.notices.find(params[:id])
  end

  def notice_params
    params.require(:notice).permit(:title, :body, :due_on)
  end
end
