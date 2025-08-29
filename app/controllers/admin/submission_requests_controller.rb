class Admin::SubmissionRequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  def index
    @requests = current_user.organization.submission_requests.order(due_on: :asc, id: :desc)
  end

  def show
  end

  def new
    @request = current_user.organization.submission_requests.new(status: :published)
  end

  def edit
  end
  def create
    @request = current_user.organization.submission_requests.new(request_params)
    if @request.save
      redirect_to admin_submission_request_path(@request), notice: "作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end
  def update
    if @request.update(request_params)
      redirect_to admin_submission_request_path(@request), notice: "更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @request.destroy
    redirect_to admin_submission_requests_path, notice: "削除しました"
  end

  private
  def set_request
    @request = current_user.organization.submission_requests.find(params[:id])
  end

  def request_params
    params.require(:submission_request).permit(:title, :description, :due_on, :status)
  end
end
