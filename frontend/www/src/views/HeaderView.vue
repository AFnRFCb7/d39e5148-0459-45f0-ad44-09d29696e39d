<script setup>
import { useI18n } from 'vue-i18n'
const { t, locale } = useI18n()
</script>
<template>
    <header class="header">
        <div class="logo">{{ t('subject.Visa') }}</div>
        <nav>
            <a href="#">{{ t('subject.Study') }}</a>
            <a href="#">{{ t('subject.Travel') }}</a>
            <a href="#">{{ t('subject.Move') }}</a>
        </nav>
        <select v-model="locale" aria-label="Language">
            <option value="en-US">🇺🇸</option>
            <option value="zh-CN">🇨🇳</option>
        </select>
    </header>
</template>
<style scoped>
header.select.option {
    font-size: x-large ;
}
.header {
  height: 76px;
  padding: 0 6%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: white;
  border-bottom: 1px solid #e8e6e1;
}
.logo {
  font-size: 16px;
  font-weight: 750;
  letter-spacing: -1px;
}
nav {
  display: flex;
  gap: 36px;
}
nav a {
  color: #596273;
  text-decoration: none;
  font-size: 15px;
}
nav a:hover {
  color: #172033;
}
.sign-in {
  padding: 9px 18px;
  border: 1px solid #d5d8de;
  border-radius: 7px;
  background: white;
  color: #172033;
  font-weight: 600;
  cursor: pointer;
}
</style>
