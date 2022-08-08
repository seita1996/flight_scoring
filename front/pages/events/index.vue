<template>
  <v-container>
    <v-row align="center" justify="center">
      <v-col cols="12">
        <v-text-field
        label="大会名"
        v-model="name"
        prepend-icon=""
        type="text"
        />
        <v-btn color="primary" @click="createEvent">大会登録</v-btn>
      </v-col>
      <v-col cols="12">
          <h1>大会一覧</h1>
      </v-col>
    </v-row>

    <v-card
      class="mx-auto"
      max-width="300"
      tile
    >
      <v-list rounded>
        <v-subheader>EVENTS</v-subheader>
        <v-list-item-group color="primary">
          <v-list-item
            v-for="event in events"
            :key="event.id"
            @click=""
          >
            <v-list-item-content>
              <v-list-item-title v-text="event.name"></v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-item-group>
      </v-list>
    </v-card>
  </v-container>
</template>

<script>
import axios from "~/plugins/axios"

export default {
  data() {
    return {
      name: "",
      events: []
    }
  },
  created() {
    // ユーザーをaxiosで取得
    axios.get("/events").then(res => {
      if (res.data) {
        console.log('res.data')
        console.log(res.data)
        this.events = res.data
      }
    })
  },
  methods: {
    // ユーザーをaxiosで登録
    createEvent () {
      axios.post("/events", {name: this.name, director: 'Deff'})
    .then(res => {
      if (res.data) {
        console.log('res.data')
        console.log(res.data)
        this.events.push(res.data)
      }
    })
    }
  }
}
</script>