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

    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
    else
      session["devise.omniauth_data"] = request.env["omniauth.auth"].except('extra')
      redirect_to new_user_registration_url
    end
  end
end
