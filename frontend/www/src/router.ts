import { createRouter, createWebHistory } from 'vue-router'
import Admin from './views/AdminView.vue'
import GetStarted from './views/GetStartedView.vue'
import HomePage from './views/HomePageView.vue'
import Login from './views/LoginView.vue'
import User from './views/UserView.vue';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/admin' , component: Admin },
    { path: '/get-started' , component : GetStarted } ,
    { path: '/', component: HomePage },
    { path: '/login' , component: Login},
    { path: '/user', component : User}
  ],
})

export default router