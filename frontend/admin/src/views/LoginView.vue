<template>
  <main>
    <h1>Login</h1>

    <form @submit.prevent="login">
      <label>
        Email
        <input v-model="email" type="email" required />
      </label>

      <label>
        Password
        <input v-model="password" type="password" required />
      </label>

      <p v-if="error">{{ error }}</p>

      <button type="submit" :disabled="loading">
        {{ loading ? "Logging in..." : "Login" }}
      </button>
    </form>
  </main>
</template>

<script setup>
import { ref } from "vue";

const email = ref("");
const password = ref("");
const error = ref("");
const loading = ref(false);

async function login() {
  loading.value = true;
  error.value = "";

  try {
    const response = await fetch("/api/login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      credentials: "include",
      body: JSON.stringify({
        email: email.value,
        password: password.value
      })
    });

    if (!response.ok) {
      error.value = "Login failed";
      return;
    }

    // Login succeeded; notify the parent component.
    router.push("/");
  } catch {
    error.value = "Unable to contact the server";
  } finally {
    loading.value = false;
  }
}

const emit = defineEmits(["success"]);
</script>