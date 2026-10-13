<template>
  <main>
    <h1>Health Check</h1>
    <p>Check the health of the admin backend.</p>

    <button @click="checkHealth">Check Health</button>

    <p v-if="status">{{ status }}</p>
  </main>
</template>

<script setup>
import { ref } from 'vue'

const status = ref('')

function checkHealth() {
  status.value = 'Health check not implemented yet.'
}
</script>
