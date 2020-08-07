# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :employees, dependent: :destroy
  has_many :companies, through: :employees
  has_many :events, through: :employees

  validates :name, presence: true
  validates :surname, presence: true
  validates :email, presence: true, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         authentication_keys: [:email], omniauth_providers: %i[developer alfred]

  has_one_attached :avatar

  # rubocop: disable Metrics/AbcSize
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |account|
      account.provider = auth.provider
      account.name = account.auth_provider_name(auth)
      account.surname = account.auth_provider_surname(auth)
      account.uid = auth.uid
      account.email = auth.info.email
      account.password = Devise.friendly_token[0, 20]
      account.auth_provider_avatar(auth)
    end
  end
  # rubocop: enable Metrics/AbcSize

  def auth_provider_avatar(auth)
    image_url = auth.provider == :alfred ? auth.info.avatar_url : auth.info.image

    return unless image_url.present?

    downloaded_image = URI.parse(image_url).open

    avatar.attach(
      io: downloaded_image,
      filename: 'avatar.png',
      content_type: downloaded_image.content_type
    )
  end

  def auth_provider_name(auth)
    auth.provider == :alfred ? auth.info.first_name : auth.info.name
  end

  def auth_provider_surname(auth)
    auth.provider == :alfred ? auth.info.last_name : auth.info.nickname
  end

  def full_name
    "#{surname} #{name}"
  end
end
