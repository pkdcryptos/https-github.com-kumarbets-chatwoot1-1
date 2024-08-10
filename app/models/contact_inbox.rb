# == Schema Information
#
# Table name: contact_inboxes
#
#  id            :bigint           not null, primary key
#  hmac_verified :boolean          default(FALSE)
#  pubsub_token  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  contact_id    :bigint
#  inbox_id      :bigint
#  source_id     :string           not null
#
# Indexes
#
#  index_contact_inboxes_on_contact_id              (contact_id)
#  index_contact_inboxes_on_inbox_id                (inbox_id)
#  index_contact_inboxes_on_inbox_id_and_source_id  (inbox_id,source_id) UNIQUE
#  index_contact_inboxes_on_pubsub_token            (pubsub_token) UNIQUE
#  index_contact_inboxes_on_source_id               (source_id)
#

class ContactInbox < ApplicationRecord
  include Pubsubable
  include RegexHelper
  validates :inbox_id, presence: true
  validates :contact_id, presence: true
  validates :source_id, presence: true


  belongs_to :contact
  belongs_to :inbox

  has_many :conversations, dependent: :destroy_async

  # contact_inboxes that are not associated with any conversation
  scope :stale_without_conversations, lambda { |time_period|
    left_joins(:conversations)
      .where('contact_inboxes.created_at < ?', time_period)
      .where(conversations: { contact_id: nil })
  }


  def current_conversation
    conversations.last
  end

  private

  

end
