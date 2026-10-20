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