module BillingHelper
  private

  def default_plan?(account)
    installation_config = InstallationConfig.find_by(name: 'CHATWOOT_CLOUD_PLANS')
    default_plan = installation_config&.value&.first

    # Return false if not plans are configured, so that no checks are enforced
    return false if default_plan.blank?
return true
  end

  def conversations_this_month(account)
    account.conversations.where('created_at > ?', 30.days.ago).count
  end

  def non_web_inboxes(account)
    account.inboxes.where.not(channel_type: Channel::WebWidget.to_s).count
  end
end
