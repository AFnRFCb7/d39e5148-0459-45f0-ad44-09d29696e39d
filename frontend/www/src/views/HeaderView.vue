<script setup>
import { useI18n } from 'vue-i18n'
const { t, locale } = useI18n()
</script>
<template>
  <header>
    <h1>{{ t('header') }}</h1>
    <select v-model="locale" aria-label="Language">
      <option value="en">English</option>
      <option value="zh-CN">简体中文</option>
    </select>
  </header>
</template>
