<template lang="pug">
EventForm(formType='edit' :eventId="id")
</template>

<script>
import EventForm from '~/components/EventForm.vue'

export default {
  components: {
    EventForm
  },
  data () {
    return {
      id: this.$route.params.id
    }
  }
}
</script>
