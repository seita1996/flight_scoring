<template lang="pug">
v-container
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="大会名" v-model="name" prepend-icon="" type="text")
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="イベントディレクター名" v-model="director" prepend-icon="" type="text")
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-select(label="エリア" v-model="selectedArea" :items="areas" item-text="name" item-value="id")
  DateRangePicker(@updateDates="updateDates")
  v-btn(@click="moveEvent") 戻る
  v-btn.pull-right(color="primary" @click="createEvent") 大会登録
</template>

<script>
import axios from '~/plugins/axios'
import DateRangePicker from '~/components/DateRangePicker.vue'

export default {
  components: {
    DateRangePicker
  },
  data () {
    return {
      name: '',
      director: '',
      selectedArea: null,
      dates: [],
      areas: []
    }
  },
  notifications: {
    toast: {
      type: 'success',
      message: 'test message'
    }
  },
  created () {
    axios.get('/areas').then((res) => {
      if (res.data) {
        this.areas = res.data.map((area) => {
          return { id: area.id, name: area.name }
        })
      }
    })
  },
  methods: {
    createEvent () {
      const startTerm = new Date(this.dates[0].replace('-', '/'))
      const endTerm = new Date(this.dates[1].replace('-', '/'))
      const self = this
      axios.post('/events', { name: this.name, area_id: this.selectedArea, director: this.director, start_term: startTerm, end_term: endTerm }).then((res) => {
        self.$router.push('/events')
        self.toast({
          type: 'success',
          message: '登録が完了しました',
          timeout: 2000
        })
      })
    },
    moveEvent () {
      this.$router.push('/events')
    },
    updateDates (dates) {
      this.dates = dates
    }
  }
}
</script>

<style>
.pull-right {
  float: right;
}
</style>
