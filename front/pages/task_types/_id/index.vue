<template lang="pug">
TaskTypeForm(formType='edit' :taskTypeId="id")
</template>

<script>
import TaskTypeForm from '~/components/TaskTypeForm.vue'

export default {
  components: {
    TaskTypeForm
  },
  data () {
    return {
      id: this.$route.params.id
    }
  }
}
</script>
