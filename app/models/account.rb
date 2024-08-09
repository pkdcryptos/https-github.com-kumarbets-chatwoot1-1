# == Schema Information
#
# Table name: accounts
#
#  id                    :integer          not null, primary key
#  auto_resolve_duration :integer
#  custom_attributes     :jsonb
#  domain                :string(100)
#  feature_flags         :bigint           default(0), not null
#  limits                :jsonb
#  locale                :integer          default("en")
#  name                  :string           not null
#  status                :integer          default("active")
#  support_email         :string(100)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_accounts_on_status  (status)
#

class Account < ApplicationRecord
  # used for single column multi flags
  include FlagShihTzu
  include Featurable
  include CacheKeys

  DEFAULT_QUERY_SETTING = {
    flag_query_mode: :bit_operator,
    check_for_column: false
  }.freeze

  validates :auto_resolve_duration, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 999, allow_nil: true }
  validates :domain, length: { maximum: 100 }

  has_many :account_users, dependent: :destroy_async
  has_many :api_channels, dependent: :destroy_async, class_name: '::Channel::Api'




  has_many :contacts, dependent: :destroy_async
  has_many :conversations, dependent: :destroy_async



  has_many :inboxes, dependent: :destroy_async
  has_many :labels, dependent: :destroy_async

  has_many :messages, dependent: :destroy_async



  has_many :teams, dependent: :destroy_async
  has_many :users, through: :account_users
  has_many :web_widgets, dependent: :destroy_async, class_name: '::Channel::WebWidget'

  has_many :working_hours, dependent: :destroy_async



  enum locale: LANGUAGES_CONFIG.map { |key, val| [val[:iso_639_1_code], key] }.to_h
  enum status: { active: 0, suspended: 1 }

  before_validation :validate_limit_keys
  after_create_commit :notify_creation
  after_destroy :remove_account_sequences

  def agents
    users.where(account_users: { role: :agent })
  end

  def administrators
    users.where(account_users: { role: :administrator })
  end






  def support_email
    super.presence || ENV.fetch('MAILER_SENDER_EMAIL') { GlobalConfig.get('MAILER_SUPPORT_EMAIL')['MAILER_SUPPORT_EMAIL'] }
  end

  def usage_limits
    {
      agents: ChatwootApp.max_limit.to_i,
      inboxes: ChatwootApp.max_limit.to_i
    }
  end

  private

  def notify_creation
    Rails.configuration.dispatcher.dispatch(ACCOUNT_CREATED, Time.zone.now, account: self)
  end

  trigger.after(:insert).for_each(:row) do
    "execute format('create sequence IF NOT EXISTS conv_dpid_seq_%s', NEW.id);"
  end

  trigger.name('camp_dpid_before_insert').after(:insert).for_each(:row) do
    "execute format('create sequence IF NOT EXISTS camp_dpid_seq_%s', NEW.id);"
  end

  def validate_limit_keys
    # method overridden in enterprise module
  end

  def remove_account_sequences
    ActiveRecord::Base.connection.exec_query("drop sequence IF EXISTS camp_dpid_seq_#{id}")
    ActiveRecord::Base.connection.exec_query("drop sequence IF EXISTS conv_dpid_seq_#{id}")
  end
end

Account.prepend_mod_with('Account')
Account.include_mod_with('Concerns::Account')

