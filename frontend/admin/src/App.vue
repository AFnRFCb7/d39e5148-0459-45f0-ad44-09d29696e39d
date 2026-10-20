<template>
  <div class="session-status">
    <strong v-if="session?.loggedIn">
      &lt;LOGGED IN&gt; {{ session.user.email }} | ID: {{ session.user.id }}
    </strong>
    <strong v-else-if="session">
      &lt;NOT LOGGED IN&gt;
    </strong>
    <strong v-else>
      &lt;CHECKING SESSION&gt;
    </strong>
  </div>
  <router-link to="/">Home</router-link>
  <router-view />
</template>
<script setup>
import { ref, onMounted } from "vue";

const session = ref(null);

async function checkSession() {
  try {
    const response = await fetch("/api/session", {
      credentials: "include"
    });

    if (!response.ok) {
      throw new Error("Session check failed");
    }

    session.value = await response.json();
  } catch (error) {
    console.error("Session check failed:", error);
    session.value = { loggedIn: false, user: null };
  }
}

onMounted(checkSession);
</script>

<style scoped>
.session-status {
  padding: 1rem;
  margin-bottom: 1rem;
  border: 3px solid black;
  font-size: 1.25rem;
  font-weight: bold;
}
</style>