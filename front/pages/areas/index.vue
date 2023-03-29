<template lang="pug">
v-container
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-btn.pull-right(color="primary" @click="moveAreaNew") エリア登録
  v-data-table(:headers="fields" :items="areas" :items-per-page="5" class="elevation-1")
    template(v-slot:[`item.name`]="{ item }")
      a(@click="moveEventPage(item.id)") {{ item.name }}
</template>

<script>
import axios from '~/plugins/axios'

export default {
  data () {
    return {
      name: '',
      areas: [],
      fields: [
        { text: 'エリア名', value: 'name' },
        { text: '地図ファイルURL', value: 'url' }
      ]
    }
  },
  created () {
    axios.get('/areas').then((res) => {
      if (res.data) {
        const areas = res.data
        areas.forEach((event) => {
          event.start_day = this.getFormatDate(event.start_term)
          event.end_day = this.getFormatDate(event.end_term)
        })
        this.areas = areas
      }
    })
  },
  methods: {
    moveAreaNew () {
      this.$router.push('/areas/new')
    },
    moveEventPage (id) {
      // this.$router.push({ path: `/areas/${id}` })
      this.$router.push({ name: 'areas-id', params: { id } })
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
