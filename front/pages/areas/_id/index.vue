<template lang="pug">
v-container
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-btn.pull-right(color="primary" @click="movePzNew") PZ登録
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="エリア名" v-model="name" prepend-icon="" type="text")
  v-data-table(:headers="fields" :items="pzs" class="elevation-1 pointer" @click:row="movePzEdit")
    template(v-slot:item.action="{ item }")
      v-btn(outlined color="red" @click.stop="clickDelete(item)") 削除
  Map(:pzs="pzs" v-if="dataPrepared")
  v-btn(@click="moveArea") 戻る
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
      name: '',
      id: this.$route.params.id,
      dataPrepared: false,
      pzs: [],
      fields: [
        { text: 'PZ名', value: 'name' },
        { text: '種類', value: 'pz_type' },
        { text: '緯度', value: 'longitude' },
        { text: '経度', value: 'latitude' },
        { text: '半径（m）', value: 'radius' },
        { text: '高度（m）', value: 'altitude' },
        { text: '操作', value: 'action' }
      ]
    }
  },
  created () {
    axios.get('/areas/' + this.id).then((res) => {
      console.log('res.data')
      console.log(res.data)
      if (res.data) {
        this.name = res.data.name
        this.pzs = res.data.pzs
        this.dataPrepared = true
      }
    })
  },
  methods: {
    moveArea () {
      this.$router.push('/areas')
    },
    movePzNew () {
      const areaId = this.id
      this.$router.push({ name: 'pzs-new', params: { areaId } })
    },
    movePzEdit (row) {
      const areaId = this.id
      this.$router.push({ name: 'pzs-id', params: { id: row.id, areaId } })
    },
    clickDelete (item) {
      const self = this
      axios.delete('/pzs/' + item.id).then(() => {
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
.pointer {
  cursor: pointer;
}
</style>
