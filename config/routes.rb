Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]  # 自己サインアップ禁止
  
  # 招待コード登録
  get  "/invite", to: "invitations#new", as: :invite
  post "/invite", to: "invitations#create"

  # 仮トップ
  get "home", to: "home#index"
  root "home#index"

  # お知らせ機能（一覧＆詳細）
  resources :notices, only: [:index, :show] do
    post :read, to: 'notice_reads#create'  # POST /notices/:notice_id/read
  end
  resources :notifications, only: [:index] do
    member     { patch :read }       # /notifications/:id/read
    collection { patch :read_all }   # /notifications/read_all
end
end
