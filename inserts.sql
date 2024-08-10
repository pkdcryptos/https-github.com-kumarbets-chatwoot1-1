
INSERT INTO "access_tokens" ("id", "owner_type", "owner_id", "token", "created_at", "updated_at") VALUES
(1,	'User',	1,	'AiLyn7BAhUWXcLs2K9PwUPQG',	'2024-08-10 21:19:56.945816',	'2024-08-10 21:19:56.945816'),
(2,	'User',	2,	'cL9SuNWN5TA4Ssz4YsazGUdS',	'2024-08-10 21:20:26.420595',	'2024-08-10 21:20:26.420595');


INSERT INTO "account_users" ("id", "account_id", "user_id", "role", "inviter_id", "created_at", "updated_at", "active_at", "availability", "auto_offline") VALUES
(1,	1,	1,	1,	NULL,	'2024-08-10 21:19:56.965059',	'2024-08-10 21:19:56.965059',	NULL,	0,	't'),
(2,	1,	2,	1,	NULL,	'2024-08-10 21:20:26.424113',	'2024-08-10 21:20:26.424113',	NULL,	0,	't');


INSERT INTO "accounts" ("id", "name", "created_at", "updated_at", "locale", "domain", "support_email", "feature_flags", "auto_resolve_duration", "limits", "custom_attributes", "status") VALUES
(1,	'Test',	'2024-08-10 21:19:56.781446',	'2024-08-10 21:19:56.781446',	0,	NULL,	NULL,	0,	NULL,	'{}',	'{}',	0);



INSERT INTO "channel_web_widgets" ("id", "website_url", "account_id", "created_at", "updated_at", "website_token", "widget_color", "welcome_title", "welcome_tagline", "feature_flags", "reply_time", "hmac_token", "pre_chat_form_enabled", "pre_chat_form_options", "hmac_mandatory", "continuity_via_email") VALUES
(1,	'w',	1,	'2024-08-10 21:21:05.38953',	'2024-08-10 21:21:05.38953',	'qMmJQTkDcViig6Bd9XaBvQyC',	'#009CE0',	'',	'',	0,	0,	'FyQwqNPxcUwiBWX8bNLf1vbJ',	'f',	'{"pre_chat_fields": [{"name": "emailAddress", "type": "email", "label": "Email Id", "enabled": false, "required": true, "field_type": "standard"}, {"name": "fullName", "type": "text", "label": "Full name", "enabled": false, "required": false, "field_type": "standard"}, {"name": "phoneNumber", "type": "text", "label": "Phone number", "enabled": false, "required": false, "field_type": "standard"}], "pre_chat_message": "Share your queries or comments here."}',	'f',	't');


INSERT INTO "contact_inboxes" ("id", "contact_id", "inbox_id", "source_id", "created_at", "updated_at", "hmac_verified", "pubsub_token") VALUES
(1,	1,	1,	'98547029-ff11-4b71-af05-024b724a6532',	'2024-08-10 16:02:16.653409',	'2024-08-10 16:02:16.653409',	'f',	'CTTps4EHbmvF1pc8kYtRfRCv');


INSERT INTO "contacts" ("id", "name", "email", "phone_number", "account_id", "created_at", "updated_at", "additional_attributes", "identifier", "custom_attributes", "last_activity_at", "contact_type", "middle_name", "last_name", "location", "country_code", "blocked") VALUES
(1,	'restless-dream-990',	NULL,	NULL,	1,	'2024-08-10 16:02:16.633773',	'2024-08-10 16:02:16.633773',	'{}',	NULL,	'{}',	NULL,	0,	'',	'',	'',	'',	'f');


INSERT INTO "conversations" ("id", "account_id", "inbox_id", "status", "assignee_id", "created_at", "updated_at", "contact_id", "display_id", "contact_last_seen_at", "agent_last_seen_at", "additional_attributes", "contact_inbox_id", "uuid", "identifier", "last_activity_at", "team_id", "campaign_id", "snoozed_until", "custom_attributes", "assignee_last_seen_at", "first_reply_created_at", "priority", "sla_policy_id", "waiting_since", "cached_label_list") VALUES
(1,	1,	1,	0,	NULL,	'2024-08-10 16:02:23.76768',	'2024-08-10 21:29:26.634745',	1,	1,	'2024-08-10 16:02:23.992798',	'2024-08-10 21:29:26.754262',	'{}',	1,	'076c828e-4e59-4f67-8b75-7651efe09b49',	NULL,	'2024-08-10 21:29:26.63274',	NULL,	NULL,	NULL,	'{}',	NULL,	'2024-08-10 21:22:11.975732',	NULL,	NULL,	NULL,	NULL);


INSERT INTO "inbox_members" ("id", "user_id", "inbox_id", "created_at", "updated_at") VALUES
(1,	1,	1,	'2024-08-10 21:21:08.392085',	'2024-08-10 21:21:08.392085');

