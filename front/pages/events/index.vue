<template lang="pug">
v-container
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-btn.pull-right(color="primary" @click="moveEventNew") 大会登録
  v-data-table(:headers="fields" :items="events" :items-per-page="5" class="elevation-1")
</template>

<script>
import axios from '~/plugins/axios'

export default {
  data () {
    return {
      name: '',
      events: [],
      fields: [
        { text: '大会名', value: 'name' },
        { text: 'イベントディレクター', value: 'director' },
        { text: '開催期間(start)', value: 'start_term' },
        { text: '開催期間(end)', value: 'end_term' }
      ]
    }
  },
  created () {
    axios.get('/events').then((res) => {
      if (res.data) {
        this.events = res.data
      }
    })
  },
  methods: {
    moveEventNew () {
      this.$router.push('/events/new')
    }
  }
}
</script>

<style>
.pull-right {
  float: right;
  margin-bottom: 10px;
}
</style>
