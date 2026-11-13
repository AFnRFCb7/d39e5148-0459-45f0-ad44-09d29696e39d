<template>
  <main class="construction">
    <div class="content">
      <div class="icon">🚧</div>

      <h1>Under Construction</h1>

      <p>
        We're working on something new.
        Please check back soon!
      </p>

      <div class="divider"></div>

      <span class="status">We'll be back shortly.</span>
    </div>
  </main>
</template>

<style scoped>
.construction {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  background: #f8fafc;
  color: #1e293b;
  font-family: system-ui, sans-serif;
  text-align: center;
}

.content {
  max-width: 480px;
}

.icon {
  font-size: 4rem;
  margin-bottom: 1.5rem;
}

h1 {
  font-size: clamp(2rem, 6vw, 3rem);
  margin: 0 0 1rem;
  font-weight: 700;
}

p {
  color: #64748b;
  font-size: 1.125rem;
  line-height: 1.7;
}

.divider {
  width: 60px;
  height: 4px;
  background: #f59e0b;
  border-radius: 4px;
  margin: 2rem auto;
}

.status {
  color: #94a3b8;
  font-size: 0.875rem;
}
</style>
