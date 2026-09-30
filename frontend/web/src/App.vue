<script setup lang="ts">
const applications = [
  { name: 'Application 1', status: 'Draft' },
  { name: 'Application 2', status: 'Ready' },
]
</script>

<template>
  <main>
    <h1>Visa</h1>
    <p>Welcome to Visa</p>

    <section>
      <h2>Applications</h2>

      <ul>
        <li v-for="application in applications" :key="application.name">
          <strong>{{ application.name }}</strong>
          — {{ application.status }}
        </li>
      </ul>

      <button>New Application</button>
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

li {
  margin: 12px 0;
}

button {
  margin-top: 15px;
  padding: 8px 16px;
  cursor: pointer;
}
</style>