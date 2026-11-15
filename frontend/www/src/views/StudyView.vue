
<script setup lang="ts">
import Carousel, { type CarouselImage } from "../components/CarouselView.vue";
import { useI18n } from 'vue-i18n'
const { t, locale } = useI18n()

const images: CarouselImage[] = [
    {
        src: "/api/data/images/achievement.jpeg",
    },
    {
        src: "/api/data/images/campus-life.jpeg",
    },
    {
        src: "/api/data/images/learning.jpeg",
    },
    {
        src: "/api/data/images/university-experience.jpeg",
    }
];
</script>

<template>
    <main>
        <h1>{{ t('narrative.study.Study in the United States') }}</h1>

        <Carousel :images="images" />

        <p>
            {{ t('narrative.study.Explore educational opportunities in the United States') }}
        </p>
    </main>
</template>
