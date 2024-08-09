export const INBOX_TYPES = {
  WEB: 'Channel::WebWidget',
};

export const INBOX_FEATURES = {
  REPLY_TO: 'replyTo',
  REPLY_TO_OUTGOING: 'replyToOutgoing',
};

// This is a single source of truth for inbox features
// This is used to check if a feature is available for a particular inbox or not
export const INBOX_FEATURE_MAP = {
  [INBOX_FEATURES.REPLY_TO]: [
    INBOX_TYPES.WEB,
    INBOX_TYPES.API,
  ],
  [INBOX_FEATURES.REPLY_TO_OUTGOING]: [
    INBOX_TYPES.WEB,
    INBOX_TYPES.API,
  ],
};

export default {
  computed: {
    channelType() {
      return this.inbox.channel_type;
    },


    isAGoogleInbox() {
      return this.isAnEmailChannel && this.inbox.provider === 'google';
    },
    isAPIInbox() {
      return this.channelType === INBOX_TYPES.API;
    },

    isAWebWidgetInbox() {
      return this.channelType === INBOX_TYPES.WEB;
    },


    isAnEmailChannel() {
      return this.channelType === INBOX_TYPES.EMAIL;
    },


    inboxBadge() {
      let badgeKey = '';
  
      return badgeKey || this.channelType;
    },
 
  },
  methods: {
    inboxHasFeature(feature) {
      return INBOX_FEATURE_MAP[feature]?.includes(this.channelType) ?? false;
    },
  },
};
