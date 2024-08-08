-- Adminer 4.8.1 PostgreSQL 14.12 dump

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


DROP TABLE IF EXISTS "agent_bot_inboxes";
DROP SEQUENCE IF EXISTS agent_bot_inboxes_id_seq;
CREATE SEQUENCE agent_bot_inboxes_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."agent_bot_inboxes" (
    "id" bigint DEFAULT nextval('agent_bot_inboxes_id_seq') NOT NULL,
    "inbox_id" integer,
    "agent_bot_id" integer,
    "status" integer DEFAULT '0',
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "account_id" integer,
    CONSTRAINT "agent_bot_inboxes_pkey" PRIMARY KEY ("id")
) WITH (oids = false);


DROP TABLE IF EXISTS "agent_bots";
DROP SEQUENCE IF EXISTS agent_bots_id_seq;
CREATE SEQUENCE agent_bots_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."agent_bots" (
    "id" bigint DEFAULT nextval('agent_bots_id_seq') NOT NULL,
    "name" character varying,
    "description" character varying,
    "outgoing_url" character varying,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "account_id" bigint,
    "bot_type" integer DEFAULT '0',
    "bot_config" jsonb DEFAULT '{}',
    CONSTRAINT "agent_bots_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_agent_bots_on_account_id" ON "public"."agent_bots" USING btree ("account_id");


DROP TABLE IF EXISTS "applied_slas";
DROP SEQUENCE IF EXISTS applied_slas_id_seq;
CREATE SEQUENCE applied_slas_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."applied_slas" (
    "id" bigint DEFAULT nextval('applied_slas_id_seq') NOT NULL,
    "account_id" bigint NOT NULL,
    "sla_policy_id" bigint NOT NULL,
    "conversation_id" bigint NOT NULL,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "sla_status" integer DEFAULT '0',
    CONSTRAINT "applied_slas_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "index_applied_slas_on_account_sla_policy_conversation" UNIQUE ("account_id", "sla_policy_id", "conversation_id")
) WITH (oids = false);

CREATE INDEX "index_applied_slas_on_account_id" ON "public"."applied_slas" USING btree ("account_id");

CREATE INDEX "index_applied_slas_on_conversation_id" ON "public"."applied_slas" USING btree ("conversation_id");

CREATE INDEX "index_applied_slas_on_sla_policy_id" ON "public"."applied_slas" USING btree ("sla_policy_id");


DROP TABLE IF EXISTS "ar_internal_metadata";
CREATE TABLE "public"."ar_internal_metadata" (
    "key" character varying NOT NULL,
    "value" character varying,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "ar_internal_metadata_pkey" PRIMARY KEY ("key")
) WITH (oids = false);




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


DROP TABLE IF EXISTS "audits";
DROP SEQUENCE IF EXISTS audits_id_seq;
CREATE SEQUENCE audits_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."audits" (
    "id" bigint DEFAULT nextval('audits_id_seq') NOT NULL,
    "auditable_id" bigint,
    "auditable_type" character varying,
    "associated_id" bigint,
    "associated_type" character varying,
    "user_id" bigint,
    "user_type" character varying,
    "username" character varying,
    "action" character varying,
    "audited_changes" jsonb,
    "version" integer DEFAULT '0',
    "comment" character varying,
    "remote_address" character varying,
    "request_uuid" character varying,
    "created_at" timestamp,
    CONSTRAINT "audits_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "associated_index" ON "public"."audits" USING btree ("associated_type", "associated_id");

CREATE INDEX "auditable_index" ON "public"."audits" USING btree ("auditable_type", "auditable_id", "version");

CREATE INDEX "index_audits_on_created_at" ON "public"."audits" USING btree ("created_at");

CREATE INDEX "index_audits_on_request_uuid" ON "public"."audits" USING btree ("request_uuid");

CREATE INDEX "user_index" ON "public"."audits" USING btree ("user_id", "user_type");


DROP TABLE IF EXISTS "automation_rules";
DROP SEQUENCE IF EXISTS automation_rules_id_seq;
CREATE SEQUENCE automation_rules_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."automation_rules" (
    "id" bigint DEFAULT nextval('automation_rules_id_seq') NOT NULL,
    "account_id" bigint NOT NULL,
    "name" character varying NOT NULL,
    "description" text,
    "event_name" character varying NOT NULL,
    "conditions" jsonb DEFAULT '"{}"' NOT NULL,
    "actions" jsonb DEFAULT '"{}"' NOT NULL,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "active" boolean DEFAULT true NOT NULL,
    CONSTRAINT "automation_rules_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_automation_rules_on_account_id" ON "public"."automation_rules" USING btree ("account_id");


DROP TABLE IF EXISTS "campaigns";
DROP SEQUENCE IF EXISTS campaigns_id_seq;
CREATE SEQUENCE campaigns_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."campaigns" (
    "id" bigint DEFAULT nextval('campaigns_id_seq') NOT NULL,
    "display_id" integer NOT NULL,
    "title" character varying NOT NULL,
    "description" text,
    "message" text NOT NULL,
    "sender_id" integer,
    "enabled" boolean DEFAULT true,
    "account_id" bigint NOT NULL,
    "inbox_id" bigint NOT NULL,
    "trigger_rules" jsonb DEFAULT '{}',
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "campaign_type" integer DEFAULT '0' NOT NULL,
    "campaign_status" integer DEFAULT '0' NOT NULL,
    "audience" jsonb DEFAULT '[]',
    "scheduled_at" timestamp,
    "trigger_only_during_business_hours" boolean DEFAULT false,
    CONSTRAINT "campaigns_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_campaigns_on_account_id" ON "public"."campaigns" USING btree ("account_id");

CREATE INDEX "index_campaigns_on_campaign_status" ON "public"."campaigns" USING btree ("campaign_status");

CREATE INDEX "index_campaigns_on_campaign_type" ON "public"."campaigns" USING btree ("campaign_type");

CREATE INDEX "index_campaigns_on_inbox_id" ON "public"."campaigns" USING btree ("inbox_id");

CREATE INDEX "index_campaigns_on_scheduled_at" ON "public"."campaigns" USING btree ("scheduled_at");


DELIMITER ;;

CREATE TRIGGER "campaigns_before_insert_row_tr" BEFORE INSERT ON "public"."campaigns" FOR EACH ROW EXECUTE FUNCTION campaigns_before_insert_row_tr();;

DELIMITER ;

DROP TABLE IF EXISTS "canned_responses";
DROP SEQUENCE IF EXISTS canned_responses_id_seq;
CREATE SEQUENCE canned_responses_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."canned_responses" (
    "id" integer DEFAULT nextval('canned_responses_id_seq') NOT NULL,
    "account_id" integer NOT NULL,
    "short_code" character varying,
    "content" text,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL,
    CONSTRAINT "canned_responses_pkey" PRIMARY KEY ("id")
) WITH (oids = false);


DROP TABLE IF EXISTS "categories";
DROP SEQUENCE IF EXISTS categories_id_seq;
CREATE SEQUENCE categories_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."categories" (
    "id" bigint DEFAULT nextval('categories_id_seq') NOT NULL,
    "account_id" integer NOT NULL,
    "portal_id" integer NOT NULL,
    "name" character varying,
    "description" text,
    "position" integer,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "locale" character varying DEFAULT 'en',
    "slug" character varying NOT NULL,
    "parent_category_id" bigint,
    "associated_category_id" bigint,
    "icon" character varying DEFAULT '',
    CONSTRAINT "categories_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "index_categories_on_slug_and_locale_and_portal_id" UNIQUE ("slug", "locale", "portal_id")
) WITH (oids = false);

CREATE INDEX "index_categories_on_associated_category_id" ON "public"."categories" USING btree ("associated_category_id");

CREATE INDEX "index_categories_on_locale" ON "public"."categories" USING btree ("locale");

CREATE INDEX "index_categories_on_locale_and_account_id" ON "public"."categories" USING btree ("locale", "account_id");

CREATE INDEX "index_categories_on_parent_category_id" ON "public"."categories" USING btree ("parent_category_id");


DROP TABLE IF EXISTS "channel_api";
DROP SEQUENCE IF EXISTS channel_api_id_seq;
CREATE SEQUENCE channel_api_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."channel_api" (
    "id" bigint DEFAULT nextval('channel_api_id_seq') NOT NULL,
    "account_id" integer NOT NULL,
    "webhook_url" character varying,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "identifier" character varying,
    "hmac_token" character varying,
    "hmac_mandatory" boolean DEFAULT false,
    "additional_attributes" jsonb DEFAULT '{}',
    CONSTRAINT "channel_api_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "index_channel_api_on_hmac_token" UNIQUE ("hmac_token"),
    CONSTRAINT "index_channel_api_on_identifier" UNIQUE ("identifier")
) WITH (oids = false);


DROP TABLE IF EXISTS "channel_email";
DROP SEQUENCE IF EXISTS channel_email_id_seq;
CREATE SEQUENCE channel_email_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."channel_email" (
    "id" bigint DEFAULT nextval('channel_email_id_seq') NOT NULL,
    "account_id" integer NOT NULL,
    "email" character varying NOT NULL,
    "forward_to_email" character varying NOT NULL,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "imap_enabled" boolean DEFAULT false,
    "imap_address" character varying DEFAULT '',
    "imap_port" integer DEFAULT '0',
    "imap_login" character varying DEFAULT '',
    "imap_password" character varying DEFAULT '',
    "imap_enable_ssl" boolean DEFAULT true,
    "smtp_enabled" boolean DEFAULT false,
    "smtp_address" character varying DEFAULT '',
    "smtp_port" integer DEFAULT '0',
    "smtp_login" character varying DEFAULT '',
    "smtp_password" character varying DEFAULT '',
    "smtp_domain" character varying DEFAULT '',
    "smtp_enable_starttls_auto" boolean DEFAULT true,
    "smtp_authentication" character varying DEFAULT 'login',
    "smtp_openssl_verify_mode" character varying DEFAULT 'none',
    "smtp_enable_ssl_tls" boolean DEFAULT false,
    "provider_config" jsonb DEFAULT '{}',
    "provider" character varying,
    CONSTRAINT "channel_email_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "index_channel_email_on_email" UNIQUE ("email"),
    CONSTRAINT "index_channel_email_on_forward_to_email" UNIQUE ("forward_to_email")
) WITH (oids = false);


DROP TABLE IF EXISTS "channel_line";
DROP SEQUENCE IF EXISTS channel_line_id_seq;
CREATE SEQUENCE channel_line_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."channel_line" (
    "id" bigint DEFAULT nextval('channel_line_id_seq') NOT NULL,
    "account_id" integer NOT NULL,
    "line_channel_id" character varying NOT NULL,
    "line_channel_secret" character varying NOT NULL,
    "line_channel_token" character varying NOT NULL,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "channel_line_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "index_channel_line_on_line_channel_id" UNIQUE ("line_channel_id")
) WITH (oids = false);


DROP TABLE IF EXISTS "channel_sms";
DROP SEQUENCE IF EXISTS channel_sms_id_seq;
CREATE SEQUENCE channel_sms_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."channel_sms" (
    "id" bigint DEFAULT nextval('channel_sms_id_seq') NOT NULL,
    "account_id" integer NOT NULL,
    "phone_number" character varying NOT NULL,
    "provider" character varying DEFAULT 'default',
    "provider_config" jsonb DEFAULT '{}',
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "channel_sms_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "index_channel_sms_on_phone_number" UNIQUE ("phone_number")
) WITH (oids = false);


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


DELIMITER ;;

CREATE TRIGGER "conversations_before_insert_row_tr" BEFORE INSERT ON "public"."conversations" FOR EACH ROW EXECUTE FUNCTION conversations_before_insert_row_tr();;

DELIMITER ;

DROP TABLE IF EXISTS "csat_survey_responses";
DROP SEQUENCE IF EXISTS csat_survey_responses_id_seq;
CREATE SEQUENCE csat_survey_responses_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."csat_survey_responses" (
    "id" bigint DEFAULT nextval('csat_survey_responses_id_seq') NOT NULL,
    "account_id" bigint NOT NULL,
    "conversation_id" bigint NOT NULL,
    "message_id" bigint NOT NULL,
    "rating" integer NOT NULL,
    "feedback_message" text,
    "contact_id" bigint NOT NULL,
    "assigned_agent_id" bigint,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "csat_survey_responses_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "index_csat_survey_responses_on_message_id" UNIQUE ("message_id")
) WITH (oids = false);

CREATE INDEX "index_csat_survey_responses_on_account_id" ON "public"."csat_survey_responses" USING btree ("account_id");

CREATE INDEX "index_csat_survey_responses_on_assigned_agent_id" ON "public"."csat_survey_responses" USING btree ("assigned_agent_id");

CREATE INDEX "index_csat_survey_responses_on_contact_id" ON "public"."csat_survey_responses" USING btree ("contact_id");

CREATE INDEX "index_csat_survey_responses_on_conversation_id" ON "public"."csat_survey_responses" USING btree ("conversation_id");


DROP TABLE IF EXISTS "custom_attribute_definitions";
DROP SEQUENCE IF EXISTS custom_attribute_definitions_id_seq;
CREATE SEQUENCE custom_attribute_definitions_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."custom_attribute_definitions" (
    "id" bigint DEFAULT nextval('custom_attribute_definitions_id_seq') NOT NULL,
    "attribute_display_name" character varying,
    "attribute_key" character varying,
    "attribute_display_type" integer DEFAULT '0',
    "default_value" integer,
    "attribute_model" integer DEFAULT '0',
    "account_id" bigint,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "attribute_description" text,
    "attribute_values" jsonb DEFAULT '[]',
    "regex_pattern" character varying,
    "regex_cue" character varying,
    CONSTRAINT "attribute_key_model_index" UNIQUE ("attribute_key", "attribute_model", "account_id"),
    CONSTRAINT "custom_attribute_definitions_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_custom_attribute_definitions_on_account_id" ON "public"."custom_attribute_definitions" USING btree ("account_id");



DROP TABLE IF EXISTS "dashboard_apps";
DROP SEQUENCE IF EXISTS dashboard_apps_id_seq;
CREATE SEQUENCE dashboard_apps_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."dashboard_apps" (
    "id" bigint DEFAULT nextval('dashboard_apps_id_seq') NOT NULL,
    "title" character varying NOT NULL,
    "content" jsonb DEFAULT '[]',
    "account_id" bigint NOT NULL,
    "user_id" bigint,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "dashboard_apps_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_dashboard_apps_on_account_id" ON "public"."dashboard_apps" USING btree ("account_id");

CREATE INDEX "index_dashboard_apps_on_user_id" ON "public"."dashboard_apps" USING btree ("user_id");


DROP TABLE IF EXISTS "data_imports";
DROP SEQUENCE IF EXISTS data_imports_id_seq;
CREATE SEQUENCE data_imports_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."data_imports" (
    "id" bigint DEFAULT nextval('data_imports_id_seq') NOT NULL,
    "account_id" bigint NOT NULL,
    "data_type" character varying NOT NULL,
    "status" integer DEFAULT '0' NOT NULL,
    "processing_errors" text,
    "total_records" integer,
    "processed_records" integer,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "data_imports_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_data_imports_on_account_id" ON "public"."data_imports" USING btree ("account_id");





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


DROP TABLE IF EXISTS "integrations_hooks";
DROP SEQUENCE IF EXISTS integrations_hooks_id_seq;
CREATE SEQUENCE integrations_hooks_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."integrations_hooks" (
    "id" bigint DEFAULT nextval('integrations_hooks_id_seq') NOT NULL,
    "status" integer DEFAULT '1',
    "inbox_id" integer,
    "account_id" integer,
    "app_id" character varying,
    "hook_type" integer DEFAULT '0',
    "reference_id" character varying,
    "access_token" character varying,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "settings" jsonb DEFAULT '{}',
    CONSTRAINT "integrations_hooks_pkey" PRIMARY KEY ("id")
) WITH (oids = false);


DROP TABLE IF EXISTS "labels";
DROP SEQUENCE IF EXISTS labels_id_seq;
CREATE SEQUENCE labels_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."labels" (
    "id" bigint DEFAULT nextval('labels_id_seq') NOT NULL,
    "title" character varying,
    "description" text,
    "color" character varying DEFAULT '#1f93ff' NOT NULL,
    "show_on_sidebar" boolean,
    "account_id" bigint,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "index_labels_on_title_and_account_id" UNIQUE ("title", "account_id"),
    CONSTRAINT "labels_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_labels_on_account_id" ON "public"."labels" USING btree ("account_id");


DROP TABLE IF EXISTS "macros";
DROP SEQUENCE IF EXISTS macros_id_seq;
CREATE SEQUENCE macros_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."macros" (
    "id" bigint DEFAULT nextval('macros_id_seq') NOT NULL,
    "account_id" bigint NOT NULL,
    "name" character varying NOT NULL,
    "visibility" integer DEFAULT '0',
    "created_by_id" bigint,
    "updated_by_id" bigint,
    "actions" jsonb DEFAULT '{}' NOT NULL,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "macros_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_macros_on_account_id" ON "public"."macros" USING btree ("account_id");



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

;


DROP TABLE IF EXISTS "notification_settings";
DROP SEQUENCE IF EXISTS notification_settings_id_seq;
CREATE SEQUENCE notification_settings_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."notification_settings" (
    "id" bigint DEFAULT nextval('notification_settings_id_seq') NOT NULL,
    "account_id" integer,
    "user_id" integer,
    "email_flags" integer DEFAULT '0' NOT NULL,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "push_flags" integer DEFAULT '0' NOT NULL,
    CONSTRAINT "by_account_user" UNIQUE ("account_id", "user_id"),
    CONSTRAINT "notification_settings_pkey" PRIMARY KEY ("id")
) WITH (oids = false);


DROP TABLE IF EXISTS "notification_subscriptions";
DROP SEQUENCE IF EXISTS notification_subscriptions_id_seq;
CREATE SEQUENCE notification_subscriptions_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."notification_subscriptions" (
    "id" bigint DEFAULT nextval('notification_subscriptions_id_seq') NOT NULL,
    "user_id" bigint NOT NULL,
    "subscription_type" integer NOT NULL,
    "subscription_attributes" jsonb DEFAULT '{}' NOT NULL,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "identifier" text,
    CONSTRAINT "index_notification_subscriptions_on_identifier" UNIQUE ("identifier"),
    CONSTRAINT "notification_subscriptions_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_notification_subscriptions_on_user_id" ON "public"."notification_subscriptions" USING btree ("user_id");


DROP TABLE IF EXISTS "notifications";
DROP SEQUENCE IF EXISTS notifications_id_seq;
CREATE SEQUENCE notifications_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."notifications" (
    "id" bigint DEFAULT nextval('notifications_id_seq') NOT NULL,
    "account_id" bigint NOT NULL,
    "user_id" bigint NOT NULL,
    "notification_type" integer NOT NULL,
    "primary_actor_type" character varying NOT NULL,
    "primary_actor_id" bigint NOT NULL,
    "secondary_actor_type" character varying,
    "secondary_actor_id" bigint,
    "read_at" timestamp,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "snoozed_until" timestamp(6),
    "last_activity_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
    "meta" jsonb DEFAULT '{}',
    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_notifications_on_account_id" ON "public"."notifications" USING btree ("account_id");

CREATE INDEX "index_notifications_on_last_activity_at" ON "public"."notifications" USING btree ("last_activity_at");

CREATE INDEX "index_notifications_on_user_id" ON "public"."notifications" USING btree ("user_id");

CREATE INDEX "uniq_primary_actor_per_account_notifications" ON "public"."notifications" USING btree ("primary_actor_type", "primary_actor_id");

CREATE INDEX "uniq_secondary_actor_per_account_notifications" ON "public"."notifications" USING btree ("secondary_actor_type", "secondary_actor_id");


DROP VIEW IF EXISTS "pg_stat_statements";
CREATE TABLE "pg_stat_statements" ("userid" oid, "dbid" oid, "toplevel" boolean, "queryid" bigint, "query" text, "plans" bigint, "total_plan_time" double precision, "min_plan_time" double precision, "max_plan_time" double precision, "mean_plan_time" double precision, "stddev_plan_time" double precision, "calls" bigint, "total_exec_time" double precision, "min_exec_time" double precision, "max_exec_time" double precision, "mean_exec_time" double precision, "stddev_exec_time" double precision, "rows" bigint, "shared_blks_hit" bigint, "shared_blks_read" bigint, "shared_blks_dirtied" bigint, "shared_blks_written" bigint, "local_blks_hit" bigint, "local_blks_read" bigint, "local_blks_dirtied" bigint, "local_blks_written" bigint, "temp_blks_read" bigint, "temp_blks_written" bigint, "blk_read_time" double precision, "blk_write_time" double precision, "wal_records" bigint, "wal_fpi" bigint, "wal_bytes" numeric);


DROP VIEW IF EXISTS "pg_stat_statements_info";
CREATE TABLE "pg_stat_statements_info" ("dealloc" bigint, "stats_reset" timestamptz);


DROP TABLE IF EXISTS "platform_app_permissibles";
DROP SEQUENCE IF EXISTS platform_app_permissibles_id_seq;
CREATE SEQUENCE platform_app_permissibles_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."platform_app_permissibles" (
    "id" bigint DEFAULT nextval('platform_app_permissibles_id_seq') NOT NULL,
    "platform_app_id" bigint NOT NULL,
    "permissible_type" character varying NOT NULL,
    "permissible_id" bigint NOT NULL,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "platform_app_permissibles_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "unique_permissibles_index" UNIQUE ("platform_app_id", "permissible_id", "permissible_type")
) WITH (oids = false);

CREATE INDEX "index_platform_app_permissibles_on_permissibles" ON "public"."platform_app_permissibles" USING btree ("permissible_type", "permissible_id");

CREATE INDEX "index_platform_app_permissibles_on_platform_app_id" ON "public"."platform_app_permissibles" USING btree ("platform_app_id");


DROP TABLE IF EXISTS "platform_apps";
DROP SEQUENCE IF EXISTS platform_apps_id_seq;
CREATE SEQUENCE platform_apps_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."platform_apps" (
    "id" bigint DEFAULT nextval('platform_apps_id_seq') NOT NULL,
    "name" character varying NOT NULL,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "platform_apps_pkey" PRIMARY KEY ("id")
) WITH (oids = false);


DROP TABLE IF EXISTS "portal_members";
DROP SEQUENCE IF EXISTS portal_members_id_seq;
CREATE SEQUENCE portal_members_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."portal_members" (
    "id" bigint DEFAULT nextval('portal_members_id_seq') NOT NULL,
    "portal_id" bigint,
    "user_id" bigint,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "index_portal_members_on_portal_id_and_user_id" UNIQUE ("portal_id", "user_id"),
    CONSTRAINT "index_portal_members_on_user_id_and_portal_id" UNIQUE ("user_id", "portal_id"),
    CONSTRAINT "portal_members_pkey" PRIMARY KEY ("id")
) WITH (oids = false);


DROP TABLE IF EXISTS "portals";
DROP SEQUENCE IF EXISTS portals_id_seq;
CREATE SEQUENCE portals_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."portals" (
    "id" bigint DEFAULT nextval('portals_id_seq') NOT NULL,
    "account_id" integer NOT NULL,
    "name" character varying NOT NULL,
    "slug" character varying NOT NULL,
    "custom_domain" character varying,
    "color" character varying,
    "homepage_link" character varying,
    "page_title" character varying,
    "header_text" text,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "config" jsonb DEFAULT '{"allowed_locales": ["en"]}',
    "archived" boolean DEFAULT false,
    "channel_web_widget_id" bigint,
    CONSTRAINT "index_portals_on_custom_domain" UNIQUE ("custom_domain"),
    CONSTRAINT "index_portals_on_slug" UNIQUE ("slug"),
    CONSTRAINT "portals_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_portals_on_channel_web_widget_id" ON "public"."portals" USING btree ("channel_web_widget_id");


DROP TABLE IF EXISTS "portals_members";
CREATE TABLE "public"."portals_members" (
    "portal_id" bigint NOT NULL,
    "user_id" bigint NOT NULL,
    CONSTRAINT "index_portals_members_on_portal_id_and_user_id" UNIQUE ("portal_id", "user_id")
) WITH (oids = false);

CREATE INDEX "index_portals_members_on_portal_id" ON "public"."portals_members" USING btree ("portal_id");

CREATE INDEX "index_portals_members_on_user_id" ON "public"."portals_members" USING btree ("user_id");


DROP TABLE IF EXISTS "related_categories";
DROP SEQUENCE IF EXISTS related_categories_id_seq;
CREATE SEQUENCE related_categories_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."related_categories" (
    "id" bigint DEFAULT nextval('related_categories_id_seq') NOT NULL,
    "category_id" bigint,
    "related_category_id" bigint,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "index_related_categories_on_category_id_and_related_category_id" UNIQUE ("category_id", "related_category_id"),
    CONSTRAINT "index_related_categories_on_related_category_id_and_category_id" UNIQUE ("related_category_id", "category_id"),
    CONSTRAINT "related_categories_pkey" PRIMARY KEY ("id")
) WITH (oids = false);


DROP TABLE IF EXISTS "reporting_events";
DROP SEQUENCE IF EXISTS reporting_events_id_seq;
CREATE SEQUENCE reporting_events_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."reporting_events" (
    "id" bigint DEFAULT nextval('reporting_events_id_seq') NOT NULL,
    "name" character varying,
    "value" double precision,
    "account_id" integer,
    "inbox_id" integer,
    "user_id" integer,
    "conversation_id" integer,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "value_in_business_hours" double precision,
    "event_start_time" timestamp,
    "event_end_time" timestamp,
    CONSTRAINT "reporting_events_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_reporting_events_on_account_id" ON "public"."reporting_events" USING btree ("account_id");

CREATE INDEX "index_reporting_events_on_conversation_id" ON "public"."reporting_events" USING btree ("conversation_id");

CREATE INDEX "index_reporting_events_on_created_at" ON "public"."reporting_events" USING btree ("created_at");

CREATE INDEX "index_reporting_events_on_inbox_id" ON "public"."reporting_events" USING btree ("inbox_id");

CREATE INDEX "index_reporting_events_on_name" ON "public"."reporting_events" USING btree ("name");

CREATE INDEX "index_reporting_events_on_user_id" ON "public"."reporting_events" USING btree ("user_id");

CREATE INDEX "reporting_events__account_id__name__created_at" ON "public"."reporting_events" USING btree ("account_id", "name", "created_at");


DROP TABLE IF EXISTS "schema_migrations";
CREATE TABLE "public"."schema_migrations" (
    "version" character varying NOT NULL,
    CONSTRAINT "schema_migrations_pkey" PRIMARY KEY ("version")
) WITH (oids = false);


DROP TABLE IF EXISTS "sla_events";
DROP SEQUENCE IF EXISTS sla_events_id_seq;
CREATE SEQUENCE sla_events_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."sla_events" (
    "id" bigint DEFAULT nextval('sla_events_id_seq') NOT NULL,
    "applied_sla_id" bigint NOT NULL,
    "conversation_id" bigint NOT NULL,
    "account_id" bigint NOT NULL,
    "sla_policy_id" bigint NOT NULL,
    "inbox_id" bigint NOT NULL,
    "event_type" integer,
    "meta" jsonb DEFAULT '{}',
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "sla_events_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_sla_events_on_account_id" ON "public"."sla_events" USING btree ("account_id");

CREATE INDEX "index_sla_events_on_applied_sla_id" ON "public"."sla_events" USING btree ("applied_sla_id");

CREATE INDEX "index_sla_events_on_conversation_id" ON "public"."sla_events" USING btree ("conversation_id");

CREATE INDEX "index_sla_events_on_inbox_id" ON "public"."sla_events" USING btree ("inbox_id");

CREATE INDEX "index_sla_events_on_sla_policy_id" ON "public"."sla_events" USING btree ("sla_policy_id");


DROP TABLE IF EXISTS "sla_policies";
DROP SEQUENCE IF EXISTS sla_policies_id_seq;
CREATE SEQUENCE sla_policies_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."sla_policies" (
    "id" bigint DEFAULT nextval('sla_policies_id_seq') NOT NULL,
    "name" character varying NOT NULL,
    "first_response_time_threshold" double precision,
    "next_response_time_threshold" double precision,
    "only_during_business_hours" boolean DEFAULT false,
    "account_id" bigint NOT NULL,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "description" character varying,
    "resolution_time_threshold" double precision,
    CONSTRAINT "sla_policies_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_sla_policies_on_account_id" ON "public"."sla_policies" USING btree ("account_id");


DROP TABLE IF EXISTS "taggings";
DROP SEQUENCE IF EXISTS taggings_id_seq;
CREATE SEQUENCE taggings_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."taggings" (
    "id" integer DEFAULT nextval('taggings_id_seq') NOT NULL,
    "tag_id" integer,
    "taggable_type" character varying,
    "taggable_id" integer,
    "tagger_type" character varying,
    "tagger_id" integer,
    "context" character varying(128),
    "created_at" timestamp,
    CONSTRAINT "taggings_idx" UNIQUE ("tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"),
    CONSTRAINT "taggings_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_taggings_on_context" ON "public"."taggings" USING btree ("context");

CREATE INDEX "index_taggings_on_tag_id" ON "public"."taggings" USING btree ("tag_id");

CREATE INDEX "index_taggings_on_taggable_id" ON "public"."taggings" USING btree ("taggable_id");

CREATE INDEX "index_taggings_on_taggable_id_and_taggable_type_and_context" ON "public"."taggings" USING btree ("taggable_id", "taggable_type", "context");

CREATE INDEX "index_taggings_on_taggable_type" ON "public"."taggings" USING btree ("taggable_type");

CREATE INDEX "index_taggings_on_tagger_id" ON "public"."taggings" USING btree ("tagger_id");

CREATE INDEX "index_taggings_on_tagger_id_and_tagger_type" ON "public"."taggings" USING btree ("tagger_id", "tagger_type");

CREATE INDEX "taggings_idy" ON "public"."taggings" USING btree ("taggable_id", "taggable_type", "tagger_id", "context");


DROP TABLE IF EXISTS "tags";
DROP SEQUENCE IF EXISTS tags_id_seq;
CREATE SEQUENCE tags_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."tags" (
    "id" integer DEFAULT nextval('tags_id_seq') NOT NULL,
    "name" character varying,
    "taggings_count" integer DEFAULT '0',
    CONSTRAINT "index_tags_on_name" UNIQUE ("name"),
    CONSTRAINT "tags_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "tags_name_trgm_idx" ON "public"."tags" USING btree ("");


DROP TABLE IF EXISTS "team_members";
DROP SEQUENCE IF EXISTS team_members_id_seq;
CREATE SEQUENCE team_members_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."team_members" (
    "id" bigint DEFAULT nextval('team_members_id_seq') NOT NULL,
    "team_id" bigint NOT NULL,
    "user_id" bigint NOT NULL,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "index_team_members_on_team_id_and_user_id" UNIQUE ("team_id", "user_id"),
    CONSTRAINT "team_members_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_team_members_on_team_id" ON "public"."team_members" USING btree ("team_id");

CREATE INDEX "index_team_members_on_user_id" ON "public"."team_members" USING btree ("user_id");


DROP TABLE IF EXISTS "teams";
DROP SEQUENCE IF EXISTS teams_id_seq;
CREATE SEQUENCE teams_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."teams" (
    "id" bigint DEFAULT nextval('teams_id_seq') NOT NULL,
    "name" character varying NOT NULL,
    "description" text,
    "allow_auto_assign" boolean DEFAULT true,
    "account_id" bigint NOT NULL,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    CONSTRAINT "index_teams_on_name_and_account_id" UNIQUE ("name", "account_id"),
    CONSTRAINT "teams_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "index_teams_on_account_id" ON "public"."teams" USING btree ("account_id");


DROP TABLE IF EXISTS "telegram_bots";
DROP SEQUENCE IF EXISTS telegram_bots_id_seq;
CREATE SEQUENCE telegram_bots_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."telegram_bots" (
    "id" integer DEFAULT nextval('telegram_bots_id_seq') NOT NULL,
    "name" character varying,
    "auth_key" character varying,
    "account_id" integer,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL,
    CONSTRAINT "telegram_bots_pkey" PRIMARY KEY ("id")
) WITH (oids = false);


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
(1,	'email',	'admin@chatwoot.com',	'$2a$11$FtIwlc0cdqKbSrRJVPuBYOHIvYjc7NylNLAfcjw0lfLHNWqARbQ36',	NULL,	NULL,	NULL,	12,	'2024-08-08 19:29:03.407769',	'2024-08-08 15:34:36.177332',	'47.231.131.141',	'47.231.131.141',	'ziPzDdGrZmz1zDfm9LQr',	'2024-08-07 08:27:31.496809',	'2024-08-07 08:27:31.496809',	NULL,	'Admin',	NULL,	'admin@chatwoot.com',	'"{\"37axtS1x5PhE5Hc8UmFK2A\":{\"token\":\"$2a$10$vBa6lVOcurYSmFYUz0amUOb0iYU6jM2AwSNrWR9.DTG0DCc2B616i\",\"expiry\":1728372057},\"w-9ezLW_NxQt7In0LBAbsQ\":{\"token\":\"$2a$10$BmsdWjTTAPvkaV3c22/QG.Yqn5cKsDatKK7L4iGxu7XE0dNuYACEy\",\"expiry\":1728373116},\"CK4gXouuMT493Gad1Gy8Vg\":{\"token\":\"$2a$10$2K/Xw3kPsAFAZ7tFeYQyyu0hod3fTq62d4z3UTKfTkK5BBgNAbTuu\",\"expiry\":1728415743}}"',	'2024-08-07 08:27:31.496601',	'2024-08-08 19:29:03.408432',	'KhhyuCY6g3n4DmnwNZ3b476W',	0,	'{"rtl_view": false, "conversation_display_type": "condensed", "previously_used_conversation_display_type": "condensed"}',	'{}',	NULL,	NULL),
(3,	'email',	'rkpers2009@gmail.com',	'$2a$11$XfjTw7rjt9wVy2F43l54LetSsOYYqsdyZbhebWvUTYGXqZxcH5veW',	NULL,	NULL,	NULL,	1,	'2024-08-08 19:28:02.693907',	'2024-08-08 19:28:02.693907',	'47.231.131.141',	'47.231.131.141',	'2oXLVfmhxr8hVREvWtnZ',	'2024-08-08 19:26:38.457177',	'2024-08-08 19:26:38.457177',	NULL,	'rkpers2009',	NULL,	'rkpers2009@gmail.com',	'"{\"rY9qbbvpxqJt8JEYDrcktw\":{\"token\":\"$2a$10$nEYbGFKXuyoFWxImwEZ3OOzyWUyI0tZDuo2YpAoaBh4FxWVirGTpi\",\"expiry\":1728415682}}"',	'2024-08-08 19:26:38.457102',	'2024-08-08 19:28:47.893961',	'vfyG4vXqN4bcUBZSx16y3jvm',	0,	'{"rtl_view": false, "conversation_display_type": "condensed", "previously_used_conversation_display_type": "condensed"}',	'{}',	NULL,	NULL),
(2,	'email',	'kumarbets@chatwoot.com',	'$2a$11$1HmIfxMJ5yOB9ioUo3yG7uNm1jl8gUBdVStiq3ZMqGPzFBOtUP5CK',	NULL,	NULL,	NULL,	1,	'2024-08-08 19:33:07.272966',	'2024-08-08 19:33:07.272966',	'47.231.131.141',	'47.231.131.141',	'Egjc8qh5FFe8b1Cy-5FZ',	'2024-08-08 19:25:23.953186',	'2024-08-08 19:25:23.953186',	NULL,	'Kumarbets',	NULL,	'kumarbets@chatwoot.com',	'"{\"q-55N1vxr2o4QdfqlY0d_A\":{\"token\":\"$2a$10$0fSdhfuFwN/NbUo4NEMPXOYX2Fd3mKJBPQ0VjUn5uGKKRQaUPesKu\",\"expiry\":1728415987}}"',	'2024-08-08 19:25:23.953008',	'2024-08-08 19:33:07.273347',	'wdmxqJpGLXr9Z9dScKjDfEkG',	0,	'{"rtl_view": false, "conversation_display_type": "condensed", "previously_used_conversation_display_type": "condensed"}',	'{}',	NULL,	NULL);

DROP TABLE IF EXISTS "webhooks";
DROP SEQUENCE IF EXISTS webhooks_id_seq;
CREATE SEQUENCE webhooks_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."webhooks" (
    "id" bigint DEFAULT nextval('webhooks_id_seq') NOT NULL,
    "account_id" integer,
    "inbox_id" integer,
    "url" character varying,
    "created_at" timestamp(6) NOT NULL,
    "updated_at" timestamp(6) NOT NULL,
    "webhook_type" integer DEFAULT '0',
    "subscriptions" jsonb DEFAULT '["conversation_status_changed", "conversation_updated", "conversation_created", "contact_created", "contact_updated", "message_created", "message_updated", "webwidget_triggered"]',
    CONSTRAINT "index_webhooks_on_account_id_and_url" UNIQUE ("account_id", "url"),
    CONSTRAINT "webhooks_pkey" PRIMARY KEY ("id")
) WITH (oids = false);


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


ALTER TABLE ONLY "public"."active_storage_attachments" ADD CONSTRAINT "fk_rails_c3b3935057" FOREIGN KEY (blob_id) REFERENCES active_storage_blobs(id) NOT DEFERRABLE;

ALTER TABLE ONLY "public"."active_storage_variant_records" ADD CONSTRAINT "fk_rails_993965df05" FOREIGN KEY (blob_id) REFERENCES active_storage_blobs(id) NOT DEFERRABLE;

ALTER TABLE ONLY "public"."inboxes" ADD CONSTRAINT "fk_rails_a1f654bf2d" FOREIGN KEY (portal_id) REFERENCES portals(id) NOT DEFERRABLE;

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

-- 2024-08-08 21:05:36.642098+00