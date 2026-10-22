<script setup>
import { useI18n } from 'vue-i18n'
const { t } = useI18n()
</script>
<template>
    <footer>
        <span>© {{ new Date().getFullYear() }} {{ t('common.business-name') }}</span>
        <nav>
            <a href="/contact">{{ t('common.contact') }}</a>
            <a href="/privacy">{{ t('common.privacy') }}</a>
        </nav>
    </footer>
</template>
<style scoped>
footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 1rem;
    padding: 1rem;
    border-top: 1px solid #ddd;
    color: #666;
    font-size: 0.9rem;
}
nav {
    display: flex;
    gap: 1.25rem;
}
a {
    color: inherit
    color: inherit;
    text-decoration: none;
}
a:hover {
    text-decoration: underline;
}
@media (max-width: 480px) {
    footer {
        flex-direction: column;
        text-align: center;
    }
}
</style>