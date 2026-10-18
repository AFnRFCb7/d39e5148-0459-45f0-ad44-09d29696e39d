import { createRouter, createWebHistory } from 'vue-router'
import HealthCheck from './views/HealthCheckView.vue'
import HomePage from './views/HomePageView.vue'
import LoginPage from './views/LoginView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', component: HomePage },
    { path: '/health-check', component: HealthCheck },
    { path: '/login', component: LoginPage }
  ],
})

export default router