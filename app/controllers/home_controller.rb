class HomeController < ApplicationController
  before_action :authenticate_user!   # 未ログインはDeviseのログインへ
  def index
  end
end
