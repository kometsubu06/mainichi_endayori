Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]  # 自己サインアップ禁止
  
  # 招待コード登録
  get  "/invite", to: "invitations#new", as: :invite
  post "/invite", to: "invitations#create"

  root "home#index"

  # お知らせ（一覧・詳細）＋既読記録
  resources :notices, only: [:index, :show] do
    post :read, to: "notice_reads#create"   # POST /notices/:notice_id/read
  end

  # 提出物（一覧・詳細）
  resources :submissions, only: [:index, :show] do
    post :mark_done, on: :member
  end

  # 通知
  resources :notifications, only: [:index] do
    member     { patch :read }      # /notifications/:id/read
    collection { patch :read_all }  # /notifications/read_all
  end

  # 管理者ページ
  namespace :admin do
    root "dashboard#show"
    resources :notices
    resources :submission_requests
  end
end