<template lang="pug">
v-container
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="PZ名" v-model="name" prepend-icon="" type="text")
  Map
  v-btn(@click="backAreaIndex") 戻る
  v-btn.pull-right(color="primary" @click="createPz") 登録
</template>

<script>
import axios from '~/plugins/axios'
import Map from '~/components/MapArea.vue'

export default {
  components: {
    Map
  },
  data () {
    return {
      // pzモデルのカラム名
      name: '',
      type: 0,
      radius: 0,
      altitude: 0
    }
  },
  notifications: {
    toast: {
      type: 'success',
      message: 'test message'
    }
  },
  methods: {
    createPz () {
      const self = this
      axios.post('/pzs', { name: this.name, type: this.type }).then((res) => {
        self.$router.push('/pzs')
        self.toast({
          type: 'success',
          message: '登録が完了しました',
          timeout: 2000
        })
      })
    },
    backAreaIndex () {
      this.$router.push('/pzs')
    }
  }
}
</script>

<style>
.pull-right {
  float: right;
}
</style>
