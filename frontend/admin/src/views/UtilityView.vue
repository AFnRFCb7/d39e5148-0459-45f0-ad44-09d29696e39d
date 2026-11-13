 <template>
  <main>
    <h1>Utility</h1>

    <form @submit.prevent="generateHash">
      <label for="password">Password</label>
      <input
        id="password"
        v-model="password"
        type="password"
        required
      />

      <label for="admin">Admin</label>
      <select id="admin" v-model="admin">
        <option value="true">True</option>
        <option value="false">False</option>
      </select>

      <button type="submit" :disabled="loading">
        {{ loading ? "Generating..." : "Generate Hash" }}
      </button>
    </form>

    <p v-if="error">{{ error }}</p>

    <section v-if="hash" class="result">
      <label for="hash">Generated Password Hash</label>
      <textarea
        id="hash"
        :value="hash"
        readonly
        rows="5"
        spellcheck="false"
      ></textarea>

      <button type="button" @click="copyHash">
        {{ copied ? "Copied!" : "Copy Hash" }}
      </button>
    </section>
  </main>
</template>

<script setup>
import { ref } from "vue";

const password = ref("");
const admin = ref("false");
const hash = ref("");
const error = ref("");
const loading = ref(false);

async function generateHash() {
  loading.value = true;
  error.value = "";
  hash.value = "";

  try {
    const response = await fetch(
      `/api/utility/password?password=${encodeURIComponent(password.value)}`
    );

    if (!response.ok) {
      throw new Error(await response.text());
    }

    hash.value = await response.text();
  } catch (e) {
    error.value = e.message || "Failed to generate hash";
  } finally {
    loading.value = false;
  }
}

const copied = ref(false);

async function copyHash() {
  try {
    await navigator.clipboard.writeText(hash.value);
    copied.value = true;
  } catch (e) {
    error.value = "Could not copy hash. Select the text and copy it manually.";
  }
}
</script>