Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]  # 自己サインアップ禁止
  
  get  "/invite", to: "invitations#new"
  post "/invite", to: "invitations#create"
  get "home", to: "home#index"
  root "home#index"
end
