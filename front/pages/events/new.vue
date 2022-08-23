<template lang="pug">
v-container
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="大会名" v-model="name" prepend-icon="" type="text")
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="イベントディレクター名" v-model="director" prepend-icon="" type="text")
  DateRangePicker
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
      director: ''
    }
  },
  methods: {
    createEvent () {
      const self = this
      axios.post('/events', { name: this.name, director: this.director }).then((res) => {
        self.$router.push('/events')
      })
    },
    moveEvent () {
      this.$router.push('/events')
    }
  }
}
</script>

<style>
.pull-right {
  float: right;
}
</style>
