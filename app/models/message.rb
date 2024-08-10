# == Schema Information
#
# Table name: messages
#
#  id                        :integer          not null, primary key
#  additional_attributes     :jsonb
#  content                   :text
#  content_attributes        :json
#  content_type              :integer          default("text"), not null
#  external_source_ids       :jsonb
#  message_type              :integer          not null
#  private                   :boolean          default(FALSE), not null
#  processed_message_content :text
#  sender_type               :string
#  sentiment                 :jsonb
#  status                    :integer          default("sent")
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  account_id                :integer          not null
#  conversation_id           :integer          not null
#  inbox_id                  :integer          not null
#  sender_id                 :bigint
#  source_id                 :string
#
# Indexes
#
#  index_messages_on_account_created_type               (account_id,created_at,message_type)
#  index_messages_on_account_id                         (account_id)
#  index_messages_on_account_id_and_inbox_id            (account_id,inbox_id)
#  index_messages_on_additional_attributes_campaign_id  (((additional_attributes -> 'campaign_id'::text))) USING gin
#  index_messages_on_content                            (content) USING gin
#  index_messages_on_conversation_account_type_created  (conversation_id,account_id,message_type,created_at)
#  index_messages_on_conversation_id                    (conversation_id)
#  index_messages_on_created_at                         (created_at)
#  index_messages_on_inbox_id                           (inbox_id)
#  index_messages_on_sender_type_and_sender_id          (sender_type,sender_id)
#  index_messages_on_source_id                          (source_id)
#