INSERT INTO "inboxes" ("id", "channel_id", "account_id", "name", "created_at", "updated_at", "channel_type", "enable_auto_assignment", "greeting_enabled", "greeting_message", "email_address", "working_hours_enabled", "out_of_office_message", "timezone", "enable_email_collect", "csat_survey_enabled", "allow_messages_after_resolved", "auto_assignment_config", "lock_to_single_conversation", "portal_id", "sender_name_type", "business_name") VALUES
(1,	1,	1,	'w',	'2024-08-10 21:21:05.452917',	'2024-08-10 21:21:05.452917',	'Channel::WebWidget',	't',	'f',	'',	NULL,	'f',	NULL,	'UTC',	't',	'f',	't',	'{}',	'f',	NULL,	0,	NULL);


INSERT INTO "users" ("id", "provider", "uid", "encrypted_password", "reset_password_token", "reset_password_sent_at", "remember_created_at", "sign_in_count", "current_sign_in_at", "last_sign_in_at", "current_sign_in_ip", "last_sign_in_ip", "confirmation_token", "confirmed_at", "confirmation_sent_at", "unconfirmed_email", "name", "display_name", "email", "tokens", "created_at", "updated_at", "pubsub_token", "availability", "ui_settings", "custom_attributes", "type", "message_signature") VALUES
(1,	'email',	'a1@gmail.com',	'$2a$11$cpRmrRLcmtR8Co.dR9coTuYWcVDf2bXmTZPmcpbBXkSMqTv3RDjia',	NULL,	NULL,	NULL,	0,	NULL,	NULL,	NULL,	NULL,	'rzDrw9CLFK1nT6AfR6xG',	'2024-08-10 21:19:56.933826',	'2024-08-10 21:19:56.933826',	NULL,	'A1',	NULL,	'a1@gmail.com',	'"{\"JBmWk_PM6U87-KCN2BmIvQ\":{\"token\":\"$2a$10$wxFbt7FT7F6foUXjeJ/UJOqsN2px3XgYSfXnyfascQXJT8Z/VgbKa\",\"expiry\":1728595197,\"updated_at\":\"2024-08-10T21:19:56Z\"}}"',	'2024-08-10 21:19:56.933343',	'2024-08-10 21:19:57.041497',	'XrxfG6PyVUVsSjaxgRYKfnGY',	0,	'{}',	'{}',	NULL,	NULL),
(2,	'email',	'a2@gmail.com',	'$2a$11$FABkJYxYr0Nkh1qWaRm85e9wZsok3wVqTEVOGNU8wXAujALwLMO/q',	NULL,	NULL,	NULL,	0,	NULL,	NULL,	NULL,	NULL,	'35PRrsxhwfVk5ssxWJHs',	NULL,	'2024-08-10 21:20:26.418764',	NULL,	'A2',	NULL,	'a2@gmail.com',	'"{\"KJ4p8i9Bdhq3xebCagSJZA\":{\"token\":\"$2a$10$C3/lhu8bMS9Ixy/ALQ3Gn.d5rMulNBymX.P2Bq7ROkrnTI85sD8dS\",\"expiry\":1728595226,\"updated_at\":\"2024-08-10T21:20:26Z\"}}"',	'2024-08-10 21:20:26.418708',	'2024-08-10 21:20:26.49688',	'7cjZ3a1a24oXoYwUXvMH81Jb',	0,	'{}',	'{}',	NULL,	NULL);


INSERT INTO "working_hours" ("id", "inbox_id", "account_id", "day_of_week", "closed_all_day", "open_hour", "open_minutes", "close_hour", "close_minutes", "created_at", "updated_at", "open_all_day") VALUES
(1,	1,	1,	0,	't',	NULL,	NULL,	NULL,	NULL,	'2024-08-10 21:21:05.472265',	'2024-08-10 21:21:05.472265',	'f'),
(2,	1,	1,	1,	'f',	9,	0,	17,	0,	'2024-08-10 21:21:05.476465',	'2024-08-10 21:21:05.476465',	'f'),
(3,	1,	1,	2,	'f',	9,	0,	17,	0,	'2024-08-10 21:21:05.47821',	'2024-08-10 21:21:05.47821',	'f'),
(4,	1,	1,	3,	'f',	9,	0,	17,	0,	'2024-08-10 21:21:05.479577',	'2024-08-10 21:21:05.479577',	'f'),
(5,	1,	1,	4,	'f',	9,	0,	17,	0,	'2024-08-10 21:21:05.481573',	'2024-08-10 21:21:05.481573',	'f'),
(6,	1,	1,	5,	'f',	9,	0,	17,	0,	'2024-08-10 21:21:05.483674',	'2024-08-10 21:21:05.483674',	'f'),
(7,	1,	1,	6,	't',	NULL,	NULL,	NULL,	NULL,	'2024-08-10 21:21:05.486062',	'2024-08-10 21:21:05.486062',	'f');
