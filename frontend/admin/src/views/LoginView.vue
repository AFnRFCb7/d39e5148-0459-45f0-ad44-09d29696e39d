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
    <button type="button" @click="logout">
      Logout
    </button>
  </main>
</template>

<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";

const router = useRouter();

const email = ref("");
const password = ref("");
const error = ref("");
const loading = ref(false);

async function login() {
  loading.value = true;
  error.value = "";

  try {
    console.log("Submitting login");

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

    console.log("Login response:", response.status);

    if (!response.ok) {
      error.value = await response.text() || "Login failed";
      return;
    }

    emit("success");
    await router.push("/");
  } catch (e) {
    console.error("Login error:", e);
    error.value = "Unable to contact the server";
  } finally {
    loading.value = false;
  }
}

async function logout() {
  error.value = "";

  try {
    const response = await fetch("/api/logout", {
      method: "POST",
      credentials: "include"
    });

    if (!response.ok) {
      throw new Error("Logout failed");
    }

    password.value = "";
    await router.push("/login");
  } catch (e) {
    console.error("Logout error:", e);
    error.value = "Unable to log out";
  }
}

const emit = defineEmits(["success"]);
</script>