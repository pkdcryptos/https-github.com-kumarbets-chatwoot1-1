-- Adminer 4.8.1 PostgreSQL 14.12 (Ubuntu 14.12-0ubuntu0.22.04.1) dump

DROP TABLE IF EXISTS "access_tokens";
DROP SEQUENCE IF EXISTS access_tokens_id_seq;
CREATE SEQUENCE access_tokens_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."access_tokens" (
    "id" bigint DEFAULT nextval('access_tokens_id_seq') NOT NULL,
    "owner_type" character varying,
    "owner_id" bigint,
    "token" character varying,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "access_tokens_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "index_access_tokens_on_token" UNIQUE ("token")
) WITH (oids = false);

CREATE INDEX "index_access_tokens_on_owner_type_and_owner_id" ON "public"."access_tokens" USING btree ("owner_type", "owner_id");

INSERT INTO "access_tokens" ("id", "owner_type", "owner_id", "token", "created_at", "updated_at") VALUES
(1,	'User',	1,	'AiLyn7BAhUWXcLs2K9PwUPQG',	'2024-08-10 21:19:56.945816',	'2024-08-10 21:19:56.945816'),
(2,	'User',	2,	'cL9SuNWN5TA4Ssz4YsazGUdS',	'2024-08-10 21:20:26.420595',	'2024-08-10 21:20:26.420595');

DROP TABLE IF EXISTS "account_users";
DROP SEQUENCE IF EXISTS account_users_id_seq;
CREATE SEQUENCE account_users_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."account_users" (
    "id" bigint DEFAULT nextval('account_users_id_seq') NOT NULL,
    "account_id" bigint,
    "user_id" bigint,
    "role" integer DEFAULT '0',
    "inviter_id" bigint,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "active_at" timestamp,
    "availability" integer DEFAULT '0' NOT NULL,
    "auto_offline" boolean DEFAULT true NOT NULL,
    CONSTRAINT "account_users_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "uniq_user_id_per_account_id" UNIQUE ("account_id", "user_id")
) WITH (oids = false);

CREATE INDEX "index_account_users_on_account_id" ON "public"."account_users" USING btree ("account_id");

CREATE INDEX "index_account_users_on_user_id" ON "public"."account_users" USING btree ("user_id");

INSERT INTO "account_users" ("id", "account_id", "user_id", "role", "inviter_id", "created_at", "updated_at", "active_at", "availability", "auto_offline") VALUES
(1,	1,	1,	1,	NULL,	'2024-08-10 21:19:56.965059',	'2024-08-10 21:19:56.965059',	NULL,	0,	't'),
(2,	1,	2,	1,	NULL,	'2024-08-10 21:20:26.424113',	'2024-08-10 21:20:26.424113',	NULL,	0,	't');

