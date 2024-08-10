-- Adminer 4.8.1 PostgreSQL 14.12 dump

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
(1,	1,	1,	'9c211583-9412-40e7-9c0d-4c527dda3c3f',	'2024-08-10 14:09:08.800207',	'2024-08-10 14:09:08.800207',	'f',	'fggpJiGQjLcHPrs3th6WGHGc'),
(2,	2,	1,	'ccfeb93b-8ee6-44c8-ae82-0be5403814be',	'2024-08-10 14:23:25.875231',	'2024-08-10 14:23:25.875231',	'f',	'hgnojXSoVdzZnwLvFy5nv7Tt');

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
(1,	'twilight-brook-588',	NULL,	NULL,	1,	'2024-08-10 14:09:08.774864',	'2024-08-10 14:09:08.774864',	'{}',	NULL,	'{}',	NULL,	0,	'',	'',	'',	'',	'f'),
(2,	'solitary-wildflower-527',	NULL,	NULL,	1,	'2024-08-10 14:23:25.867038',	'2024-08-10 14:23:25.867038',	'{}',	NULL,	'{}',	NULL,	0,	'',	'',	'',	'',	'f');

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
(2,	1,	1,	0,	NULL,	'2024-08-10 14:23:34.002489',	'2024-08-10 14:23:34.183416',	2,	2,	'2024-08-10 14:23:34.176558',	'2024-08-10 14:25:44.694845',	'{}',	2,	'44e68778-cc2f-41aa-859f-b7920526160b',	NULL,	'2024-08-10 14:23:34.045379',	NULL,	NULL,	NULL,	'{}',	NULL,	NULL,	NULL,	NULL,	'2024-08-10 14:23:34.002489',	NULL),
(1,	1,	1,	0,	NULL,	'2024-08-10 14:09:20.527066',	'2024-08-10 14:12:00.673951',	1,	1,	'2024-08-10 14:12:00.670484',	'2024-08-10 14:25:48.239599',	'{}',	1,	'df40298d-19f6-44cb-8d7d-1f048ee20916',	NULL,	'2024-08-10 14:11:39.602372',	NULL,	NULL,	NULL,	'{}',	NULL,	'2024-08-10 14:10:21.034056',	NULL,	NULL,	'2024-08-10 14:11:39.602372',	NULL);

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
(1,	1,	1,	'2024-08-10 14:08:56.981972',	'2024-08-10 14:08:56.981972');

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
(1,	1,	1,	'w',	'2024-08-10 14:08:52.749061',	'2024-08-10 14:08:52.749061',	'Channel::WebWidget',	't',	'f',	'',	NULL,	'f',	NULL,	'UTC',	't',	'f',	't',	'{}',	'f',	NULL,	0,	NULL);

-- 2024-08-10 14:35:56.983145+00