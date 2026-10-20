<template>
  <main>
    <h1>Admin Home</h1>
    <p>Welcome to the administration application.</p>
    <ol>
        <li>
            <nav>
                <RouterLink to="/health-check">Health Check</RouterLink>
            </nav>
        </li>
        <li>
            <nav>
                <RouterLink to="/login">Login</RouterLink>
            </nav>
        </li>
        <li>
            <nav>
                <RouterLink to="/utility">Utility</RouterLink>
            </nav>
        </li>
    </ol>
  </main>
</template>

<script setup>
</script>