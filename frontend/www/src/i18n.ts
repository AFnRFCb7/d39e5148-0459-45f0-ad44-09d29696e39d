
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
    console.log("start initialize i18n");
    const en = await fetch('/api/data/i18n/en-US').then(response => response.json());
    console.log("fetched english");
    const zh = await fetch('/api/data/i18n/zh-CN').then(response => response.json());
    console.log("fetched chinese");
    i18n.global.setLocaleMessage('en-US', en);
    i18n.global.setLocaleMessage('zh-CN', zh);
    console.log("finished initialize i18n");
}

export default i18n
