<script>
import TeamAvailability from 'widget/components/TeamAvailability.vue';


import { mapGetters } from 'vuex';
import darkModeMixin from 'widget/mixins/darkModeMixin';
import routerMixin from 'widget/mixins/routerMixin';
import configMixin from 'widget/mixins/configMixin';

export default {
  name: 'Home',
  components: {
    TeamAvailability,
  },
  mixins: [configMixin, routerMixin, darkModeMixin],
  computed: {
    ...mapGetters({
      availableAgents: 'agent/availableAgents',
      conversationSize: 'conversation/getConversationSize',
      unreadMessageCount: 'conversation/getUnreadMessageCount',
    }),
    widgetLocale() {
      return this.$i18n.locale || 'en';
    },
 
    defaultLocale() {
      const widgetLocale = this.widgetLocale;
      const { allowed_locales: allowedLocales, default_locale: defaultLocale } =
        this.portal.config;

      // IMPORTANT: Variation strict locale matching, Follow iso_639_1_code
      // If the exact match of a locale is available in the list of portal locales, return it
      // Else return the default locale. Eg: `es` will not work if `es_ES` is available in the list
      if (allowedLocales.includes(widgetLocale)) {
        return widgetLocale;
      }
      return defaultLocale;
    },
  },
  mounted() {
  
  },
  methods: {
    startConversation() {
      if (this.preChatFormEnabled && !this.conversationSize) {
        return this.replaceRoute('prechat-form');
      }
      return this.replaceRoute('messages');
    },


  },
};
</script>

<template>
  <div
    class="z-50 flex flex-col flex-1 w-full rounded-md"
    :class="{ 'pb-2': showArticles, 'justify-end': !showArticles }"
  >
    <div class="w-full px-4 pt-4">
      <TeamAvailability
        :available-agents="availableAgents"
        :has-conversation="!!conversationSize"
        :unread-count="unreadMessageCount"
        @startConversation="startConversation"
      />
    </div>

 
  </div>
</template>
