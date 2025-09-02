Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]  # 自己サインアップ禁止
  
  # 招待コード登録
  get  "/invite", to: "invitations#new", as: :invite
  post "/invite", to: "invitations#create"

  root "home#index"

  # お知らせ機能（一覧＆詳細）
  resources :notices, only: [:index, :show] do
    post :read, to: 'notice_reads#create'  # POST /notices/:notice_id/read
  end
  resources :notifications, only: [:index] do
    member     { patch :read }       # /notifications/:id/read
    collection { patch :read_all }   # /notifications/read_all
  end
  # 管理者ページ
  namespace :admin do
    root "dashboard#show"
    resources :notices
    resources :submission_requests
  end

  # 保護者側の既存ルート
  resources :notices, only: [:index, :show]
    post :read, to: 'notice_reads#create'
  resources :submissions, only: [:index, :show] do
    post :mark_done, on: :member
  end

  # 通知（既存）
  resources :notifications, only: [:index] do
    member { post :read }
    collection { post :read_all }
  end
end