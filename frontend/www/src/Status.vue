<script setup lang="ts">
import { ref } from 'vue'

const status = ref('Ready')

function testConnection() {
  status.value = 'Connection tested'
}
</script>

<template>
  <main>
    <h1>Visa</h1>
    <p>Application dashboard</p>

    <section>
      <h2>Frontend</h2>
      <p>Development mode</p>
      <p>Hot reload enabled</p>
    </section>

    <section>
      <h2>System Status</h2>
      <p>Frontend: <strong>Running</strong></p>
      <p>Backend: <strong>Not connected</strong></p>
      <p>Data: <strong>Not connected</strong></p>
    </section>

    <section>
      <h2>Connection</h2>
      <p>{{ status }}</p>
      <button @click="testConnection">Test Connection</button>
    </section>
  </main>
</template>

<style scoped>
main {
  max-width: 800px;
  margin: 40px auto;
  padding: 20px;
  font-family: sans-serif;
}

section {
  margin-top: 30px;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 8px;
}

button {
  padding: 8px 16px;
  cursor: pointer;
}
</style>