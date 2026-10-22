<script setup>
import { onMounted , ref } from 'vue'

const providers = ref([])
const loading = ref(true)
const error = ref('')
const selectedProvider = ref(null)
const values = ref({})
const submitting = ref(false)

async function loadProviders() {
  console.log('loadProviders started');
  loading.value = true;
  error.value = '';

  try {
    const response = await fetch('/api/auth/providers');
    console.log('providers status:', response.status);

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const data = await response.json();
    console.log('providers data:', data);

    providers.value = data.filter(p => p.enabled);
  } catch (err) {
    console.error('Failed to load providers:', err);
    error.value = err.message;
  } finally {
    loading.value = false;
    console.log('loading finished');
  }
}

function selectProvider(provider) {
  selectedProvider.value = provider
  values.value = Object.fromEntries(
    Object.keys(provider.config?.fields ?? {}).map(name => [name, '']),
  )
  error.value = ''
}

async function submitCredentials() {
  const provider = selectedProvider.value
  if (!provider || submitting.value) return

  submitting.value = true
  error.value = ''

  try {
    const response = await fetch(provider.config.url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      credentials: 'same-origin',
      body: JSON.stringify(values.value),
    })

    if (!response.ok) {
      const result = await response.json().catch(() => ({}))
      throw new Error(result.message || 'Login failed.')
    }

    // Assumes successful login establishes a session on the server.
    // Navigate to the desired post-login page.
    window.location.assign('/www/')
  } catch (err) {
    error.value = err.message || 'Login failed.'
  } finally {
    submitting.value = false
  }
}

function activateProvider(provider) {
  if (provider.type === 'credentials') {
    selectProvider(provider)
  } else {
    error.value = `Unsupported authentication type: ${provider.type}`
  }
}

onMounted(loadProviders);

</script>

<template>
  <main class="login">
    <h1>Log in</h1>

    <p v-if="loading">Loading login options…</p>

    <template v-else>
      <p v-if="error" class="error" role="alert">{{ error }}</p>

      <div v-if="!selectedProvider" class="providers">
        <p v-if="providers.length === 0">
          No login methods are currently available.
        </p>

        <button
          v-for="provider in providers"
          :key="provider.id"
          type="button"
          @click="activateProvider(provider)"
        >
          {{ provider.label }}
        </button>
      </div>

      <form v-else @submit.prevent="submitCredentials">
        <h2>{{ selectedProvider.label }}</h2>

        <div
          v-for="(field, name) in selectedProvider.config.fields"
          :key="name"
          class="field"
        >
          <label :for="`login-${name}`">{{ name }}</label>

          <input
            :id="`login-${name}`"
            v-model="values[name]"
            :name="name"
            :type="field.type"
            :required="field.required"
            :autocomplete="
              name === 'email'
                ? 'username'
                : name === 'password'
                  ? 'current-password'
                  : undefined
            "
          />
        </div>

        <button
          v-if="selectedProvider.config.submit"
          type="submit"
          :disabled="submitting"
        >
          {{
            typeof selectedProvider.config.submit === 'string'
              ? selectedProvider.config.submit
              : 'Log in'
          }}
        </button>

        <button
          type="button"
          class="back"
          :disabled="submitting"
          @click="selectedProvider = null; error = ''"
        >
          Back
        </button>
      </form>
    </template>
  </main>
</template>

<style scoped>
.login {
  width: min(100% - 2rem, 24rem);
  margin: 3rem auto;
}

.providers,
.field {
  display: grid;
  gap: 0.75rem;
}

form {
  display: grid;
  gap: 1rem;
}

.field label {
  font-weight: 600;
}

.field input {
  box-sizing: border-box;
  width: 100%;
  padding: 0.65rem;
}

button {
  padding: 0.7rem 1rem;
  cursor: pointer;
}

button:disabled {
  cursor: wait;
  opacity: 0.6;
}

.error {
  color: #b42318;
}

.back {
  background: transparent;
}
</style>