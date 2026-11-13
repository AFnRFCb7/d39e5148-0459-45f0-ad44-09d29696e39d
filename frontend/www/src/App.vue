<script setup>
import Header from './views/HeaderView.vue'
import Footer from './views/FooterView.vue'
</script>
<template>
  <Header />
  <router-view />
  <Footer />
</template>
<style>
@font-face {
  font-family: "Noto Sans SC";
  src: url("/api/data/fonts/noto-sans-sc-test.woff2") format("woff2");
  font-style: normal;
  font-weight: 100 900;
  font-display: swap;
}
body {
  font-family: "Noto Sans SC", sans-serif;
}
.header button {
    font-size: 16px;
}
</style>