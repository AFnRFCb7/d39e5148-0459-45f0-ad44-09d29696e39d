import App from './App.vue'
import { createApp } from 'vue'
import i18n, { initializeI18n } from './i18n'
import router from './router'

await initializeI18n()

createApp(App)
  .use(router)
  .use(i18n)
  .mount('#app')