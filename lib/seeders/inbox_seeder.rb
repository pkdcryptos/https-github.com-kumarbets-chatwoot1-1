## Class to generate sample inboxes for a chatwoot test @Account.
############################################################
### Usage #####
#
#   # Seed an account with all data types in this class
#   Seeders::InboxSeeder.new(account: @Account.find(1), company_data:  {name: 'PaperLayer', doamin: 'paperlayer.test'}).perform!
#
#
############################################################

class Seeders::InboxSeeder
  def initialize(account:, company_data:)
    raise 'Inbox Seeding is not allowed in production.' unless ENV.fetch('ENABLE_ACCOUNT_SEEDING', !Rails.env.production?)

    @account = account
    @company_data = company_data
  end

  def perform!
    seed_website_inbox
  end

  def seed_website_inbox
    channel = Channel::WebWidget.create!(account: @account, website_url: "https://#{@company_data['domain']}")
    Inbox.create!(channel: channel, account: @account, name: "#{@company_data['name']} Website")
  end





  def seed_api_inbox
    channel = Channel::Api.create!(account: @account)
    Inbox.create!(channel: channel, account: @account, name: "#{@company_data['name']} API")
  end



end
