# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authorization(:facebook)
  end

  def google_oauth2
    authorization(:google)
  end

  def failure
    redirect_to root_path
  end

  private

  def authorization(provider)
    sns_info = User.from_omniauth(request.env["omniauth.auth"])
    @user = sns_info[:user]

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
    else
      @sns_id = sns_info[:sns].id
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
      # render template: 'devise/registrations/new'
    end
  end
end
