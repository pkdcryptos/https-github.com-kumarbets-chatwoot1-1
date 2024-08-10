module ActivityMessageHandler
  extend ActiveSupport::Concern

  include PriorityActivityMessageHandler

  include TeamActivityMessageHandler

  private


  def determine_user_name
    Current.user&.name
  end

  def handle_status_change(user_name)
    return unless saved_change_to_status?

    status_change_activity(user_name)
  end

  def handle_priority_change(user_name)
    return unless saved_change_to_priority?

  end




  def status_change_activity(user_name)
    content = user_status_change_activity_content(user_name)
              

    ::Conversations::ActivityMessageJob.perform_later(self, activity_message_params(content)) if content
  end

  def user_status_change_activity_content(user_name)
    if user_name
      I18n.t("conversations.activity.status.#{status}", user_name: user_name)
    elsif Current.contact.present? && resolved?
      I18n.t('conversations.activity.status.contact_resolved', contact_name: Current.contact.name.capitalize)
    elsif resolved?
      I18n.t('conversations.activity.status.auto_resolved', duration: auto_resolve_duration)
    end
  end



  def activity_message_params(content)
    { account_id: account_id, inbox_id: inbox_id, message_type: :activity, content: content }
  end

  def create_muted_message
    create_mute_change_activity('muted')
  end

  def create_unmuted_message
    create_mute_change_activity('unmuted')
  end

  def create_mute_change_activity(change_type)
    return unless Current.user

    content = I18n.t("conversations.activity.#{change_type}", user_name: Current.user.name)
    ::Conversations::ActivityMessageJob.perform_later(self, activity_message_params(content)) if content
  end

  def generate_assignee_change_activity_content(user_name)
    params = { assignee_name: assignee&.name, user_name: user_name }.compact
    key = assignee_id ? 'assigned' : 'removed'
    key = 'self_assigned' if self_assign? assignee_id
    I18n.t("conversations.activity.assignee.#{key}", **params)
  end

  def create_assignee_change_activity(user_name)
    user_name = activity_message_owner(user_name)

    return unless user_name

    content = generate_assignee_change_activity_content(user_name)
    ::Conversations::ActivityMessageJob.perform_later(self, activity_message_params(content)) if content
  end

  def activity_message_owner(user_name)
    user_name = 'Automation System' if !user_name && Current.executed_by.present?
    user_name
  end
end
