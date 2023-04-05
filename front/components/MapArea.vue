<template lang="pug">
div
  .box30
    .box-title 中心地の緯度経度
    p 緯度：{{ lat }}
    p 経度：{{ lng }}
  v-sheet(id="map" class="pa-0" :light="true" style="width: 100%; height: 500px;")
</template>

<script>
import { Loader } from '@googlemaps/js-api-loader'
import * as THREE from 'three'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js'

export default {
  name: 'GoogleMap',
  props: {
    pzs: {
      type: Array,
      default: () => []
    }
  },
  data: function () {
    return {
      map: null,
      google: null,
      lat: 0,
      lng: 0
    }
  },
  mounted: function () {
    const apiOptions = {
      apiKey: this.$config.mapsApiKey,
      version: 'frozen',
      libraries: ['places', 'drawing', 'geometry', 'visualization'],
      language: 'ja'
    }

    const mapOptions = (google) => {
      return {
        // 初期表示設定
        tilt: 60,
        heading: 0,
        zoom: 17,
        // INFO: 暫定で該当エリアの１個目のPZを画面中央の座標とする
        // TODO: 地図の中心としてエリアの全体が移る範囲を都度指定
        center: { lat: 35.6736, lng: 139.756 },
        // center: { lat: 35.6594945, lng: 139.6999859 },
        mapId: this.$config.mapsId,
        fullscreenControl: false,
        mapTypeControl: false,
        streetViewControl: true,
        streetViewControlOptions: {
          position: google.maps.ControlPosition.LEFT_BOTTOM
        },
        zoomControl: true,
        zoomControlOptions: {
          position: google.maps.ControlPosition.LEFT_BOTTOM
        },
        scaleControl: true
        // 3dビューを有効にする
        // mapTypeId: 'satellite'
      }
    }

    async function initMap (self) {
      console.log('initMap')
      const mapDiv = document.getElementById('map')
      const apiLoader = new Loader(apiOptions)
      await apiLoader.load().then((google) => {
        self.google = google
        // 地図の初期化
        self.map = new google.maps.Map(mapDiv, mapOptions(google))
        // 緯度経度を初期化
        self.lat = self.map.getCenter().lat()
        self.lng = self.map.getCenter().lng()

        // 常にマップの中心座標を画面表示
        self.map.addListener('center_changed', () => {
          self.lat = self.map.getCenter().lat()
          self.lng = self.map.getCenter().lng()
        })
      })
      return self.map
    }

    function initWebGLOverlayView (map, pzs) {
      let scene, renderer, camera, loader
      const webGLOverlayView = new self.google.maps.WebGLOverlayView()

      webGLOverlayView.onAdd = () => {
        console.log('onAdd')
        scene = new THREE.Scene()
        camera = new THREE.PerspectiveCamera()
        const ambientLight = new THREE.AmbientLight(0xFFFFFF, 0.75)
        scene.add(ambientLight)
        const directionalLight = new THREE.DirectionalLight(0xFFFFFF, 0.25)
        directionalLight.position.set(0.5, -1, 0.5)
        scene.add(directionalLight)

        loader = new GLTFLoader()
        // propsで渡される GLTFモデルを読み込み
        pzs.forEach(function (pz) {
          const source = pz.url
          if (source !== null) {
            const position = new THREE.Vector3(pz.id * 300, 0, 0).add(camera.position)
            loader.load(
              source,
              (gltf) => {
                // 円柱オブジェクトが垂直に立つよう変換
                gltf.scene.rotation.x = Math.PI / 2
                gltf.scene.position.set(position.x, position.y, position.z)

                scene.add(gltf.scene)
              }
            )
          }
        })
      }
      webGLOverlayView.onContextRestored = ({ gl }) => {
        console.log('onContextRestored')
        renderer = new THREE.WebGLRenderer({
          canvas: gl.canvas,
          context: gl,
          ...gl.getContextAttributes()
        })
        renderer.autoClear = false
      }
      webGLOverlayView.onDraw = ({ gl, transformer }) => {
        // 地図の中心座標とカメラの高度を指定
        const latLngAltitudeLiteral = {
          lat: mapOptions(self.google).center.lat,
          lng: mapOptions(self.google).center.lng,
          altitude: 100
        }
        // オブジェクトの相対位置を設定
        const matrix = transformer.fromLatLngAltitude(latLngAltitudeLiteral)
        camera.projectionMatrix = new THREE.Matrix4().fromArray(matrix)
        webGLOverlayView.requestRedraw()
        renderer.render(scene, camera)
        renderer.resetState()
      }
      webGLOverlayView.setMap(map)
    }

    (async () => {
      const self = this
      const map = await initMap(self)
      initWebGLOverlayView(map, this.pzs)
    })()
  },
  methods: {}
}
</script>

<style>
.box30 {
    margin: 2em 0;
    background: #f1f1f1;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.22);
}
.box30 .box-title {
    font-size: 1.2em;
    background: #5fc2f5;
    padding: 4px;
    text-align: center;
    color: #FFF;
    font-weight: bold;
    letter-spacing: 0.05em;
}
.box30 p {
    padding: 15px 20px;
    margin: 0;
}
</style>
