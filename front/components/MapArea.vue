<template lang="pug">
v-sheet(id="map" class="pa-0" :light="true" style="width: 100%; height: 500px;")
</template>

<script>
import { Loader } from '@googlemaps/js-api-loader'

export default {
  name: 'GoogleMap',
  data: function () {
    return {
      map: null,
      google: null
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
      // こちらにレスポンスとして受け取ったgoogleやthis.mapを使用すれば、
      // 通常通りvueでもJavaScriptAPIを利用できます
    }).catch((e) => {
      console.error(e)
    })
  }
}
</script>
