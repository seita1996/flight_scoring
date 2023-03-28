<template lang="pug">
v-container
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="大会名" v-model="name" prepend-icon="" type="text")
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="イベントディレクター名" v-model="director" prepend-icon="" type="text")
  DateRangePicker(@updateDates="updateDates")
  v-btn(@click="moveEvent") 戻る
  v-btn.pull-right(color="primary" @click="createEvent") 大会登録
</template>

<script>
export default {
  data () {
    return {
    }
  },
  created () {
    console.log('this.$route.params')
    console.log(this.$route.params)
  },
  methods: {
    moveEvent () {
      this.$router.push('/events')
    }
  }
}
</script>
