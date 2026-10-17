import { createRouter, createWebHistory } from 'vue-router'
import HealthCheck from './views/HealthCheckView.vue'
import HomePage from './views/HomePageView.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', component: HomePage },
    { path: '/health-check', component: HealthCheck },
  ],
})

export default router