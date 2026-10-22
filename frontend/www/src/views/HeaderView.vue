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
        <div ref="googleButton"></div>
      <button class="sign-in">Sign In</button>'
    </header>
  <h1> FIND ME </h1>
  <header>
    <h1>{{ t('subject.visa') }}</h1>
    <h1>{{ t('control.log in') }}</h1>
    <select v-model="locale" aria-label="Language">
      <option value="en-US">🇺🇸</option>
      <option value="zh-CN">🇨🇳</option>
    </select>
  </header>
</template>
