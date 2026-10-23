<script setup>
import { ref, onMounted , watch } from 'vue'

watch(locale, async (newLocale) => {
    if (!loggedIn.value) {
        return;
    }

    const response = await fetch("/api/user/locale", {
        method: "PUT",
        credentials: "include",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ locale: newLocale })
    });

    if (!response.ok) {
        console.error("Failed to persist locale");
    }
});

const session = ref(null)

onMounted(async () => {
  const response = await fetch('/api/session', {
    credentials: 'include'
  })

  if (response.ok) {
    session.value = await response.json()
  }
})
import { useI18n } from 'vue-i18n'
const { t, locale } = useI18n()
</script>
<template>
    <header class="header">'
        <span v-if="session?.loggedIn">
          Logged in as {{ session.user.email }} {{ session.user.admin }}
        </span>
        <span v-else>
          Not logged in
        </span>
        <RouterLink v-if="$route.path !== '/'" to="/">{{ t('control.Home') }}</RouterLink>
        <RouterLink v-if="session?.loggedIn" to="/www/user">{{ t('control.User') }}</RouterLink>
        <RouterLink v-if="session?.loggedIn && session.user?.admin === true" to="/admin/">{{ t('control.Admin') }}</RouterLink>
        <div class="logo">{{ t('subject.Visa') }}</div>
        <nav>
            <a href="#">{{ t('subject.Study') }}</a>
            <a href="#">{{ t('subject.Travel') }}</a>
            <a href="#">{{ t('subject.Move') }}</a>
        </nav>
        <RouterLink to="/login">{{ t('control.Log In') }}</RouterLink>
        <select v-model="locale" aria-label="Language">
            <option value="en-US">🇺🇸</option>
            <option value="zh-CN">🇨🇳</option>
        </select>
    </header>
</template>
<style scoped>
header select {
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
  font-size: 16px;
}
nav a:hover {
  color: #172033;
}
</style>
