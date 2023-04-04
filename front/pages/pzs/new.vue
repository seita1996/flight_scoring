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
  //- Map
  v-btn(@click="backAreaIndex") 戻る
  v-btn.pull-right(color="primary" @click="createPz") 登録
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
  data () {
    return {
      id: this.$route.params.id,
      // pzモデルのカラム名
      name: '',
      type: 0,
      longitude: 0,
      latitude: 0,
      radius: 0,
      altitude: 0,
      pz_types: [
        { text: 'レッドPZ(円柱型)', value: 1 },
        { text: 'イエローPZ', value: 2 }
      ]
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

      // エクスポーターの作成
      // const exporter = new GLTFExporter()

      // const datetime = this.datetime().toString()

      // .gltfファイルにエクスポートする
      // exporter.parse(cylinder, function (gltf) {
      //   // download file
      //   const link = document.createElement('a')
      //   link.href = URL.createObjectURL(new Blob([JSON.stringify(gltf)], { type: 'json' }))
      //   link.download = 'cylinder_' + datetime + '.gltf'
      //   link.click()
      // })

      // XMLHttpRequestを使ってサーバーに送信する
      const xhr = new XMLHttpRequest()
      xhr.open('POST', 'http://localhost:3000/pzs/create_pz_file')
      xhr.setRequestHeader('Content-Type', 'application/json')
      xhr.onload = function () {
        if (xhr.status === 200) {
          console.log(xhr.response)
        } else {
          console.log('Request failed.  Returned status of ' + xhr.status)
        }
      }
      // // エクスポーターの作成
      const exporter = new GLTFExporter()
      exporter.parse(cylinder, function (gltf) {
        // const formData = new FormData()
        const blob = new Blob([JSON.stringify(gltf)], { type: 'application/json' })
        const reader = new FileReader()
        reader.readAsArrayBuffer(blob)
        reader.onload = function (e) {
          // formData.append('file', e.target.result)
          // formData.append('pz_id', 1)
          xhr.send(e.target.result)
        }
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
