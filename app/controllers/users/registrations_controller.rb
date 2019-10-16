# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # メアド登録のビュー表示
  def new_profile
    session['devise.regist_data'] = nil
    @user = User.new
    @user.build_profile
  end

  # メアド登録のcreate
  def create_profile
    @user = User.new(profile_params)
    if @user.valid? && @user.profile.valid?(:new_profile)
      session['devise.regist_data'] = {user: @user.attributes}
      session["devise.regist_data"][:encrypted_password] = nil
      session["devise.regist_data"][:user][:password] = params[:user][:password]
      session['devise.regist_data'][:profile] = @user.profile
      redirect_to new_sms_path
    else
      render :new_profile
    end
  end

  # SMSのビュー表示
  def new_sms
    session['devise.regist_data']['profile']['phone_number'] = nil
    @profile = Profile.new
  end

  # SMSのcreate
  def create_sms
    @profile = Profile.new(sms_params)
    if @profile.valid?(:new_sms)
      session['devise.regist_data']['profile'][:phone_number] = @profile.phone_number
      redirect_to new_address_path
    else
      render :new_sms
    end
  end

  # 住所登録のビュー表示
  def new_address
    @profile = Profile.new
    @profile.attributes = session['devise.regist_data']['profile']
  end

  # addressのcreate
  # session全てsaveする
  def create_address
    # 入力内容のチェック
    @profile = Profile.new(address_params)
    render :new_address and return unless @profile.valid?(:new_address)
    # profile用のsessionにaddress入力分を追加する
    session['devise.regist_data']['profile'].merge!(address_params)
    # sessionの情報からuserとprofileのインスタンスを作成する
    @user = User.new(session['devise.regist_data']['user'])
    @user.build_profile(session['devise.regist_data']['profile'])
    if @user.save!
      sign_up(resource_name, resource)
      respond_with resource, location: after_sign_up_path_for(resource)
    else

    end
  end

  # def create
  #   if session["devise.omniauth_data"]
  #     pass = Devise.friendly_token
  #     params[:user][:password] = pass
  #     params[:user][:password_confirmation] = pass
  #   end
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end

  def profile_params
    params.require(:user).permit(:nickname, :email, :password, :password_confirmation, profile_attributes: %i[first_name last_name birthday])
  end

  def sms_params
    params.require(:profile).permit(:phone_number)
  end

  def address_params
    params.require(:profile).permit(:first_name, :last_name, :postal_code, :city, :block, :building)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)

  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
