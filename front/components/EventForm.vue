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
  v-btn.pull-right(color="primary" @click="clickButton") {{ button_name }}
</template>

<script>
import axios from '~/plugins/axios'
import DateRangePicker from '~/components/DateRangePicker.vue'

export default {
  components: {
    DateRangePicker
  },
  props: {
    formType: {
      type: String,
      default: ''
    },
    eventId: {
      type: Number,
      default: 0
    }
  },
  data () {
    return {
      name: '',
      director: '',
      selectedArea: null,
      dates: [],
      areas: [],
      button_name: ''
    }
  },
  notifications: {
    toast: {
      type: 'success',
      message: 'test message'
    }
  },
  mounted () {
    if (this.formType === 'new') {
      this.button_name = '登録'
    } else if (this.formType === 'edit') {
      this.button_name = '更新'
      axios.get('/events/' + this.eventId).then((res) => {
        if (res.data) {
          this.name = res.data.name
          this.director = res.data.director
          this.selectedArea = res.data.area.id
        }
      })
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
    clickButton () {
      const startTerm = new Date(this.dates[0].replace('-', '/'))
      const endTerm = new Date(this.dates[1].replace('-', '/'))
      if (this.formType === 'new') {
        this.createEvent(startTerm, endTerm)
      } else if (this.formType === 'edit') {
        this.updateEvent(this.eventId, startTerm, endTerm)
      }
    },
    createEvent (startTerm, endTerm) {
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
    updateEvent (id, startTerm, endTerm) {
      const self = this
      axios.put('/events/' + id, { name: this.name, area_id: this.selectedArea, director: this.director, start_term: startTerm, end_term: endTerm }).then((res) => {
        self.$router.push('/events')
        self.toast({
          type: 'success',
          message: '更新が完了しました',
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
