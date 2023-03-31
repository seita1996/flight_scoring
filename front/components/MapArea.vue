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

export default {
  name: 'GoogleMap',
  data: function () {
    return {
      map: null,
      google: null,
      lat: 0,
      lng: 0
    }
  },
  mounted: function () {
    new Loader({
      apiKey: this.$config.mapsApiKey,
      version: 'frozen',
      libraries: ['places', 'drawing', 'geometry', 'visualization'],
      language: 'ja'
    }).load().then((google) => {
      this.google = google
      // 地図の初期化
      this.map = new google.maps.Map(document.getElementById('map'), {
        // 初期表示設定
        tilt: 0,
        heading: 0,
        zoom: 18,
        // 緯度: 33.244391、経度: 130.298796
        center: { lat: 33.244391, lng: 130.298796 },
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
        scaleControl: true,
        // 3dビューを有効にする
        mapTypeId: 'satellite'
      })
      // 緯度経度を初期化
      this.lat = this.map.getCenter().lat()
      this.lng = this.map.getCenter().lng()

      // 常にマップの中心を画面表示
      this.map.addListener('center_changed', () => {
        this.lat = this.map.getCenter().lat()
        this.lng = this.map.getCenter().lng()
      })
    }).catch((e) => {
      console.error(e)
    })
  }
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
