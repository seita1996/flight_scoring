<template lang="pug">
v-sheet(id="map" class="pa-0" :light="true" style="width: 100%; height: 300px;")
  googlemap
</template>

<script>
import { Loader } from '@googlemaps/js-api-loader'

export default {
  name: 'HelloWorld',
  data: function () {
    return {
      map: null,
      google: null
    }
  },
  mounted: function () {
    new Loader({
      apiKey: 'AIzaSyCujDc6RifTihhYhIYJ6aGgyBFb42bNNIo',
      version: 'frozen',
      libraries: ['places', 'drawing', 'geometry', 'visualization'],
      language: 'ja'
    }).load().then((google) => {
      this.google = google
      // 地図の初期化
      this.map = new google.maps.Map(document.getElementById('map'), {
        // 初期表示設定
        zoom: 17,
        center: { lat: 35.692195, lng: 139.759854 },
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
      })
      // こちらにレスポンスとして受け取ったgoogleやthis.mapを使用すれば、
      // 通常通りvueでもJavaScriptAPIを利用できます
    }).catch((e) => {
      console.error(e)
    })
  }
}
</script>
<!-- <template lang="pug">
div(id="map")
</template>

<script>
import MapJs from './map'

export default {
  data () {
    return {
    }
  },
  mounted () {
    // 佐賀県佐賀市の緯度経度を指定
    // this.map = L.map(this.$refs.map).setView([35.681236, 139.767125], 13)

    // GoogleMapsJavascriptAPIの読み込み
    // const script = document.createElement('script')
    // script.src = 'https://maps.googleapis.com/maps/api/js?key=AIzaSyCujDc6RifTihhYhIYJ6aGgyBFb42bNNIo'
    // script.defer = true
    // script.async = true
  },
  methods: {
    initMap () {
      // マップを表示する要素を取得
      const mapElement = document.getElementById('map')

      // 地図の初期位置を設定
      const initialPosition = { lat: 35.681236, lng: 139.767125 }

      // 地図を生成
      const map = new google.maps.Map(mapElement, {
        center: initialPosition,
        zoom: 15,
      })
    }

  }
}
</script>

<style scoped>
</style> -->
