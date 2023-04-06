<template lang="pug">
v-container
  v-row(align="center" justify="center")
    v-col(cols="12")
        .text-h4.title タスク一覧
    v-col(cols="12")
      v-btn.pull-right(color="primary" @click="moveTaskTypeNew") 登録
  v-data-table(:headers="fields" :items="task_types" :items-per-page="5" class="elevation-1" @click:row="moveTaskTypeEdit")
    template(v-slot:item.action="{ item }")
      v-btn(outlined color="red" @click.stop="clickDelete(item)") 削除
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
        { text: '説明', value: 'description' },
        { text: '操作', value: 'action' }
      ]
    }
  },
  notifications: {
    toast: {
      type: 'success',
      message: ''
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
    moveTaskTypeEdit (row) {
      this.$router.push({ name: 'task_types-id', params: { id: row.id } })
    },
    moveTaskTypeNew () {
      this.$router.push('/task_types/new')
    },
    clickDelete (item) {
      const self = this
      axios.delete('/task_types/' + item.id).then(() => {
        self.$router.go({ path: self.$router.currentRoute.path, force: true })
        self.toast({
          type: 'success',
          message: '削除が完了しました',
          timeout: 2000
        })
      })
    }
  }
}
</script>

<style>
.pull-right {
  float: right;
  margin-bottom: 10px;
}
.title{
  text-align: center;
  margin-bottom: 20px;
}
</style>
