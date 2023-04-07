<template lang="pug">
PzForm(formType='new' :areaId="areaId")
</template>

<script>
import PzForm from '~/components/PzForm.vue'

export default {
  components: {
    PzForm
  },
  data () {
    return {
      areaId: parseInt(this.$route.params.areaId)
    }
  }
}
</script>
