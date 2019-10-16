Rails.application.routes.draw do
  root 'users#index'  # ログインor新規登録を選ぶページ
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get 'users/new_profile' => 'users/registrations#new_profile', as: :new_profile
    post 'users/profile' => 'users/registrations#create_profile', as: :reg_profile
    get 'users/new_sms' => 'users/registrations#new_sms', as: :new_sms
    post 'users/sms' => 'users/registrations#create_sms', as: :reg_sms
    get 'users/new_address' => 'users/registrations#new_address', as: :new_address
    post 'users/address' => 'users/registrations#create_address', as: :reg_address
    get 'users/complete' => 'users/registrations#complete', as: :complete_registration
  end

  resources :cards, only: %i[ index new create ]
  resources :users, only: :new
end
