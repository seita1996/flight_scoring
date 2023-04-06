<template lang="pug">
v-container
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-btn.pull-right(color="primary" @click="moveTaskTypeNew") 登録
    v-col(cols="12")
        h1 タスク一覧
  v-data-table(:headers="fields" :items="task_types" :items-per-page="5" class="elevation-1")
    template(v-slot:[`item.name`]="{ item }")
      a(@click="moveTaskTypePage(item.id)") {{ item.name }}
</template>

<script>
import axios from '~/plugins/axios'

export default {
  data () {
    return {
      name: '',
      task_types: [],
      fields: [
        { text: 'タスク名', value: 'name' },
        { text: '略称', value: 'short_name' },
        { text: '説明', value: 'description' }
      ]
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
    moveTaskTypeNew () {
      this.$router.push('/task_types/new')
    },
    moveTaskTypePage (id) {
      this.$router.push({ name: 'task_types-id', params: { id } })
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
