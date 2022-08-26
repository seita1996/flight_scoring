<template lang="pug">
v-container
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="タスク名" v-model="name" prepend-icon="" type="text")
      v-btn(color="primary" @click="createTaskType") 登録
    v-col(cols="12")
        h1 タスク一覧
  v-card(class="mx-auto" max-width="300" tile)
    v-list(rounded)
      v-subheader TASKTYPE
      v-list-item-group(color="primary")
        v-list-item(v-for="task_type in task_types" :key="task_type.id" @click="")
          v-list-item-content
            v-list-item-title(v-text="task_type.name")
</template>

<script>
import axios from '~/plugins/axios'

export default {
  data () {
    return {
      name: '',
      task_types: []
    }
  },
  created () {
    axios.get('/task_types').then((res) => {
      if (res.data) {
        this.task_types = res.data
      }
    })
  },
  methods: {
    createTaskType () {
      axios.post('/task_types', { name: this.name }).then((res) => {
        if (res.data) {
          this.task_types.push(res.data)
        }
      })
    }
  }
}
</script>
