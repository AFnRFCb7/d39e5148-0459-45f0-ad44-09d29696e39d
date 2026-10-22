<script setup>
import { useI18n } from 'vue-i18n'
const { t, locale } = useI18n()
</script>
<template>
    <header class="header">
      <div class="logo">{{ t('subject.Visa') }}</div>
      <nav>
        <a href="#">{{ t('subject.Study') }}</a>
        <a href="#">{{ t('subject.Travel') }}</a>
        <a href="#">{{ t('subject.Move') }}</a>
      </nav>
        <div ref="googleButton"></div>
      <button class="sign-in">Sign In</button>'
    </header>
  <h1> FIND ME </h1>
  <header>
    <h1>{{ t('subject.visa') }}</h1>
    <h1>{{ t('control.log in') }}</h1>
    <select v-model="locale" aria-label="Language">
      <option value="en-US">🇺🇸</option>
      <option value="zh-CN">🇨🇳</option>
    </select>
  </header>
</template>
<style scoped>
* {
  box-sizing: border-box;
}

.app {
  min-height: 100vh;
  background: #f7f6f3;
  color: #172033;
  font-family: Inter, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI",
    sans-serif;
}

/* Header */

.header {
  height: 76px;
  padding: 0 6%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: white;
  border-bottom: 1px solid #e8e6e1;
}

.logo {
  font-size: 27px;
  font-weight: 750;
  letter-spacing: -1px;
}

nav {
  display: flex;
  gap: 36px;
}

nav a {
  color: #596273;
  text-decoration: none;
  font-size: 15px;
}

nav a:hover {
  color: #172033;
}

.sign-in {
  padding: 9px 18px;
  border: 1px solid #d5d8de;
  border-radius: 7px;
  background: white;
  color: #172033;
  font-weight: 600;
  cursor: pointer;
}

/* Hero */

.hero {
  min-height: 540px;
  display: flex;
  align-items: center;
  padding: 60px 8%;
  background-image:
    linear-gradient(
      90deg,
      rgba(12, 24, 42, 0.82),
      rgba(12, 24, 42, 0.45),
      rgba(12, 24, 42, 0.12)
    ),
    url("/images/travel.jpg");
  background-size: cover;
  background-position: center;
}

.hero-content {
  max-width: 620px;
  color: white;
}

.eyebrow {
  margin: 0 0 14px;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 2px;
  text-transform: uppercase;
  opacity: 0.75;
}

.hero h1 {
  margin: 0;
  font-size: clamp(48px, 6vw, 76px);
  line-height: 0.98;
  letter-spacing: -3px;
}

.hero-description {
  max-width: 530px;
  margin: 28px 0;
  font-size: 18px;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.9);
}

.hero-button {
  padding: 13px 24px;
  border: 0;
  border-radius: 7px;
  background: white;
  color: #172033;
  font-weight: 700;
  font-size: 15px;
  cursor: pointer;
}

/* Journeys */

.journeys {
  max-width: 1200px;
  margin: 0 auto;
  padding: 90px 32px;
}

.section-heading {
  margin-bottom: 40px;
}

.section-heading h2 {
  margin: 0 0 10px;
  font-size: 40px;
  letter-spacing: -1.5px;
}

.section-heading > p:last-child {
  margin: 0;
  color: #697180;
  font-size: 17px;
}

.journey-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
}

.journey-card {
  overflow: hidden;
  background: white;
  border: 1px solid #e6e4df;
  border-radius: 14px;
  box-shadow: 0 8px 30px rgba(30, 40, 60, 0.06);
}

.journey-image {
  width: 100%;
  height: 230px;
  display: block;
  object-fit: cover;
}

.card-content {
  padding: 26px;
}

.card-subtitle {
  margin: 0 0 5px;
  color: #777f8c;
  font-size: 13px;
  font-weight: 600;
}

.card-content h3 {
  margin: 0 0 12px;
  font-size: 28px;
  letter-spacing: -1px;
}

.card-description {
  min-height: 48px;
  margin: 0 0 24px;
  color: #697180;
  line-height: 1.5;
}

.card-button {
  padding: 0;
  border: 0;
  background: none;
  color: #172033;
  font-weight: 700;
  cursor: pointer;
}

/* Footer */

footer {
  display: flex;
  justify-content: space-between;
  padding: 30px 6%;
  background: #172033;
  color: rgba(255, 255, 255, 0.7);
  font-size: 13px;
}

/* Mobile */

@media (max-width: 800px) {
  nav {
    display: none;
  }

  .journey-grid {
    grid-template-columns: 1fr;
  }

  .hero h1 {
    font-size: 50px;
  }

  footer {
    flex-direction: column;
    gap: 10px;
  }
}
.card-actions {
  display: flex;
  flex-direction: column;
  gap: 12px;
  align-items: flex-start;
}

.consultation-button {
  padding: 11px 18px;
  border: 0;
  border-radius: 7px;
  background: #172033;
  color: white;
  font-weight: 700;
  font-size: 14px;
  cursor: pointer;
}

.consultation-button:hover {
  opacity: 0.9;
}

.consultation-form {
  max-width: 560px;
  margin: 80px auto;
  padding: 40px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
}

.consultation-form h1 {
  margin: 0 0 8px;
  font-size: 32px;
}

.consultation-form > p {
  margin: 0 0 30px;
  color: #667085;
}

.consultation-form form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.consultation-form label {
  display: flex;
  flex-direction: column;
  gap: 8px;
  font-weight: 600;
}

.consultation-form input {
  padding: 13px 14px;
  border: 1px solid #d0d5dd;
  border-radius: 7px;
  font-size: 16px;
}

.consultation-form input:focus {
  outline: none;
  border-color: #172033;
}

.consultation-form button {
  margin-top: 8px;
  padding: 14px 20px;
  border: 0;
  border-radius: 7px;
  background: #172033;
  color: white;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
}

.consultation-form button:hover {
  opacity: 0.9;
}

.toast {
  position: fixed;
  top: 30px;
  left: 50%;
  transform: translateX(-50%);
  padding: 16px 28px;
  background: #172033;
  color: white;
  border-radius: 8px;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.25);
  font-size: 16px;
  font-weight: 600;
  z-index: 9999;
}
</style>
