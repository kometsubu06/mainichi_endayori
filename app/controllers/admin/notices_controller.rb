class Admin::NoticesController < ApplicationController
  before_action :set_notice, only: [:show, :edit, :update, :destroy]
  def index
    @notices = current_user.organization.notices.order(published_at: :desc, id: :desc)
  end

  def show
    
  end

  def create
    @notice = current_user.organization.notices.new(notice_params)
    if @notice.save
      redirect_to admin_notice_path(@notice), notice: "作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end
  def new
    @notice = current_user.organization.notices.new(published_at: Time.current, status: 0)
  end

  def edit
  end
  def update
    if @notice.update(notice_params)
      redirect_to admin_notice_path(@notice), notice: "更新しました"
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
    params.require(:notice).permit(:title, :body, :due_on, :require_submission, :published_at, :status)
  end
end
