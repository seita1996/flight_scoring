<template lang="pug">
v-container
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-btn(color="primary" @click="moveEventNew") 大会登録
    v-col(cols="12")
        h1 大会一覧
  v-card(class="mx-auto" max-width="300" tile)
    v-list(rounded)
      v-subheader EVENTS
      v-list-item-group(color="primary")
        v-list-item(v-for="event in events" :key="event.id" @click="")
          v-list-item-content
            v-list-item-title(v-text="event.name")
</template>

<script>
import axios from '~/plugins/axios'

export default {
  data () {
    return {
      name: '',
      events: []
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