DROP TABLE IF EXISTS "accounts";
DROP SEQUENCE IF EXISTS accounts_id_seq;
CREATE SEQUENCE accounts_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."accounts" (
    "id" integer DEFAULT nextval('accounts_id_seq') NOT NULL,
    "name" character varying NOT NULL,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL,
    "locale" integer DEFAULT '0',
    "domain" character varying(100),
    "support_email" character varying(100),
    "feature_flags" bigint DEFAULT '0' NOT NULL,
    "auto_resolve_duration" integer,
    "limits" jsonb DEFAULT '{}',
    "custom_attributes" jsonb DEFAULT '{}',
    "status" integer DEFAULT '0',
    CONSTRAINT "accounts_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_accounts_on_status" ON "public"."accounts" USING btree ("status");

INSERT INTO "accounts" ("id", "name", "created_at", "updated_at", "locale", "domain", "support_email", "feature_flags", "auto_resolve_duration", "limits", "custom_attributes", "status") VALUES
(1,	'Test',	'2024-08-10 21:19:56.781446',	'2024-08-10 21:19:56.781446',	0,	NULL,	NULL,	0,	NULL,	'{}',	'{}',	0);

DELIMITER ;;

CREATE TRIGGER "accounts_after_insert_row_tr" AFTER INSERT ON "public"."accounts" FOR EACH ROW EXECUTE FUNCTION accounts_after_insert_row_tr();;

CREATE TRIGGER "camp_dpid_before_insert" AFTER INSERT ON "public"."accounts" FOR EACH ROW EXECUTE FUNCTION camp_dpid_before_insert();;

DELIMITER ;

DROP TABLE IF EXISTS "active_storage_attachments";
DROP SEQUENCE IF EXISTS active_storage_attachments_id_seq;
CREATE SEQUENCE active_storage_attachments_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."active_storage_attachments" (
    "id" bigint DEFAULT nextval('active_storage_attachments_id_seq') NOT NULL,
    "name" character varying NOT NULL,
    "record_type" character varying NOT NULL,
    "record_id" bigint NOT NULL,
    "blob_id" bigint NOT NULL,
    "created_at" timestamp NOT NULL,
    CONSTRAINT "active_storage_attachments_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "index_active_storage_attachments_uniqueness" UNIQUE ("record_type", "record_id", "name", "blob_id")
) WITH (oids = false);

CREATE INDEX "index_active_storage_attachments_on_blob_id" ON "public"."active_storage_attachments" USING btree ("blob_id");


DROP TABLE IF EXISTS "active_storage_blobs";
DROP SEQUENCE IF EXISTS active_storage_blobs_id_seq;
CREATE SEQUENCE active_storage_blobs_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."active_storage_blobs" (
    "id" bigint DEFAULT nextval('active_storage_blobs_id_seq') NOT NULL,
    "key" character varying NOT NULL,
    "filename" character varying NOT NULL,
    "content_type" character varying,
    "metadata" text,
    "byte_size" bigint NOT NULL,
    "checksum" character varying,
    "created_at" timestamp NOT NULL,
    "service_name" character varying NOT NULL,
    CONSTRAINT "active_storage_blobs_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "index_active_storage_blobs_on_key" UNIQUE ("key")
) WITH (oids = false);


DROP TABLE IF EXISTS "active_storage_variant_records";
DROP SEQUENCE IF EXISTS active_storage_variant_records_id_seq;
CREATE SEQUENCE active_storage_variant_records_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."active_storage_variant_records" (
    "id" bigint DEFAULT nextval('active_storage_variant_records_id_seq') NOT NULL,
    "blob_id" bigint NOT NULL,
    "variation_digest" character varying NOT NULL,
    CONSTRAINT "active_storage_variant_records_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "index_active_storage_variant_records_uniqueness" UNIQUE ("blob_id", "variation_digest")
) WITH (oids = false);


DROP TABLE IF EXISTS "ar_internal_metadata";
CREATE TABLE "public"."ar_internal_metadata" (
    "key" character varying NOT NULL,
    "value" character varying,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "ar_internal_metadata_pkey" PRIMARY KEY ("key")
) WITH (oids = false);

INSERT INTO "ar_internal_metadata" ("key", "value", "created_at", "updated_at") VALUES
('environment',	'production',	'2024-08-10 21:12:50.036292',	'2024-08-10 21:12:50.036292'),
('schema_sha1',	'1e209029ff69d7f44816c709affcf2445f03feed',	'2024-08-10 21:12:50.04087',	'2024-08-10 21:12:50.04087');

DROP TABLE IF EXISTS "attachments";
DROP SEQUENCE IF EXISTS attachments_id_seq;
CREATE SEQUENCE attachments_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."attachments" (
    "id" integer DEFAULT nextval('attachments_id_seq') NOT NULL,
    "file_type" integer DEFAULT '0',
    "external_url" character varying,
    "coordinates_lat" double precision DEFAULT '0.0',
    "coordinates_long" double precision DEFAULT '0.0',
    "message_id" integer NOT NULL,
    "account_id" integer NOT NULL,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL,
    "fallback_title" character varying,
    "extension" character varying,
    CONSTRAINT "attachments_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_attachments_on_account_id" ON "public"."attachments" USING btree ("account_id");

CREATE INDEX "index_attachments_on_message_id" ON "public"."attachments" USING btree ("message_id");


DROP TABLE IF EXISTS "channel_web_widgets";
DROP SEQUENCE IF EXISTS channel_web_widgets_id_seq;
CREATE SEQUENCE channel_web_widgets_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."channel_web_widgets" (
    "id" integer DEFAULT nextval('channel_web_widgets_id_seq') NOT NULL,
    "website_url" character varying,
    "account_id" integer,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL,
    "website_token" character varying,
    "widget_color" character varying DEFAULT '#1f93ff',
    "welcome_title" character varying,
    "welcome_tagline" character varying,
    "feature_flags" integer DEFAULT '7' NOT NULL,
    "reply_time" integer DEFAULT '0',
    "hmac_token" character varying,
    "pre_chat_form_enabled" boolean DEFAULT false,
    "pre_chat_form_options" jsonb DEFAULT '{}',
    "hmac_mandatory" boolean DEFAULT false,
    "continuity_via_email" boolean DEFAULT true NOT NULL,
    CONSTRAINT "channel_web_widgets_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "index_channel_web_widgets_on_hmac_token" UNIQUE ("hmac_token"),
    CONSTRAINT "index_channel_web_widgets_on_website_token" UNIQUE ("website_token")
) WITH (oids = false);

INSERT INTO "channel_web_widgets" ("id", "website_url", "account_id", "created_at", "updated_at", "website_token", "widget_color", "welcome_title", "welcome_tagline", "feature_flags", "reply_time", "hmac_token", "pre_chat_form_enabled", "pre_chat_form_options", "hmac_mandatory", "continuity_via_email") VALUES
(1,	'w',	1,	'2024-08-10 21:21:05.38953',	'2024-08-10 21:21:05.38953',	'qMmJQTkDcViig6Bd9XaBvQyC',	'#009CE0',	'',	'',	0,	0,	'FyQwqNPxcUwiBWX8bNLf1vbJ',	'f',	'{"pre_chat_fields": [{"name": "emailAddress", "type": "email", "label": "Email Id", "enabled": false, "required": true, "field_type": "standard"}, {"name": "fullName", "type": "text", "label": "Full name", "enabled": false, "required": false, "field_type": "standard"}, {"name": "phoneNumber", "type": "text", "label": "Phone number", "enabled": false, "required": false, "field_type": "standard"}], "pre_chat_message": "Share your queries or comments here."}',	'f',	't');

DROP TABLE IF EXISTS "contact_inboxes";
DROP SEQUENCE IF EXISTS contact_inboxes_id_seq;
CREATE SEQUENCE contact_inboxes_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."contact_inboxes" (
    "id" bigint DEFAULT nextval('contact_inboxes_id_seq') NOT NULL,
    "contact_id" bigint,
    "inbox_id" bigint,
    "source_id" character varying NOT NULL,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "hmac_verified" boolean DEFAULT false,
    "pubsub_token" character varying,
    CONSTRAINT "contact_inboxes_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "index_contact_inboxes_on_inbox_id_and_source_id" UNIQUE ("inbox_id", "source_id"),
    CONSTRAINT "index_contact_inboxes_on_pubsub_token" UNIQUE ("pubsub_token")
) WITH (oids = false);

CREATE INDEX "index_contact_inboxes_on_contact_id" ON "public"."contact_inboxes" USING btree ("contact_id");

CREATE INDEX "index_contact_inboxes_on_inbox_id" ON "public"."contact_inboxes" USING btree ("inbox_id");

CREATE INDEX "index_contact_inboxes_on_source_id" ON "public"."contact_inboxes" USING btree ("source_id");

INSERT INTO "contact_inboxes" ("id", "contact_id", "inbox_id", "source_id", "created_at", "updated_at", "hmac_verified", "pubsub_token") VALUES
(1,	1,	1,	'98547029-ff11-4b71-af05-024b724a6532',	'2024-08-10 16:02:16.653409',	'2024-08-10 16:02:16.653409',	'f',	'CTTps4EHbmvF1pc8kYtRfRCv');

DROP TABLE IF EXISTS "contacts";
DROP SEQUENCE IF EXISTS contacts_id_seq;
CREATE SEQUENCE contacts_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."contacts" (
    "id" integer DEFAULT nextval('contacts_id_seq') NOT NULL,
    "name" character varying DEFAULT '',
    "email" character varying,
    "phone_number" character varying,
    "account_id" integer NOT NULL,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL,
    "additional_attributes" jsonb DEFAULT '{}',
    "identifier" character varying,
    "custom_attributes" jsonb DEFAULT '{}',
    "last_activity_at" timestamp,
    "contact_type" integer DEFAULT '0',
    "middle_name" character varying DEFAULT '',
    "last_name" character varying DEFAULT '',
    "location" character varying DEFAULT '',
    "country_code" character varying DEFAULT '',
    "blocked" boolean DEFAULT false NOT NULL,
    CONSTRAINT "contacts_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "uniq_email_per_account_contact" UNIQUE ("email", "account_id"),
    CONSTRAINT "uniq_identifier_per_account_contact" UNIQUE ("identifier", "account_id")
) WITH (oids = false);

CREATE INDEX "index_contacts_on_account_id" ON "public"."contacts" USING btree ("account_id");

CREATE INDEX "index_contacts_on_account_id_and_last_activity_at" ON "public"."contacts" USING btree ("account_id", "last_activity_at" DESC);

CREATE INDEX "index_contacts_on_blocked" ON "public"."contacts" USING btree ("blocked");

CREATE INDEX "index_contacts_on_lower_email_account_id" ON "public"."contacts" USING btree ("", "account_id");

CREATE INDEX "index_contacts_on_name_email_phone_number_identifier" ON "public"."contacts" USING btree ("name", "email", "phone_number", "identifier");

CREATE INDEX "index_contacts_on_nonempty_fields" ON "public"."contacts" USING btree ("account_id", "email", "phone_number", "identifier");

CREATE INDEX "index_contacts_on_phone_number_and_account_id" ON "public"."contacts" USING btree ("phone_number", "account_id");

CREATE INDEX "index_resolved_contact_account_id" ON "public"."contacts" USING btree ("account_id");

INSERT INTO "contacts" ("id", "name", "email", "phone_number", "account_id", "created_at", "updated_at", "additional_attributes", "identifier", "custom_attributes", "last_activity_at", "contact_type", "middle_name", "last_name", "location", "country_code", "blocked") VALUES
(1,	'restless-dream-990',	NULL,	NULL,	1,	'2024-08-10 16:02:16.633773',	'2024-08-10 16:02:16.633773',	'{}',	NULL,	'{}',	NULL,	0,	'',	'',	'',	'',	'f');

DROP TABLE IF EXISTS "conversation_participants";
DROP SEQUENCE IF EXISTS conversation_participants_id_seq;
CREATE SEQUENCE conversation_participants_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."conversation_participants" (
    "id" bigint DEFAULT nextval('conversation_participants_id_seq') NOT NULL,
    "account_id" bigint NOT NULL,
    "user_id" bigint NOT NULL,
    "conversation_id" bigint NOT NULL,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "conversation_participants_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "index_conversation_participants_on_user_id_and_conversation_id" UNIQUE ("user_id", "conversation_id")
) WITH (oids = false);

CREATE INDEX "index_conversation_participants_on_account_id" ON "public"."conversation_participants" USING btree ("account_id");

CREATE INDEX "index_conversation_participants_on_conversation_id" ON "public"."conversation_participants" USING btree ("conversation_id");

CREATE INDEX "index_conversation_participants_on_user_id" ON "public"."conversation_participants" USING btree ("user_id");


DROP TABLE IF EXISTS "conversations";
DROP SEQUENCE IF EXISTS conversations_id_seq;
CREATE SEQUENCE conversations_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."conversations" (
    "id" integer DEFAULT nextval('conversations_id_seq') NOT NULL,
    "account_id" integer NOT NULL,
    "inbox_id" integer NOT NULL,
    "status" integer DEFAULT '0' NOT NULL,
    "assignee_id" integer,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL,
    "contact_id" bigint,
    "display_id" integer NOT NULL,
    "contact_last_seen_at" timestamp,
    "agent_last_seen_at" timestamp,
    "additional_attributes" jsonb DEFAULT '{}',
    "contact_inbox_id" bigint,
    "uuid" uuid DEFAULT gen_random_uuid() NOT NULL,
    "identifier" character varying,
    "last_activity_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "team_id" bigint,
    "campaign_id" bigint,
    "snoozed_until" timestamp,
    "custom_attributes" jsonb DEFAULT '{}',
    "assignee_last_seen_at" timestamp,
    "first_reply_created_at" timestamp,
    "priority" integer,
    "sla_policy_id" bigint,
    "waiting_since" timestamp(6),
    "cached_label_list" text,
    CONSTRAINT "conversations_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "index_conversations_on_account_id_and_display_id" UNIQUE ("account_id", "display_id"),
    CONSTRAINT "index_conversations_on_uuid" UNIQUE ("uuid")
) WITH (oids = false);

CREATE INDEX "conv_acid_inbid_stat_asgnid_idx" ON "public"."conversations" USING btree ("account_id", "inbox_id", "status", "assignee_id");

CREATE INDEX "index_conversations_on_account_id" ON "public"."conversations" USING btree ("account_id");

CREATE INDEX "index_conversations_on_assignee_id_and_account_id" ON "public"."conversations" USING btree ("assignee_id", "account_id");

CREATE INDEX "index_conversations_on_campaign_id" ON "public"."conversations" USING btree ("campaign_id");

CREATE INDEX "index_conversations_on_contact_id" ON "public"."conversations" USING btree ("contact_id");

CREATE INDEX "index_conversations_on_contact_inbox_id" ON "public"."conversations" USING btree ("contact_inbox_id");

CREATE INDEX "index_conversations_on_first_reply_created_at" ON "public"."conversations" USING btree ("first_reply_created_at");

CREATE INDEX "index_conversations_on_id_and_account_id" ON "public"."conversations" USING btree ("account_id", "id");

CREATE INDEX "index_conversations_on_inbox_id" ON "public"."conversations" USING btree ("inbox_id");

CREATE INDEX "index_conversations_on_priority" ON "public"."conversations" USING btree ("priority");

CREATE INDEX "index_conversations_on_status_and_account_id" ON "public"."conversations" USING btree ("status", "account_id");

CREATE INDEX "index_conversations_on_status_and_priority" ON "public"."conversations" USING btree ("status", "priority");

CREATE INDEX "index_conversations_on_team_id" ON "public"."conversations" USING btree ("team_id");

CREATE INDEX "index_conversations_on_waiting_since" ON "public"."conversations" USING btree ("waiting_since");

INSERT INTO "conversations" ("id", "account_id", "inbox_id", "status", "assignee_id", "created_at", "updated_at", "contact_id", "display_id", "contact_last_seen_at", "agent_last_seen_at", "additional_attributes", "contact_inbox_id", "uuid", "identifier", "last_activity_at", "team_id", "campaign_id", "snoozed_until", "custom_attributes", "assignee_last_seen_at", "first_reply_created_at", "priority", "sla_policy_id", "waiting_since", "cached_label_list") VALUES
(1,	1,	1,	0,	NULL,	'2024-08-10 16:02:23.76768',	'2024-08-10 21:22:12.024125',	1,	1,	'2024-08-10 16:02:23.992798',	'2024-08-10 21:22:12.078369',	'{}',	1,	'076c828e-4e59-4f67-8b75-7651efe09b49',	NULL,	'2024-08-10 21:22:11.975732',	NULL,	NULL,	NULL,	'{}',	NULL,	'2024-08-10 21:22:11.975732',	NULL,	NULL,	NULL,	NULL);

DELIMITER ;;

CREATE TRIGGER "conversations_before_insert_row_tr" BEFORE INSERT ON "public"."conversations" FOR EACH ROW EXECUTE FUNCTION conversations_before_insert_row_tr();;

DELIMITER ;

DROP TABLE IF EXISTS "inbox_members";
DROP SEQUENCE IF EXISTS inbox_members_id_seq;
CREATE SEQUENCE inbox_members_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."inbox_members" (
    "id" integer DEFAULT nextval('inbox_members_id_seq') NOT NULL,
    "user_id" integer NOT NULL,
    "inbox_id" integer NOT NULL,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL,
    CONSTRAINT "inbox_members_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "index_inbox_members_on_inbox_id_and_user_id" UNIQUE ("inbox_id", "user_id")
) WITH (oids = false);

CREATE INDEX "index_inbox_members_on_inbox_id" ON "public"."inbox_members" USING btree ("inbox_id");

INSERT INTO "inbox_members" ("id", "user_id", "inbox_id", "created_at", "updated_at") VALUES
(1,	1,	1,	'2024-08-10 21:21:08.392085',	'2024-08-10 21:21:08.392085');

DROP TABLE IF EXISTS "inboxes";
DROP SEQUENCE IF EXISTS inboxes_id_seq;
CREATE SEQUENCE inboxes_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."inboxes" (
    "id" integer DEFAULT nextval('inboxes_id_seq') NOT NULL,
    "channel_id" integer NOT NULL,
    "account_id" integer NOT NULL,
    "name" character varying NOT NULL,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL,
    "channel_type" character varying,
    "enable_auto_assignment" boolean DEFAULT true,
    "greeting_enabled" boolean DEFAULT false,
    "greeting_message" character varying,
    "email_address" character varying,
    "working_hours_enabled" boolean DEFAULT false,
    "out_of_office_message" character varying,
    "timezone" character varying DEFAULT 'UTC',
    "enable_email_collect" boolean DEFAULT true,
    "csat_survey_enabled" boolean DEFAULT false,
    "allow_messages_after_resolved" boolean DEFAULT true,
    "auto_assignment_config" jsonb DEFAULT '{}',
    "lock_to_single_conversation" boolean DEFAULT false NOT NULL,
    "portal_id" bigint,
    "sender_name_type" integer DEFAULT '0' NOT NULL,
    "business_name" character varying,
    CONSTRAINT "inboxes_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_inboxes_on_account_id" ON "public"."inboxes" USING btree ("account_id");

CREATE INDEX "index_inboxes_on_channel_id_and_channel_type" ON "public"."inboxes" USING btree ("channel_id", "channel_type");

CREATE INDEX "index_inboxes_on_portal_id" ON "public"."inboxes" USING btree ("portal_id");

INSERT INTO "inboxes" ("id", "channel_id", "account_id", "name", "created_at", "updated_at", "channel_type", "enable_auto_assignment", "greeting_enabled", "greeting_message", "email_address", "working_hours_enabled", "out_of_office_message", "timezone", "enable_email_collect", "csat_survey_enabled", "allow_messages_after_resolved", "auto_assignment_config", "lock_to_single_conversation", "portal_id", "sender_name_type", "business_name") VALUES
(1,	1,	1,	'w',	'2024-08-10 21:21:05.452917',	'2024-08-10 21:21:05.452917',	'Channel::WebWidget',	't',	'f',	'',	NULL,	'f',	NULL,	'UTC',	't',	'f',	't',	'{}',	'f',	NULL,	0,	NULL);

DROP TABLE IF EXISTS "installation_configs";
DROP SEQUENCE IF EXISTS installation_configs_id_seq;
CREATE SEQUENCE installation_configs_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."installation_configs" (
    "id" bigint DEFAULT nextval('installation_configs_id_seq') NOT NULL,
    "name" character varying NOT NULL,
    "serialized_value" jsonb DEFAULT '{}' NOT NULL,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "locked" boolean DEFAULT true NOT NULL,
    CONSTRAINT "index_installation_configs_on_name" UNIQUE ("name"),
    CONSTRAINT "index_installation_configs_on_name_and_created_at" UNIQUE ("name", "created_at"),
    CONSTRAINT "installation_configs_pkey" PRIMARY KEY ("id")
) WITH (oids = false);


DROP TABLE IF EXISTS "messages";
DROP SEQUENCE IF EXISTS messages_id_seq;
CREATE SEQUENCE messages_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."messages" (
    "id" integer DEFAULT nextval('messages_id_seq') NOT NULL,
    "content" text,
    "account_id" integer NOT NULL,
    "inbox_id" integer NOT NULL,
    "conversation_id" integer NOT NULL,
    "message_type" integer NOT NULL,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL,
    "private" boolean DEFAULT false NOT NULL,
    "status" integer DEFAULT '0',
    "source_id" character varying,
    "content_type" integer DEFAULT '0' NOT NULL,
    "content_attributes" json DEFAULT '{}',
    "sender_type" character varying,
    "sender_id" bigint,
    "external_source_ids" jsonb DEFAULT '{}',
    "additional_attributes" jsonb DEFAULT '{}',
    "processed_message_content" text,
    "sentiment" jsonb DEFAULT '{}',
    CONSTRAINT "messages_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_messages_on_account_created_type" ON "public"."messages" USING btree ("account_id", "created_at", "message_type");

CREATE INDEX "index_messages_on_account_id" ON "public"."messages" USING btree ("account_id");

CREATE INDEX "index_messages_on_account_id_and_inbox_id" ON "public"."messages" USING btree ("account_id", "inbox_id");

CREATE INDEX "index_messages_on_additional_attributes_campaign_id" ON "public"."messages" USING btree ("");

CREATE INDEX "index_messages_on_content" ON "public"."messages" USING btree ("content");

CREATE INDEX "index_messages_on_conversation_account_type_created" ON "public"."messages" USING btree ("conversation_id", "account_id", "message_type", "created_at");

CREATE INDEX "index_messages_on_conversation_id" ON "public"."messages" USING btree ("conversation_id");

CREATE INDEX "index_messages_on_created_at" ON "public"."messages" USING btree ("created_at");

CREATE INDEX "index_messages_on_inbox_id" ON "public"."messages" USING btree ("inbox_id");

CREATE INDEX "index_messages_on_sender_type_and_sender_id" ON "public"."messages" USING btree ("sender_type", "sender_id");

CREATE INDEX "index_messages_on_source_id" ON "public"."messages" USING btree ("source_id");

INSERT INTO "messages" ("id", "content", "account_id", "inbox_id", "conversation_id", "message_type", "created_at", "updated_at", "private", "status", "source_id", "content_type", "content_attributes", "sender_type", "sender_id", "external_source_ids", "additional_attributes", "processed_message_content", "sentiment") VALUES
(1,	'a1',	1,	1,	1,	0,	'2024-08-10 16:02:23.827163',	'2024-08-10 16:02:23.827163',	'f',	0,	NULL,	0,	'"{\"in_reply_to\":null}"',	'Contact',	1,	NULL,	'{}',	'a1',	'{}'),
(2,	'aaaa',	1,	1,	1,	1,	'2024-08-10 21:22:11.975732',	'2024-08-10 21:22:11.975732',	'f',	0,	NULL,	0,	NULL,	'User',	2,	NULL,	'{}',	'aaaa',	'{}');

DROP VIEW IF EXISTS "pg_stat_statements";
CREATE TABLE "pg_stat_statements" ("userid" oid, "dbid" oid, "toplevel" boolean, "queryid" bigint, "query" text, "plans" bigint, "total_plan_time" double precision, "min_plan_time" double precision, "max_plan_time" double precision, "mean_plan_time" double precision, "stddev_plan_time" double precision, "calls" bigint, "total_exec_time" double precision, "min_exec_time" double precision, "max_exec_time" double precision, "mean_exec_time" double precision, "stddev_exec_time" double precision, "rows" bigint, "shared_blks_hit" bigint, "shared_blks_read" bigint, "shared_blks_dirtied" bigint, "shared_blks_written" bigint, "local_blks_hit" bigint, "local_blks_read" bigint, "local_blks_dirtied" bigint, "local_blks_written" bigint, "temp_blks_read" bigint, "temp_blks_written" bigint, "blk_read_time" double precision, "blk_write_time" double precision, "wal_records" bigint, "wal_fpi" bigint, "wal_bytes" numeric);


DROP VIEW IF EXISTS "pg_stat_statements_info";
CREATE TABLE "pg_stat_statements_info" ("dealloc" bigint, "stats_reset" timestamptz);


DROP TABLE IF EXISTS "schema_migrations";
CREATE TABLE "public"."schema_migrations" (
    "version" character varying NOT NULL,
    CONSTRAINT "schema_migrations_pkey" PRIMARY KEY ("version")
) WITH (oids = false);

INSERT INTO "schema_migrations" ("version") VALUES
('20240516003531');

DROP TABLE IF EXISTS "users";
DROP SEQUENCE IF EXISTS users_id_seq;
CREATE SEQUENCE users_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."users" (
    "id" integer DEFAULT nextval('users_id_seq') NOT NULL,
    "provider" character varying DEFAULT 'email' NOT NULL,
    "uid" character varying DEFAULT '' NOT NULL,
    "encrypted_password" character varying DEFAULT '' NOT NULL,
    "reset_password_token" character varying,
    "reset_password_sent_at" timestamp,
    "remember_created_at" timestamp,
    "sign_in_count" integer DEFAULT '0' NOT NULL,
    "current_sign_in_at" timestamp,
    "last_sign_in_at" timestamp,
    "current_sign_in_ip" character varying,
    "last_sign_in_ip" character varying,
    "confirmation_token" character varying,
    "confirmed_at" timestamp,
    "confirmation_sent_at" timestamp,
    "unconfirmed_email" character varying,
    "name" character varying NOT NULL,
    "display_name" character varying,
    "email" character varying,
    "tokens" json,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL,
    "pubsub_token" character varying,
    "availability" integer DEFAULT '0',
    "ui_settings" jsonb DEFAULT '{}',
    "custom_attributes" jsonb DEFAULT '{}',
    "type" character varying,
    "message_signature" text,
    CONSTRAINT "index_users_on_pubsub_token" UNIQUE ("pubsub_token"),
    CONSTRAINT "index_users_on_reset_password_token" UNIQUE ("reset_password_token"),
    CONSTRAINT "index_users_on_uid_and_provider" UNIQUE ("uid", "provider"),
    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_users_on_email" ON "public"."users" USING btree ("email");

INSERT INTO "users" ("id", "provider", "uid", "encrypted_password", "reset_password_token", "reset_password_sent_at", "remember_created_at", "sign_in_count", "current_sign_in_at", "last_sign_in_at", "current_sign_in_ip", "last_sign_in_ip", "confirmation_token", "confirmed_at", "confirmation_sent_at", "unconfirmed_email", "name", "display_name", "email", "tokens", "created_at", "updated_at", "pubsub_token", "availability", "ui_settings", "custom_attributes", "type", "message_signature") VALUES
(1,	'email',	'a1@gmail.com',	'$2a$11$cpRmrRLcmtR8Co.dR9coTuYWcVDf2bXmTZPmcpbBXkSMqTv3RDjia',	NULL,	NULL,	NULL,	0,	NULL,	NULL,	NULL,	NULL,	'rzDrw9CLFK1nT6AfR6xG',	'2024-08-10 21:19:56.933826',	'2024-08-10 21:19:56.933826',	NULL,	'A1',	NULL,	'a1@gmail.com',	'"{\"JBmWk_PM6U87-KCN2BmIvQ\":{\"token\":\"$2a$10$wxFbt7FT7F6foUXjeJ/UJOqsN2px3XgYSfXnyfascQXJT8Z/VgbKa\",\"expiry\":1728595197,\"updated_at\":\"2024-08-10T21:19:56Z\"}}"',	'2024-08-10 21:19:56.933343',	'2024-08-10 21:19:57.041497',	'XrxfG6PyVUVsSjaxgRYKfnGY',	0,	'{}',	'{}',	NULL,	NULL),
(2,	'email',	'a2@gmail.com',	'$2a$11$FABkJYxYr0Nkh1qWaRm85e9wZsok3wVqTEVOGNU8wXAujALwLMO/q',	NULL,	NULL,	NULL,	0,	NULL,	NULL,	NULL,	NULL,	'35PRrsxhwfVk5ssxWJHs',	NULL,	'2024-08-10 21:20:26.418764',	NULL,	'A2',	NULL,	'a2@gmail.com',	'"{\"KJ4p8i9Bdhq3xebCagSJZA\":{\"token\":\"$2a$10$C3/lhu8bMS9Ixy/ALQ3Gn.d5rMulNBymX.P2Bq7ROkrnTI85sD8dS\",\"expiry\":1728595226,\"updated_at\":\"2024-08-10T21:20:26Z\"}}"',	'2024-08-10 21:20:26.418708',	'2024-08-10 21:20:26.49688',	'7cjZ3a1a24oXoYwUXvMH81Jb',	0,	'{}',	'{}',	NULL,	NULL);

DROP TABLE IF EXISTS "working_hours";
DROP SEQUENCE IF EXISTS working_hours_id_seq;
CREATE SEQUENCE working_hours_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."working_hours" (
    "id" bigint DEFAULT nextval('working_hours_id_seq') NOT NULL,
    "inbox_id" bigint,
    "account_id" bigint,
    "day_of_week" integer NOT NULL,
    "closed_all_day" boolean DEFAULT false,
    "open_hour" integer,
    "open_minutes" integer,
    "close_hour" integer,
    "close_minutes" integer,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "open_all_day" boolean DEFAULT false,
    CONSTRAINT "working_hours_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_working_hours_on_account_id" ON "public"."working_hours" USING btree ("account_id");

CREATE INDEX "index_working_hours_on_inbox_id" ON "public"."working_hours" USING btree ("inbox_id");

INSERT INTO "working_hours" ("id", "inbox_id", "account_id", "day_of_week", "closed_all_day", "open_hour", "open_minutes", "close_hour", "close_minutes", "created_at", "updated_at", "open_all_day") VALUES
(1,	1,	1,	0,	't',	NULL,	NULL,	NULL,	NULL,	'2024-08-10 21:21:05.472265',	'2024-08-10 21:21:05.472265',	'f'),
(2,	1,	1,	1,	'f',	9,	0,	17,	0,	'2024-08-10 21:21:05.476465',	'2024-08-10 21:21:05.476465',	'f'),
(3,	1,	1,	2,	'f',	9,	0,	17,	0,	'2024-08-10 21:21:05.47821',	'2024-08-10 21:21:05.47821',	'f'),
(4,	1,	1,	3,	'f',	9,	0,	17,	0,	'2024-08-10 21:21:05.479577',	'2024-08-10 21:21:05.479577',	'f'),
(5,	1,	1,	4,	'f',	9,	0,	17,	0,	'2024-08-10 21:21:05.481573',	'2024-08-10 21:21:05.481573',	'f'),
(6,	1,	1,	5,	'f',	9,	0,	17,	0,	'2024-08-10 21:21:05.483674',	'2024-08-10 21:21:05.483674',	'f'),
(7,	1,	1,	6,	't',	NULL,	NULL,	NULL,	NULL,	'2024-08-10 21:21:05.486062',	'2024-08-10 21:21:05.486062',	'f');

ALTER TABLE ONLY "public"."active_storage_attachments" ADD CONSTRAINT "fk_rails_c3b3935057" FOREIGN KEY (blob_id) REFERENCES active_storage_blobs(id) NOT DEFERRABLE;

ALTER TABLE ONLY "public"."active_storage_variant_records" ADD CONSTRAINT "fk_rails_993965df05" FOREIGN KEY (blob_id) REFERENCES active_storage_blobs(id) NOT DEFERRABLE;

DROP TABLE IF EXISTS "pg_stat_statements";
CREATE VIEW "pg_stat_statements" AS SELECT pg_stat_statements.userid,
    pg_stat_statements.dbid,
    pg_stat_statements.toplevel,
    pg_stat_statements.queryid,
    pg_stat_statements.query,
    pg_stat_statements.plans,
    pg_stat_statements.total_plan_time,
    pg_stat_statements.min_plan_time,
    pg_stat_statements.max_plan_time,
    pg_stat_statements.mean_plan_time,
    pg_stat_statements.stddev_plan_time,
    pg_stat_statements.calls,
    pg_stat_statements.total_exec_time,
    pg_stat_statements.min_exec_time,
    pg_stat_statements.max_exec_time,
    pg_stat_statements.mean_exec_time,
    pg_stat_statements.stddev_exec_time,
    pg_stat_statements.rows,
    pg_stat_statements.shared_blks_hit,
    pg_stat_statements.shared_blks_read,
    pg_stat_statements.shared_blks_dirtied,
    pg_stat_statements.shared_blks_written,
    pg_stat_statements.local_blks_hit,
    pg_stat_statements.local_blks_read,
    pg_stat_statements.local_blks_dirtied,
    pg_stat_statements.local_blks_written,
    pg_stat_statements.temp_blks_read,
    pg_stat_statements.temp_blks_written,
    pg_stat_statements.blk_read_time,
    pg_stat_statements.blk_write_time,
    pg_stat_statements.wal_records,
    pg_stat_statements.wal_fpi,
    pg_stat_statements.wal_bytes
   FROM pg_stat_statements(true) pg_stat_statements(userid, dbid, toplevel, queryid, query, plans, total_plan_time, min_plan_time, max_plan_time, mean_plan_time, stddev_plan_time, calls, total_exec_time, min_exec_time, max_exec_time, mean_exec_time, stddev_exec_time, rows, shared_blks_hit, shared_blks_read, shared_blks_dirtied, shared_blks_written, local_blks_hit, local_blks_read, local_blks_dirtied, local_blks_written, temp_blks_read, temp_blks_written, blk_read_time, blk_write_time, wal_records, wal_fpi, wal_bytes);

DROP TABLE IF EXISTS "pg_stat_statements_info";
CREATE VIEW "pg_stat_statements_info" AS SELECT pg_stat_statements_info.dealloc,
    pg_stat_statements_info.stats_reset
   FROM pg_stat_statements_info() pg_stat_statements_info(dealloc, stats_reset);

-- 2024-08-10 14:22:19.309913-07