<template lang="pug">
v-container
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="タスク名" v-model="name" prepend-icon="" type="text")
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="略称" v-model="short_name" prepend-icon="" type="text")
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="説明" v-model="description" prepend-icon="" type="text")
  v-btn(@click="moveTaskTypes") 戻る
</template>

<script>
import axios from '~/plugins/axios'

export default {
  data () {
    return {
      name: '',
      short_name: '',
      description: '',
      id: this.$route.params.id
    }
  },
  created () {
    axios.get('/task_types/' + this.id).then((res) => {
      console.log('res.data')
      console.log(res.data)
      if (res.data) {
        this.name = res.data.name
        this.short_name = res.data.short_name
        this.description = res.data.description
      }
    })
  },
  methods: {
    moveTaskTypes () {
      this.$router.push('/task_types')
    }
  }
}
</script>
