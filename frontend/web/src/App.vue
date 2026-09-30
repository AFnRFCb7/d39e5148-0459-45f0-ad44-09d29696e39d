<script setup lang="ts">
const applications = [
  { name: 'Application 1', status: 'Draft', updated: 'Today' },
  { name: 'Application 2', status: 'Ready', updated: 'Yesterday' },
]
</script>

<template>
  <div class="app">
    <header class="header">
      <div>
        <h1>Visa</h1>
        <p>Application Management</p>
      </div>

      <button class="primary">New Application</button>
    </header>

    <main>
      <section class="welcome">
        <h2>Welcome</h2>
        <p>Manage your applications and track their progress.</p>
      </section>

      <section>
        <div class="section-header">
          <h2>Your Applications</h2>
          <span>{{ applications.length }} applications</span>
        </div>

        <div class="cards">
          <article
            v-for="application in applications"
            :key="application.name"
            class="card"
          >
            <div class="card-top">
              <h3>{{ application.name }}</h3>
              <span
                class="status"
                :class="application.status.toLowerCase()"
              >
                {{ application.status }}
              </span>
            </div>

            <p>Last updated {{ application.updated }}</p>

            <button class="secondary">View Application</button>
          </article>
        </div>
      </section>
    </main>

    <footer>
      Visa Application Management
    </footer>
  </div>
</template>

<style scoped>
* {
  box-sizing: border-box;
}

.app {
  min-height: 100vh;
  background: #f5f7fa;
  color: #1f2937;
  font-family:
    Inter, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24px 48px;
  background: white;
  border-bottom: 1px solid #e5e7eb;
}

.header h1 {
  margin: 0;
  font-size: 28px;
}

.header p {
  margin: 4px 0 0;
  color: #6b7280;
}

main {
  max-width: 1100px;
  margin: 0 auto;
  padding: 48px 32px;
}

.welcome {
  margin-bottom: 48px;
}

.welcome h2 {
  margin-bottom: 8px;
  font-size: 32px;
}

.welcome p {
  margin: 0;
  color: #6b7280;
  font-size: 17px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.section-header h2 {
  margin: 0;
}

.section-header span {
  color: #6b7280;
  font-size: 14px;
}

.cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.card {
  padding: 24px;
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.04);
}

.card-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
}

.card h3 {
  margin: 0;
  font-size: 19px;
}

.card p {
  color: #6b7280;
  margin: 12px 0 24px;
}

.status {
  padding: 4px 10px;
  border-radius: 999px;
  font-size: 13px;
  font-weight: 600;
}

.status.draft {
  background: #fef3c7;
  color: #92400e;
}

.status.ready {
  background: #dcfce7;
  color: #166534;
}

button {
  border: 0;
  border-radius: 7px;
  padding: 10px 16px;
  font: inherit;
  font-weight: 600;
  cursor: pointer;
}

.primary {
  background: #111827;
  color: white;
}

.secondary {
  background: #f3f4f6;
  color: #374151;
}

footer {
  padding: 32px;
  text-align: center;
  color: #9ca3af;
  font-size: 13px;
}
</style>