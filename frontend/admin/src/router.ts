import { createRouter, createWebHistory } from 'vue-router'
import SecretView from './views/SecretView.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', redirect: '/secret' },
    { path: '/secret', component: SecretView },
  ],
})

export default router