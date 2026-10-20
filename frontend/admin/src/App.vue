<template>
  <div class="session-status">
    <strong v-if="session === null">
      &lt;CHECKING LOGIN STATUS&gt;
    </strong>
    <strong v-else-if="session.loggedIn">
      &lt;LOGGED IN&gt; {{ session.user.email }} (ID: {{ session.user.id }})
    </strong>
    <strong v-else>
      &lt;NOT LOGGED IN&gt;
    </strong>
  </div>

  <router-link to="/">Home</router-link>
  <router-view />
</template>

<script setup>
import { ref, watch } from "vue";
import { useRoute } from "vue-router";

const route = useRoute();
const session = ref(null);

async function checkSession() {
  session.value = null;

  try {
    const response = await fetch("/api/session", {
      credentials: "include"
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    session.value = await response.json();
  } catch (error) {
    console.error("Unable to determine login status:", error);
    session.value = { loggedIn: false, user: null };
  }
}

watch(() => route.fullPath, checkSession, { immediate: true });
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