<script>
import messageFormatterMixin from 'shared/mixins/messageFormatterMixin';
import ChatCard from 'shared/components/ChatCard.vue';
import ChatForm from 'shared/components/ChatForm.vue';
import ChatOptions from 'shared/components/ChatOptions.vue';

import EmailInput from './template/EmailInput.vue';

import darkModeMixin from 'widget/mixins/darkModeMixin.js';


export default {
  name: 'AgentMessageBubble',
  components: {
    ChatCard,
    ChatForm,
    ChatOptions,
    EmailInput,

  },
  mixins: [messageFormatterMixin, darkModeMixin],
  props: {
    message: { type: String, default: null },
    contentType: { type: String, default: null },
    messageType: { type: Number, default: null },
    messageId: { type: Number, default: null },
    messageContentAttributes: {
      type: Object,
      default: () => {},
    },
  },
  computed: {
    isTemplate() {
      return this.messageType === 3;
    },
    isTemplateEmail() {
      return this.contentType === 'input_email';
    },
    isCards() {
      return this.contentType === 'cards';
    },
    isOptions() {
      return this.contentType === 'input_select';
    },
    isForm() {
      return this.contentType === 'form';
    },
    

  },
  methods: {
    onResponse(messageResponse) {
      this.$store.dispatch('message/update', messageResponse);
    },
    onOptionSelect(selectedOption) {
      this.onResponse({
        submittedValues: [selectedOption],
        messageId: this.messageId,
      });
    },
    onFormSubmit(formValues) {
      const formValuesAsArray = Object.keys(formValues).map(key => ({
        name: key,
        value: formValues[key],
      }));
      this.onResponse({
        submittedValues: formValuesAsArray,
        messageId: this.messageId,
      });
    },
  },
};
</script>

<template>
  <div class="chat-bubble-wrap">
    <div
      v-if="
        !isCards && !isOptions && !isForm &&  !isCards 
      "
      class="chat-bubble agent"
      :class="$dm('bg-white', 'dark:bg-slate-700 has-dark-mode')"
    >
      <div
        v-dompurify-html="formatMessage(message, false)"
        class="message-content text-slate-900 dark:text-slate-50"
      />
      <EmailInput
        v-if="isTemplateEmail"
        :message-id="messageId"
        :message-content-attributes="messageContentAttributes"
      />


    </div>
    <div v-if="isOptions">
      <ChatOptions
        :title="message"
        :options="messageContentAttributes.items"
        :hide-fields="!!messageContentAttributes.submitted_values"
        @click="onOptionSelect"
      />
    </div>
    <ChatForm
      v-if="isForm && !messageContentAttributes.submitted_values"
      :items="messageContentAttributes.items"
      :button-label="messageContentAttributes.button_label"
      :submitted-values="messageContentAttributes.submitted_values"
      @submit="onFormSubmit"
    />
    <div v-if="isCards">
      <ChatCard
        v-for="item in messageContentAttributes.items"
        :key="item.title"
        :media-url="item.media_url"
        :title="item.title"
        :description="item.description"
        :actions="item.actions"
      />
    </div>
 
  </div>
</template>
