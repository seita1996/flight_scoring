<template lang="pug">
PzForm(formType='edit' :pzId="id" :areaId="areaId")
</template>

<script>
import PzForm from '~/components/PzForm.vue'

export default {
  components: {
    PzForm
  },
  data () {
    return {
      id: this.$route.params.id,
      areaId: parseInt(this.$route.params.areaId)
    }
  }
}
</script>
