class Profile < ApplicationRecord
  # association
  belongs_to :user, optional: :true

  # validation
  validates :first_name, :last_name, :birthday, presence: true, on: :new_profile
  validates :phone_number, presence: true, length: { in: 11..13 }, on: :new_sms
  validates :first_name, :last_name, :postal_code, :city, :block, presence: true, on: :new_address
  validates :postal_code, length: { is: 8 }, on: :new_address
end
