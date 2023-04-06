<template lang="pug">
v-container
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="タスク名" v-model="name" prepend-icon="" type="text")
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="略称（英字３文字）" v-model="short_name" prepend-icon="" type="text")
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="説明" v-model="description" prepend-icon="" type="text")
  v-btn(@click="moveTaskType") 戻る
  v-btn.pull-right(color="primary" @click="createTaskType") タスクタイプ登録
</template>

<script>
import axios from '~/plugins/axios'

export default {
  data () {
    return {
      name: '',
      short_name: '',
      description: ''
    }
  },
  notifications: {
    toast: {
      type: 'success',
      message: ''
    }
  },
  methods: {
    createTaskType () {
      const self = this
      axios.post('/task_types', { name: this.name, short_name: this.short_name, description: this.description }).then((res) => {
        self.$router.push('/task_types')
        self.toast({
          type: 'success',
          message: '登録が完了しました',
          timeout: 2000
        })
      })
    },
    moveTaskType () {
      this.$router.push('/task_types')
    }
  }
}
</script>

<style>
.pull-right {
  float: right;
}
</style>
