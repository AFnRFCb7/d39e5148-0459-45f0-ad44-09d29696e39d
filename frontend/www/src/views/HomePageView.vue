<template>
  <div class="app">'
    <header class="header">
      <div class="logo">Visa</div>
      <nav>
        <a href="#">Travel</a>
        <a href="#">Study</a>
        <a href="#">Move</a>
      </nav>
        <div ref="googleButton"></div>
      <button class="sign-in">Sign In</button>'
      <button @click="callSecret">Test Secret</button>
    </header>
    <section class="hero">
      <div class="hero-content">
        <p class="eyebrow">YOUR JOURNEY STARTS HERE</p>
        <h1>Go farther.<br />Build your future.</h1>
        <p class="hero-description">
          Whether you're traveling, studying, or starting a new life abroad,
          we're here to help you navigate the journey.
        </p>
        <button class="hero-button">Get Started</button>
      </div>
    </section>
    <main>
      <section class="journeys">
        <div class="section-heading">
          <p class="eyebrow">EXPLORE YOUR OPTIONS</p>
          <h2>What's your journey?</h2>
          <p>Choose the path that fits where you are going next.</p>
        </div>

        <div class="journey-grid">
          <article
            v-for="journey in journeys"
            :key="journey.title"
            class="journey-card"
          >
            <img
              class="journey-image"
              :src="journey.image"
              :alt="journey.title"
            />

            <div class="card-content">
              <p class="card-subtitle">{{ journey.subtitle }}</p>
              <h3>{{ journey.title }}</h3>
              <p class="card-description">{{ journey.description }}</p>
                <div class="card-actions">
                  <button class="card-button" @click="selectJourney(journey.title)">
                    Explore {{ journey.title }} →
                  </button>

                <button class="consultation-button" @click="requestConsultation">
                  Request Consultation
                </button>
                </div>
            </div>
          </article>
        </div>
      </section>
    </main>
    <footer>
      <strong>Visa</strong>
      <span>Travel · Study · Move</span>
    </footer>
  </div>
</template>
<script setup>
</script>
<style>
</style>