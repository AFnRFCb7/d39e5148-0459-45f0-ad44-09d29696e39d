import { createRouter, createWebHistory } from 'vue-router'
import HealthCheck from './views/HealthCheckView.vue'
import HomePage from './views/HomePageView.vue'
import Login from './views/LoginView.vue'
import Utility from './views/UtilityView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', component: HomePage },
    { path: '/health-check', component: HealthCheck },
    { path: '/login' , component: Login}
    { path: '/utility' , component: Utility }
  ],
})

export default router