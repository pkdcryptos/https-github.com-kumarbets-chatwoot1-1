json.id resource.id
json.avatar_url resource.try(:avatar_url)
json.channel_id resource.channel_id
json.name resource.name
json.channel_type resource.channel_type
json.greeting_enabled resource.greeting_enabled
json.greeting_message resource.greeting_message
json.working_hours_enabled resource.working_hours_enabled
json.enable_email_collect resource.enable_email_collect
json.enable_auto_assignment resource.enable_auto_assignment
json.auto_assignment_config resource.auto_assignment_config
json.out_of_office_message resource.out_of_office_message
json.working_hours resource.weekly_schedule
json.timezone resource.timezone
json.allow_messages_after_resolved resource.allow_messages_after_resolved
json.lock_to_single_conversation resource.lock_to_single_conversation
json.sender_name_type resource.sender_name_type
json.business_name resource.business_name


## Channel specific settings
## TODO : Clean up and move the attributes into channel sub section


## WebWidget Attributes
json.widget_color resource.channel.try(:widget_color)
json.website_url resource.channel.try(:website_url)
json.hmac_mandatory resource.channel.try(:hmac_mandatory)
json.welcome_title resource.channel.try(:welcome_title)
json.welcome_tagline resource.channel.try(:welcome_tagline)
json.web_widget_script resource.channel.try(:web_widget_script)
json.website_token resource.channel.try(:website_token)
json.selected_feature_flags resource.channel.try(:selected_feature_flags)
json.reply_time resource.channel.try(:reply_time)
if resource.web_widget?
  json.hmac_token resource.channel.try(:hmac_token) if Current.account_user&.administrator?
  json.pre_chat_form_enabled resource.channel.try(:pre_chat_form_enabled)
  json.pre_chat_form_options resource.channel.try(:pre_chat_form_options)
  json.continuity_via_email resource.channel.try(:continuity_via_email)
end







json.provider resource.channel.try(:provider)

