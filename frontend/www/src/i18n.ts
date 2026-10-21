
import { createI18n } from 'vue-i18n'

const i18n = createI18n({
    legacy: false,
    locale: 'en-US',
    fallbackLocale: 'en-US',
    messages: {
        'en-US': {},
        'zh-CN': {}
    }
})

export async function initializeI18n() {
    const en = await fetch('/api/data/i18n/en-US')
        .then(response => response.json())

    const zh = await fetch('/api/data/i18n/zh-CN')
        .then(response => response.json())

    i18n.global.setLocaleMessage('en-US', en)
    i18n.global.setLocaleMessage('zh-CN', zh)
}

export default i18n
