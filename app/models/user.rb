# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  availability           :integer          default("online")
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  custom_attributes      :jsonb
#  display_name           :string
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  message_signature      :text
#  name                   :string           not null
#  provider               :string           default("email"), not null
#  pubsub_token           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  tokens                 :json
#  type                   :string
#  ui_settings            :jsonb
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email)
#  index_users_on_pubsub_token          (pubsub_token) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#

class User < ApplicationRecord
  include AccessTokenable

  # Include default devise modules.
  include DeviseTokenAuth::Concerns::User
  include Pubsubable
  include Rails.application.routes.url_helpers
  include SsoAuthenticatable
  include UserAttributeHelpers

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable,
         :password_has_required_content,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # TODO: remove in a future version once online status is moved to account users
  # remove the column availability from users
  enum availability: { online: 0, offline: 1, busy: 2 }

  # The validation below has been commented out as it does not
  # work because :validatable in devise overrides this.
  # validates_uniqueness_of :email, scope: :account_id

  validates :email, presence: true

  has_many :account_users, dependent: :destroy_async
  has_many :accounts, through: :account_users
  accepts_nested_attributes_for :account_users

  has_many :assigned_conversations, foreign_key: 'assignee_id', class_name: 'Conversation', dependent: :nullify, inverse_of: :assignee
  alias_attribute :conversations, :assigned_conversations
  has_many :conversation_participants, dependent: :destroy_async
  has_many :participating_conversations, through: :conversation_participants, source: :conversation

  has_many :inbox_members, dependent: :destroy_async
  has_many :inboxes, through: :inbox_members, source: :inbox
  has_many :messages, as: :sender, dependent: :nullify
  has_many :invitees, through: :account_users, class_name: 'User', foreign_key: 'inviter_id', source: :inviter, dependent: :nullify




  # rubocop:enable Rails/HasManyOrHasOneDependent

  before_validation :set_password_and_uid, on: :create


  scope :order_by_full_name, -> { order('lower(name) ASC') }

  before_validation do
    self.email = email.try(:downcase)
  end

  def send_devise_notification(notification, *args)
    
  end

  def set_password_and_uid
    self.uid = email
  end

  def assigned_inboxes
    administrator? ? Current.account.inboxes : inboxes.where(account_id: Current.account.id)
  end

  def serializable_hash(options = nil)
    super(options).merge(confirmed: confirmed?)
  end

  def push_event_data
    {
      id: id,
      name: name,
      available_name: available_name,
      type: 'user',
      availability_status: availability_status,
    }
  end



  # https://github.com/lynndylanhurley/devise_token_auth/blob/6d7780ee0b9750687e7e2871b9a1c6368f2085a9/app/models/devise_token_auth/concerns/user.rb#L45
  # Since this method is overriden in devise_token_auth it breaks the email reconfirmation flow.
  def will_save_change_to_email?
    mutations_from_database.changed?('email')
  end

  def self.from_email(email)
    find_by(email: email&.downcase)
  end

  private


end


User.include_mod_with('Concerns::User')
