Rails.application.routes.draw do
  root 'users#index'  # ログインor新規登録を選ぶページ
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get '/users/basic_info' => 'users/registrations#basic_info', as: :new_basic_info
    post '/users/basic_info' => 'users/registrations#add_basic', as: :add_basic
  end
  resources :users, only: :new
end
