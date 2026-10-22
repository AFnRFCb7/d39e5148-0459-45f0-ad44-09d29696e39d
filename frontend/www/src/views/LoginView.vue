<script setup>
import { ref, onMounted } from 'vue'

const providers = ref([])
const loadingProviders = ref(true)
const providerError = ref('')

onMounted(async () => {
  try {
    const response = await fetch('/api/auth/providers')

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`)
    }

    providers.value = await response.json()
  } catch (error) {
    providerError.value = 'Unable to load login options.'
    console.error(error)
  } finally {
    loadingProviders.value = false
  }
})
</script>

<template>
  <div v-if="loadingProviders">
    Loading login options…
  </div>

  <p v-else-if="providerError">
    {{ providerError }}
  </p>

  <div v-else>
    <div
      v-for="provider in providers.filter(p => p.enabled)"
      :key="provider.id"
    >
      <button v-if="provider.id === 'password'">
        {{ provider.label }}
      </button>

      <button v-else-if="provider.id === 'google'">
        Continue with Google
      </button>
    </div>
  </div>
</template>