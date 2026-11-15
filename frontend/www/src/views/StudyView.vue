
<script setup lang="ts">
import Carousel, { type CarouselImage } from "../components/CarouselView.vue";

const images: CarouselImage[] = [
    {
        src: "/api/data/images/achievement.jpeg",
        alt: "University campus"
    },
    {
        src: "/api/data/images/study.jpeg",
        alt: "Students studying in a library"
    },
    {
        src: "/api/data/images/study.jpeg",
        alt: "University graduation ceremony"
    }
];
</script>

<template>
    <main>
        <h1>Study in the United States</h1>

        <Carousel :images="images" />

        <p>
            Explore educational opportunities
            in the United States.
        </p>
    </main>
</template>
