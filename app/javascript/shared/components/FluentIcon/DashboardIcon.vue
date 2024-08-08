<script>
import BaseIcon from './Icon.vue';


export default {
  name: 'FluentIcon',
  components: {
    BaseIcon,
  },
  props: {
    icon: {
      type: String,
      required: true,
    },
    size: {
      type: [String, Number],
      default: '20',
    },
    type: {
      type: String,
      default: 'outline',
    },
    viewBox: {
      type: String,
      default: '0 0 24 24',
    },
    iconLib: {
      type: String,
      default: 'fluent',
    },
  },
  data() {
    return {  };
  },
};
</script>

<template>
  <BaseIcon
    :size="size"
    :icon="icon"
    :type="type"
    :icons=""
    :view-box="viewBox"
    :icon-lib="iconLib"
  />
</template>
