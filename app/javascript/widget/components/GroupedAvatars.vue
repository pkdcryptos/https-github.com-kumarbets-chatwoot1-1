<script>

export default {
  name: 'GroupedAvatars',
  components: {  },
  props: {
    users: {
      type: Array,
      default: () => [],
    },
  },
};
</script>

<template>
  <div class="flex">
    <span
      v-for="(user, index) in users"
      :key="user.id"
      :class="`${
        index ? '-ml-4' : ''
      } inline-block rounded-full text-white shadow-solid`"
    >
    
    </span>
  </div>
</template>