class Message < ApplicationRecord
  include MessageFilterHelpers
  include Liquidable
  NUMBER_OF_PERMITTED_ATTACHMENTS = 15

  TEMPLATE_PARAMS_SCHEMA = {
    'type': 'object',
    'properties': {
      'template_params': {
        'type': 'object',
        'properties': {
          'name': { 'type': 'string' },
          'language': { 'type': 'string' },
          'namespace': { 'type': 'string' },
          'processed_params': { 'type': 'object' }
        },
        'required': %w[name]
      }
    }
  }.to_json.freeze

  before_validation :ensure_content_type
  before_validation :prevent_message_flooding
  before_save :ensure_processed_message_content
  before_save :ensure_in_reply_to

  validates :account_id, presence: true
  validates :inbox_id, presence: true
  validates :conversation_id, presence: true
  validates_with ContentAttributeValidator


  validates :content_type, presence: true
  validates :content, length: { maximum: 150_000 }
  validates :processed_message_content, length: { maximum: 150_000 }

  # when you have a temperory id in your frontend and want it echoed back via action cable
  attr_accessor :echo_id

  enum message_type: { incoming: 0, outgoing: 1, activity: 2, template: 3 }
  enum content_type: {
    text: 0,
    input_text: 1,
    input_textarea: 2,
    input_email: 3,
    input_select: 4,
    cards: 5,
    form: 6,
    article: 7,
    incoming_email: 8,
    input_csat: 9,
    integrations: 10,
    sticker: 11
  }
  enum status: { sent: 0, delivered: 1, read: 2, failed: 3 }
  # [:submitted_email, :items, :submitted_values] : Used for bot message types
  # [:email] : Used by conversation_continuity incoming email messages
  # [:in_reply_to] : Used to reply to a particular tweet in threads
  # [:deleted] : Used to denote whether the message was deleted by the agent
  # [:external_created_at] : Can specify if the message was created at a different timestamp externally
  # [:external_error : Can specify if the message creation failed due to an error at external API
  store :content_attributes, accessors: [:submitted_email, :items, :submitted_values, :email, :in_reply_to, :deleted,
                                         :external_created_at, :story_sender, :story_id, :external_error,
                                         :translations, :in_reply_to_external_id, :is_unsupported], coder: JSON

  store :external_source_ids, coder: JSON, prefix: :external_source_id

  scope :created_since, ->(datetime) { where('created_at > ?', datetime) }
  scope :chat, -> { where.not(message_type: :activity).where(private: false) }
  scope :non_activity_messages, -> { where.not(message_type: :activity).reorder('id desc') }
  scope :today, -> { where("date_trunc('day', created_at) = ?", Date.current) }

  # TODO: Get rid of default scope
  # https://stackoverflow.com/a/1834250/939299
  # if you want to change order, use `reorder`
  default_scope { order(created_at: :asc) }

  belongs_to :account
  belongs_to :inbox
  belongs_to :conversation, touch: true
  belongs_to :sender, polymorphic: true, optional: true

  has_many :attachments, dependent: :destroy, autosave: true, before_add: :validate_attachments_limit


  after_create_commit :execute_after_create_commit_callbacks

  after_update_commit :dispatch_update_event

  def channel_token
    @token ||= inbox.channel.try(:page_access_token)
  end

  def push_event_data
    data = attributes.symbolize_keys.merge(
      created_at: created_at.to_i,
      message_type: message_type_before_type_cast,
      conversation_id: conversation.display_id,
      conversation: conversation_push_event_data
    )
    data[:echo_id] = echo_id if echo_id.present?
    data[:attachments] = attachments.map(&:push_event_data) if attachments.present?
    merge_sender_attributes(data)
  end

  def conversation_push_event_data
    {
      assignee_id: conversation.assignee_id,
      unread_count: conversation.unread_incoming_messages.count,
      last_activity_at: conversation.last_activity_at.to_i,
      contact_inbox: { source_id: conversation.contact_inbox.source_id }
    }
  end



  def merge_sender_attributes(data)
    data[:sender] = sender.push_event_data if sender 
    data
  end

 

  def content
    # move this to a presenter
    return self[:content] if inbox.web_widget?

  end

  def email_notifiable_message?
    return false if private?
    return false if %w[outgoing template].exclude?(message_type)
    return false if template? 

    true
  end

  def valid_first_reply?
    return false unless outgoing? && human_response? && !private?
    return false if conversation.first_reply_created_at.present?
    return false if conversation.messages.outgoing
                                .where.not(private: true).count > 1

    true
  end

 

  private

  def prevent_message_flooding
    # Added this to cover the validation specs in messages
    # We can revisit and see if we can remove this later
    return if conversation.blank?

    # there are cases where automations can result in message loops, we need to prevent such cases.
    if conversation.messages.where('created_at >= ?', 1.minute.ago).count >= Limits.conversation_message_per_minute_limit
      Rails.logger.error "Too many message: Account Id - #{account_id} : Conversation id - #{conversation_id}"
      errors.add(:base, 'Too many messages')
    end
  end

  def ensure_processed_message_content
    text_content_quoted = content_attributes.dig(:email, :text_content, :quoted)
    html_content_quoted = content_attributes.dig(:email, :html_content, :quoted)

    message_content = text_content_quoted || html_content_quoted || content
    self.processed_message_content = message_content&.truncate(150_000)
  end

  # fetch the in_reply_to message and set the external id
  def ensure_in_reply_to
    in_reply_to = content_attributes[:in_reply_to]
    in_reply_to_external_id = content_attributes[:in_reply_to_external_id]

    Messages::InReplyToMessageBuilder.new(
      message: self,
      in_reply_to: in_reply_to,
      in_reply_to_external_id: in_reply_to_external_id
    ).perform
  end

  def ensure_content_type
    self.content_type ||= Message.content_types[:text]
  end

  def execute_after_create_commit_callbacks
    # rails issue with order of active record callbacks being executed https://github.com/rails/rails/issues/20911
    reopen_conversation
    notify_via_mail
    set_conversation_activity
    dispatch_create_events
  end


  def update_waiting_since
    if human_response? && !private && conversation.waiting_since.present?
      Rails.configuration.dispatcher.dispatch(
        REPLY_CREATED, Time.zone.now, waiting_since: conversation.waiting_since, message: self
      )
      conversation.update(waiting_since: nil)
    end
    conversation.update(waiting_since: created_at) if incoming? && conversation.waiting_since.blank?
  end

  def human_response?
    # if the sender is not a user, it's not a human response
    # if automation rule id is present, it's not a human response
    # if campaign id is present, it's not a human response
    outgoing? &&
      content_attributes['automation_rule_id'].blank? &&
      sender.is_a?(User)
  end

  def dispatch_create_events
    Rails.configuration.dispatcher.dispatch(MESSAGE_CREATED, Time.zone.now, message: self, performed_by: Current.executed_by)

    if valid_first_reply?
      Rails.configuration.dispatcher.dispatch(FIRST_REPLY_CREATED, Time.zone.now, message: self, performed_by: Current.executed_by)
      conversation.update(first_reply_created_at: created_at, waiting_since: nil)
    else
      update_waiting_since
    end
  end

  def dispatch_update_event
    # ref: https://github.com/rails/rails/issues/44500
    # we want to skip the update event if the message is not updated
    return if previous_changes.blank?

    Rails.configuration.dispatcher.dispatch(MESSAGE_UPDATED, Time.zone.now, message: self, performed_by: Current.executed_by,
                                                                            previous_changes: previous_changes)
  end


  def reopen_conversation
    return if conversation.muted?
    return unless incoming?

    conversation.open! if conversation.snoozed?

    reopen_resolved_conversation if conversation.resolved?
  end

  def reopen_resolved_conversation
    # mark resolved bot conversation as pending to be reopened by bot processor service
    if  conversation.inbox.api?
      Current.executed_by = sender if reopened_by_contact?
      conversation.open!
    else
      conversation.open!
    end
  end

  def reopened_by_contact?
    incoming? && !private? && Current.user.class != sender.class && sender.instance_of?(Contact)
  end


  def email_notifiable_webwidget?
    inbox.web_widget? && inbox.channel.continuity_via_email
  end

  def email_notifiable_api_channel?
    inbox.api? && inbox.account.feature_enabled?('email_continuity_on_api_channel')
  end

  def email_notifiable_channel?
    email_notifiable_webwidget? || %w[Email].include?(inbox.inbox_type) || email_notifiable_api_channel?
  end

  def can_notify_via_mail?
    return unless email_notifiable_message?
    return unless email_notifiable_channel?
    return if conversation.contact.email.blank?

    true
  end

  def notify_via_mail
    return unless can_notify_via_mail?

    trigger_notify_via_mail
  end

  def trigger_notify_via_mail
 return
  end

  

  def validate_attachments_limit(_attachment)
    errors.add(:attachments, message: 'exceeded maximum allowed') if attachments.size >= NUMBER_OF_PERMITTED_ATTACHMENTS
  end

  def set_conversation_activity
    # rubocop:disable Rails/SkipsModelValidations
    conversation.update_columns(last_activity_at: created_at)
    # rubocop:enable Rails/SkipsModelValidations
  end
end

Message.prepend_mod_with('Message')
