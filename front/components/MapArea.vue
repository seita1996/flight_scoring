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
        center: { lat: 35.6609, lng: 139.685 },
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
      let posArray
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

        // オブジェクト位置
        const latLng1 = new google.maps.LatLng(35.6609, 139.685)
        const latLng2 = new google.maps.LatLng(35.6736, 139.756)

        // オブジェクト位置からカメラ位置への距離と方位角を計算する
        const distance1 = google.maps.geometry.spherical.computeDistanceBetween(latLng1, latLng1)
        const heading1 = google.maps.geometry.spherical.computeHeading(latLng1, latLng1)
        const distance2 = google.maps.geometry.spherical.computeDistanceBetween(latLng1, latLng2)
        const heading2 = google.maps.geometry.spherical.computeHeading(latLng1, latLng2)

        // オブジェクト位置をthree.jsの座標系に変換する
        const position1 = getPositionFromDistanceAndAzimuth(latLng1, distance1, heading1)
        const position2 = getPositionFromDistanceAndAzimuth(latLng2, distance2, heading2)
        posArray = [position1, position2]
      })
      return [self.map, posArray]
    }

    function initWebGLOverlayView (map, pzs, posArray) {
      let scene, renderer, camera, loader
      const webGLOverlayView = new self.google.maps.WebGLOverlayView()
      console.log('pzs')
      console.log(pzs)
      // console.log('posArray')
      // console.log(posArray)

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
        pzs.forEach(function (pz, i) {
          console.log('posArray[i].x')
          console.log(posArray[i].x)
          console.log('posArray[i].y')
          console.log(posArray[i].y)
          console.log('posArray[i].z')
          console.log(posArray[i].z)
          const source = pz.url
          if (source !== null) {
            // const position = new THREE.Vector3(pz.id * 300, 0, 0).add(camera.position)
            loader.load(
              source,
              (gltf) => {
                // 円柱オブジェクトが垂直に立つよう変換
                gltf.scene.rotation.x = Math.PI / 2
                // すでに作成したpositions[0].xなどから取得する
                gltf.scene.position.set(posArray[i].x, posArray[i].y, posArray[i].z)

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

    // function setObjectPosition (camera) {
    //   // const positions = [
    //   //   pos1: {
    //   //     lat: 35.6609,
    //   //     lon: 139.685
    //   //   },
    //   //   pos2: {
    //   //     lat: 35.6736,
    //   //     lon: 139.756
    //   //   },
    //   //   pos3: {
    //   //     lat: 35.6769,
    //   //     lon: 139.752
    //   //   }
    //   // ]
    //   // pzsの緯度経度を取得
    //   const lat1 = 35.6609
    //   const lon1 = 139.685
    //   const lat2 = 35.6736
    //   const lon2 = 139.756
    //   // const lat3 = 35.6769
    //   // const lon3 = 139.752
    //   const startPosition = {
    //     lat: lat1,
    //     lon: lon1
    //   }

    //   // 緯度経度から直線距離と方位角を計算
    //   console.log('setObjectPosition')
    //   const [distance, azimuth] = calcDistanceAndAzimuth(lat1, lon1, lat2, lon2)
    //   console.log('distance')
    //   console.log(distance)
    //   console.log('azimuth')
    //   console.log(azimuth)
    //   // カメラの位置を設定
    //   // const cameraPosition = getPositionFromDistanceAndAzimuth(startPosition, distance, azimuth)
    //   // console.log('cameraPosition')
    //   // console.log(cameraPosition)
    //   // camera.position.set(cameraPosition.x, cameraPosition.y, cameraPosition.z)

    //   // GLTFモデルの位置を設定
    //   const objPosition = getPositionFromDistanceAndAzimuth(startPosition, distance, azimuth)
    //   console.log('objPosition')
    //   console.log(objPosition)
    // }

    // function calcDistanceAndAzimuth (lat1, lon1, lat2, lon2) {
    //   // 緯度経度をラジアンに変換
    //   const radLat1 = lat1 * Math.PI / 180
    //   const radLon1 = lon1 * Math.PI / 180
    //   const radLat2 = lat2 * Math.PI / 180
    //   const radLon2 = lon2 * Math.PI / 180

    //   // 緯度差、経度差を計算
    //   const dLat = radLat2 - radLat1
    //   const dLon = radLon2 - radLon1

    //   // 2点間の距離を計算
    //   const R = 6371 // km
    //   const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    //             Math.cos(radLat1) * Math.cos(radLat2) *
    //             Math.sin(dLon / 2) * Math.sin(dLon / 2)
    //   const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    //   const distance = R * c * 1000 // m

    //   // 方位角を計算
    //   const y = Math.sin(dLon) * Math.cos(radLat2)
    //   const x = Math.cos(radLat1) * Math.sin(radLat2) -
    //             Math.sin(radLat1) * Math.cos(radLat2) * Math.cos(dLon)
    //   const azimuth = Math.atan2(y, x)

    //   return [distance, azimuth]
    // }

    // function getPositionFromDistanceAndAzimuth (startPosition, distance, azimuth) {
    //   const R = 6371 // km
    //   const lat1 = toRadians(startPosition.lat)
    //   const lon1 = toRadians(startPosition.lng)
    //   const distanceRadians = distance / R
    //   const bearingRadians = toRadians(azimuth)

    //   const lat2 = Math.asin(
    //     Math.sin(lat1) * Math.cos(distanceRadians) +
    //       Math.cos(lat1) * Math.sin(distanceRadians) * Math.cos(bearingRadians)
    //   )
    //   const lon2 =
    //     lon1 +
    //     Math.atan2(
    //       Math.sin(bearingRadians) * Math.sin(distanceRadians) * Math.cos(lat1),
    //       Math.cos(distanceRadians) - Math.sin(lat1) * Math.sin(lat2)
    //     )

    //   return {
    //     lat: toDegrees(lat2),
    //     lng: toDegrees(lon2)
    //   }
    // }
    // // 角度をラジアンに変換する関数
    // function toRadians (degrees) {
    //   return degrees * Math.PI / 180
    // }
    // // ラジアンを角度に変換する関数
    // function toDegrees (radians) {
    //   return radians * 180 / Math.PI
    // }

    function getPositionFromDistanceAndAzimuth (latLng, distance, heading) {
      // ラジアンを度に変換するための定数
      const DEG2RAD = Math.PI / 180
      const lat = latLng.lat() * DEG2RAD
      const lng = latLng.lng() * DEG2RAD
      const earthRadius = 6378137 // 地球の半径（単位:メートル）

      // 指定された距離と方位から、オブジェクトの位置を計算する
      const dx = distance * Math.sin(heading * DEG2RAD)
      const dz = distance * Math.cos(heading * DEG2RAD)
      const latOffset = (dx / earthRadius) * (180 / Math.PI)
      const lngOffset = (dz / earthRadius) * (180 / Math.PI) / Math.cos(lat)
      const lat2 = lat + latOffset * DEG2RAD
      const lng2 = lng + lngOffset * DEG2RAD
      const position = new THREE.Vector3(
        earthRadius * Math.cos(lat2) * Math.sin(lng2 - lng),
        earthRadius * Math.sin(lat2),
        earthRadius * Math.cos(lat2) * Math.cos(lng2 - lng)
      )
      return position
    }

    (async () => {
      const self = this
      const [map, posArray] = await initMap(self)
      console.log('map')
      console.log(map)
      console.log('posArray')
      console.log(posArray)
      // const camera = new THREE.PerspectiveCamera()
      // setObjectPosition(camera)
      initWebGLOverlayView(map, this.pzs, posArray)
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
