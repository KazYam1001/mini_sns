class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,
  :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  # associations
  has_many :sns_credentials
  has_many :cards
  has_one  :profile
  accepts_nested_attributes_for :profile

  # validation
  validates :nickname, presence: true

  def self.from_omniauth(auth)
    # authのproviderとuidを使ってsns_credentialのレコードを取得orビルドする
    sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_initialize
    # sns認証したことがあればアソシエーションで取得する
    # 無ければemailでユーザー検索して取得orビルドする(保存はしない)
    user = sns.user || User.where(email: auth.info.email).first_or_initialize(
      nickname: auth.info.name,
      email: auth.info.email
    )
    user
  end

end
