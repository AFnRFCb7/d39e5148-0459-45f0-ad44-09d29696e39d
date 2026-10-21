import { createI18n } from 'vue-i18n'
const i18n = createI18n({
    legacy: false,
    locale: 'en',
    fallbackLocale: 'en',
    messages: {
        en: {},
        'zh-CN': {}
    }
})
export async function initializeI18n() {
    const en = await fetch('/api/data/i18n/en.js').then(response => response.json())
    const zh = await fetch('/api/data/i18n/zh.js').then(response => response.json())
    i18n.global.setLocaleMessage('en-US', en)
    i18n.global.setLocaleMessage('zh-CN', zh)
}
export default i18n