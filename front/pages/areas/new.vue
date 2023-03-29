<template lang="pug">
v-container
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="エリア名" v-model="name" prepend-icon="" type="text")
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-file-input(label="ファイルを選択" v-on:change="onFileChange($event)")
      //- 選択された地図ファイルをMap.vueコンポーネントに渡す
      v-card(v-if="fileName")
        v-card-text {{ fileName }}
  Map
  v-btn(@click="moveArea") 戻る
  v-btn.pull-right(color="primary" @click="createArea") エリア登録
</template>

<script>
import axios from '~/plugins/axios'
// Map.vueコンポーネントをインポート
import Map from '~/components/MapArea.vue'
// import Map from '~/components/map.js'

export default {
  components: {
    Map
  },
  data () {
    return {
      name: '',
      url: '',
      fileName: null
    }
  },
  notifications: {
    toast: {
      type: 'success',
      message: 'test message'
    }
  },
  methods: {
    createArea () {
      const self = this
      axios.post('/areas', { name: this.name, url: this.url }).then((res) => {
        self.$router.push('/areas')
        self.toast({
          type: 'success',
          message: '登録が完了しました',
          timeout: 2000
        })
      })
    },
    moveArea () {
      this.$router.push('/areas')
    },
    onFileChange (event) {
      console.log('event')
      console.log(event)
      const file = event.target.files[0]
      this.fileName = file.name
    }
  }
}
</script>

<style>
.pull-right {
  float: right;
}
</style>
