<script setup>
import { useI18n } from 'vue-i18n'
const { t, locale } = useI18n()
</script>
<template>
    <h1>{{ t('header') }}</h1>
    <H1>Footer</H1>
</template>