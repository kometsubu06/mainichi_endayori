Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]  # 自己サインアップ禁止

  get  "/invite", to: "invitations#new"
  post "/invite", to: "invitations#create"

  # ログイン後の仮ルート（後でTodayやNoticesに差し替えOK）
  root "invitations#new"
end
