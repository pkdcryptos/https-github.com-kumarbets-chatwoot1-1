INSERT INTO "contact_inboxes" ("id", "contact_id", "inbox_id", "source_id", "created_at", "updated_at", "hmac_verified", "pubsub_token") VALUES
(1,	1,	1,	'98547029-ff11-4b71-af05-024b724a6532',	'2024-08-10 16:02:16.653409',	'2024-08-10 16:02:16.653409',	'f',	'CTTps4EHbmvF1pc8kYtRfRCv');

INSERT INTO "contacts" ("id", "name", "email", "phone_number", "account_id", "created_at", "updated_at", "additional_attributes", "identifier", "custom_attributes", "last_activity_at", "contact_type", "middle_name", "last_name", "location", "country_code", "blocked") VALUES
(1,	'restless-dream-990',	NULL,	NULL,	1,	'2024-08-10 16:02:16.633773',	'2024-08-10 16:02:16.633773',	'{}',	NULL,	'{}',	NULL,	0,	'',	'',	'',	'',	'f');


INSERT INTO "conversations" ("id", "account_id", "inbox_id", "status", "assignee_id", "created_at", "updated_at", "contact_id", "display_id", "contact_last_seen_at", "agent_last_seen_at", "additional_attributes", "contact_inbox_id", "uuid", "identifier", "last_activity_at", "team_id", "campaign_id", "snoozed_until", "custom_attributes", "assignee_last_seen_at", "first_reply_created_at", "priority", "sla_policy_id", "waiting_since", "cached_label_list") VALUES
(1,	1,	1,	0,	NULL,	'2024-08-10 16:02:23.76768',	'2024-08-10 16:02:23.999127',	1,	1,	'2024-08-10 16:02:23.992798',	'2024-08-10 16:02:29.349174',	'{}',	1,	'076c828e-4e59-4f67-8b75-7651efe09b49',	NULL,	'2024-08-10 16:02:23.827163',	NULL,	NULL,	NULL,	'{}',	NULL,	NULL,	NULL,	NULL,	'2024-08-10 16:02:23.76768',	NULL);

INSERT INTO "messages" ("id", "content", "account_id", "inbox_id", "conversation_id", "message_type", "created_at", "updated_at", "private", "status", "source_id", "content_type", "content_attributes", "sender_type", "sender_id", "external_source_ids", "additional_attributes", "processed_message_content", "sentiment") VALUES
(1,	'a1',	1,	1,	1,	0,	'2024-08-10 16:02:23.827163',	'2024-08-10 16:02:23.827163',	'f',	0,	NULL,	0,	'"{\"in_reply_to\":null}"',	'Contact',	1,	NULL,	'{}',	'a1',	'{}');

