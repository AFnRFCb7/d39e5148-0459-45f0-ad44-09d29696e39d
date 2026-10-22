import { createRouter, createWebHistory } from 'vue-router'
import Admin from './views/AdminView.vue'
import HomePage from './views/HomePageView.vue'
import Login from './views/LoginView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/admin' , component: Admin },
    { path: '/', component: HomePage },
    { path: '/login' , component: Login}
  ],
})

export default router