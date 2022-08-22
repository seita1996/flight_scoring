<template lang="pug">
v-main
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(v-model="name" label="Username" prepend-icon="" type="text")
      v-btn(color="primary" @click="createUser") 登録
    v-col(cols="12")
      h1 Hello, Qiita!
  v-card(class="mx-auto" max-width="300" tile)
    v-list(rounded)
      v-subheader USERS
      v-list-item-group(color="primary")
        v-list-item(v-for="user in users" :key="user.id")
          v-list-item-content
            v-list-item-title(v-text="user.name")
</template>

<script>
import axios from '~/plugins/axios'

export default {
  data () {
    return {
      name: '',
      users: []
    }
  },
  created () {
    // ユーザーをaxiosで取得
    axios.get('/users').then((res) => {
      if (res.data) {
        this.users = res.data
      }
    })
  },
  methods: {
    // ユーザーをaxiosで登録
    createUser () {
      axios.post('/users', { name: this.name }).then((res) => {
        if (res.data) {
          this.users.push(res.data)
        }
      })
    }
  }
}
</script>
