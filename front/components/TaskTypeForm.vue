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
  v-btn.pull-right(color="primary" @click="createTaskType") {{ button_name }}
</template>

<script>
import axios from '~/plugins/axios'

export default {
  props: {
    formType: {
      type: String,
      default: ''
    },
    taskTypeId: {
      type: Number,
      default: 0
    }
  },
  data () {
    return {
      name: '',
      short_name: '',
      description: '',
      button_name: ''
    }
  },
  notifications: {
    toast: {
      type: 'success',
      message: ''
    }
  },
  mounted () {
    if (this.formType === 'new') {
      this.button_name = '登録'
    } else if (this.formType === 'edit') {
      this.button_name = '更新'
      console.log('更新')
      console.log(this.taskTypeId)
      axios.get('/task_types/' + this.taskTypeId).then((res) => {
        console.log('res.data')
        console.log(res.data)
        if (res.data) {
          this.name = res.data.name
          this.short_name = res.data.short_name
          this.description = res.data.description
        }
      })
    }
  },
  methods: {
    clickButton () {
      if (this.formType === 'new') {
        this.createTaskType()
      } else if (this.formType === 'edit') {
        this.updateTaskType()
      }
    },
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
    updateTaskType () {
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
