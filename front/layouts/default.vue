<template lang="pug">
v-app(dark)
  v-navigation-drawer(v-model="drawer" :mini-variant="miniVariant" :clipped="clipped" fixed app)
    v-list
      v-list-item(v-for="(item, i) in items" :key="i" :to="item.to" router exact)
        v-list-item-action
          v-icon {{ item.icon }}
        v-list-item-content
          v-list-item-title(v-text="item.title")
  v-app-bar(:clipped-left="clipped" fixed app)
    v-app-bar-nav-icon(@click.stop="drawer = !drawer")
    v-toolbar-title(v-text="title")
    v-spacer
  v-main
    v-container
      nuxt
  v-footer(:fixed="fixed" app)
    span &copy; {{ new Date().getFullYear() }}
</template>

<script>
export default {
  data () {
    return {
      clipped: false,
      drawer: false,
      fixed: false,
      items: [
        {
          icon: 'mdi-apps',
          title: '大会一覧',
          to: '/events'
        },
        {
          icon: 'mdi-chart-bubble',
          title: '設定',
          to: '/task_types'
        },
        {
          icon: 'mdi-google-maps',
          title: 'エリア管理',
          to: '/areas'
        }
      ],
      miniVariant: false,
      right: true,
      rightDrawer: false,
      title: 'Flight Scoring System'
    }
  }
}
</script>
