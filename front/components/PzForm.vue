<template lang="pug">
v-container
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="PZ名" v-model="name" prepend-icon="" type="text")
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="座標(x軸)" v-model="longitude" prepend-icon="" type="text")
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="座標(y軸)" v-model="latitude" prepend-icon="" type="text")
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-select(:items="pz_types" v-model="type" label="PZタイプ")
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="半径(m)" v-model="radius" prepend-icon="" type="text")
  v-row(align="center" justify="center")
    v-col(cols="12")
      v-text-field(label="高度(m)" v-model="altitude" prepend-icon="" type="text")
  Map
  v-btn(@click="backAreaIndex") 戻る
  v-btn.pull-right(color="primary" @click="createPz") {{ button_name }}
</template>

<script>
import * as THREE from 'three'
import { GLTFExporter } from 'three/examples/jsm/exporters/GLTFExporter.js'
import axios from '~/plugins/axios'
import Map from '~/components/MapArea.vue'

export default {
  components: {
    Map
  },
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
      id: this.$route.params.id,
      name: '',
      type: 0,
      longitude: 0,
      latitude: 0,
      radius: 0,
      altitude: 0,
      pz_types: [
        { text: 'レッドPZ(円柱型)', value: 1 },
        { text: 'イエローPZ', value: 2 }
      ],
      button_name: ''
    }
  },
  notifications: {
    toast: {
      type: 'success',
      message: 'test message'
    }
  },
  mounted () {
    if (this.formType === 'new') {
      this.button_name = '登録'
    } else if (this.formType === 'edit') {
      this.button_name = '更新'
      // axios.get('/task_types/' + this.taskTypeId).then((res) => {
      //   if (res.data) {
      //     this.name = res.data.name
      //     this.short_name = res.data.short_name
      //     this.description = res.data.description
      //   }
      // })
    }
  },
  methods: {
    clickButton () {
      if (this.formType === 'new') {
        this.createPz()
      } else if (this.formType === 'edit') {
        this.updatePz(this.taskTypeId)
      }
    },
    createPz () {
      const self = this
      // 3Dオブジェクトを生成する
      axios.post('/pzs', { area_id: 1, name: this.name, pz_type: this.pz_type, longitude: this.longitude, latitude: this.latitude, radius: this.radius, altitude: this.altitude })
      this.exportCylinder()
      self.$router.push('/areas')
      self.toast({
        type: 'success',
        message: '登録が完了しました',
        timeout: 2000
      })
    },
    // 円柱状3Dオブジェクト(.gltf)を生成し、サーバーに送信した上で/static配下に保存する
    exportCylinder () {
      // 円柱状3Dオブジェクトの生成
      const geometry = new THREE.CylinderGeometry(this.radius, this.radius, this.altitude, 32)
      const material = new THREE.MeshBasicMaterial({
        color: 0xFF0000,
        transparent: true,
        opacity: 0.4
      })
      const cylinder = new THREE.Mesh(geometry, material)

      // 3DオブジェクトをGLTF形式でエクスポートしてサーバーに送信する
      const exporter = new GLTFExporter()
      const filename = `pz_${this.id}_${this.datetime()}.gltf`
      exporter.parse(cylinder, function (gltf) {
        const blob = new Blob([JSON.stringify(gltf)], { type: 'model/gltf+json' })
        const formData = new FormData()
        formData.append('file', blob, filename)
        axios.post('http://localhost:3000/pzs/create_pz_file', formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        }).then((response) => {
          console.log(response)
        }).catch((error) => {
          console.log(error)
        })
      })
    },
    datetime () {
      const now = new Date()
      const year = now.getFullYear()
      const month = ('0' + (now.getMonth() + 1)).slice(-2)
      const date = ('0' + now.getDate()).slice(-2)
      const hours = ('0' + now.getHours()).slice(-2)
      const minutes = ('0' + now.getMinutes()).slice(-2)
      const seconds = ('0' + now.getSeconds()).slice(-2)

      return `${year}${month}${date}${hours}${minutes}${seconds}`
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
