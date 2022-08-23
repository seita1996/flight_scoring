<template lang="pug">
v-row
  v-col(cols="12" sm="6" md="4")
    v-menu(ref="menu" v-model="menu" :close-on-content-click="false" :return-value.sync="dates" transition="scale-transition" offset-y min-width="auto")
      template(v-slot:activator="{ on, attrs }")
        v-text-field(v-model="dates" label="期間" prepend-icon="mdi-calendar" readonly v-bind="attrs" v-on="on")
      v-date-picker(v-model="dates" range no-title scrollable)
        v-spacer
        v-btn(text color="primary" @click="menu = false") Cancel
        v-btn(text color="primary" @click="$refs.menu.save(dates)") OK
</template>

<script>
export default {
  data: () => ({
    dates: [],
    menu: false,
    modal: false,
    menu2: false
  }),
  computed: {
    dateRangeText () {
      return this.dates.join(' ~ ')
    }
  }
}
</script>
