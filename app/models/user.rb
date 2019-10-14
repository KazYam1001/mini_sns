class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,
  :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  # associations
  has_many :sns_credentials
  has_one  :profile

  def self.from_omniauth(auth)
    # authのproviderとuidを使ってsns_credentialのレコードを取得or保存する
    sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_create
    # sns認証したことがあればアソシエーションで取得する
    # 無ければemailでユーザー検索して取得orビルドする(保存はしない)
    user = sns.user || User.where(email: auth.info.email).first_or_initialize(
      nickname: auth.info.name,
      email: auth.info.email
    )
    # 登録済みuserはそのままログインの処理へ行くので、ここでsnsのuser_idを更新しておく
    sns.update(user_id: user.id) if user.persisted?
    user
  end

end
