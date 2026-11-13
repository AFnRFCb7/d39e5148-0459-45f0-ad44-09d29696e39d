```vue
<template>
  <main>
    <h1>Health Check</h1>
    <p>Check the health of the admin backend.</p>

    <label>
        Marker:
        <input v-model="marker" type="text"/>
    </label>
    <table>
      <thead>
        <tr>
          <th>Role</th>
          <th>GET</th>
          <th>SET</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="role in roles" :key="role">
          <th>{{ roleLabels[role] }}</th>
          <td>
            <button @click="check(role, 'get')">GET</button>
            <p v-if="results[role].get">{{ results[role].get }}</p>
          </td>
          <td>
            <button @click="check(role, 'set')">SET</button>
            <p v-if="results[role].set">{{ results[role].set }}</p>
          </td>
        </tr>
      </tbody>
    </table>
  </main>
</template>

<script setup lang="ts">
import { reactive , ref } from 'vue'
const marker = ref('foo')

const roles = ['unauthenticated', 'regular', 'admin'] as const
type Role = typeof roles[number]
type Operation = 'get' | 'set'

const roleLabels: Record<Role, string> = {
  unauthenticated: 'Unauthenticated',
  regular: 'Regular',
  admin: 'Admin',
}

const results = reactive(
  Object.fromEntries(
    roles.map(role => [role, { get: '', set: '' }]),
  ) as Record<Role, Record<Operation, string>>,
)

async function check(role: Role, operation: Operation) {
  results[role][operation] = 'Running...'

  try {
    const response = await fetch(
      `/api/health-check/${role}/marker`,
      operation === 'get'
        ? { method: 'GET' }
        : {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ marker: marker.value }),
          },
    )

    const body = await response.text()
    results[role][operation] =
      `${response.status} ${response.statusText}` +
      (body ? ` — ${body}` : '')
  } catch (error) {
    results[role][operation] =
      `Request failed: ${error instanceof Error ? error.message : String(error)}`
  }
}
</script>
```