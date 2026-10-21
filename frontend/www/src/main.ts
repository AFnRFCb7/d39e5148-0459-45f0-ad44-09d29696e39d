import App from './App.vue'
import { createApp } from 'vue'
import { useI18n } from 'vue-i18n'
import router from './router'

createApp(App)
  .use(router)
  .use(i18n)
  .mount('#app')