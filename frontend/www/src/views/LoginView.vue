<template>
  <main class="login-page">
    <section class="login-card">
      <h1>{{ t('auth.login') }}</h1>

      <form @submit.prevent="login">
        <label for="email">{{ t('auth.email') }}</label>
        <input
          id="email"
          v-model.trim="email"
          type="email"
          autocomplete="email"
          required
        />

        <label for="password">{{ t('auth.password') }}</label>
        <input
          id="password"
          v-model="password"
          type="password"
          autocomplete="current-password"
          required
        />

        <p v-if="error" class="error" role="alert">
          {{ error }}
        </p>

        <button type="submit" :disabled="loading">
          {{ loading ? t('auth.signingIn') : t('auth.login') }}
        </button>
      </form>

      <div class="separator">{{ t('auth.or') }}</div>

      <button
        type="button"
        class="google-button"
        @click="loginWithGoogle"
      >
        {{ t('auth.continueWithGoogle') }}
      </button>

      <RouterLink class="back-link" to="/">
        {{ t('common.backHome') }}
      </RouterLink>
    </section>
  </main>
</template>

<script setup>
import { ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'

const { t } = useI18n()
const router = useRouter()

const email = ref('')
const password = ref('')
const loading = ref(false)
const error = ref('')

async function login() {
  loading.value = true
  error.value = ''

  try {
    const response = await fetch('/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      credentials: 'include',
      body: JSON.stringify({
        email: email.value,
        password: password.value,
      }),
    })

    if (!response.ok) {
      throw new Error('loginFailed')
    }

    await router.push('/')
  } catch {
    error.value = t('auth.loginFailed')
  } finally {
    loading.value = false
  }
}

function loginWithGoogle() {
  window.location.assign('/api/auth/google')
}
</script>

<style scoped>
.login-page {
  min-height: 70vh;
  display: grid;
  place-items: center;
  padding: 2rem 1rem;
}

.login-card {
  width: 100%;
  max-width: 400px;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

h1 {
  margin: 0 0 0.5rem;
}

form {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

input {
  box-sizing: border-box;
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ccc;
  border-radius: 6px;
  font: inherit;
}

button {
  padding: 0.8rem 1rem;
  border: 0;
  border-radius: 6px;
  cursor: pointer;
  font: inherit;
}

button[type='submit'] {
  color: white;
  background: #2457a7;
}

button:disabled {
  opacity: 0.6;
  cursor: wait;
}

.google-button {
  background: white;
  border: 1px solid #ccc;
}

.separator {
  text-align: center;
  color: #777;
}

.error {
  color: #b42318;
}

.back-link {
  text-align: center;
}
</style>
