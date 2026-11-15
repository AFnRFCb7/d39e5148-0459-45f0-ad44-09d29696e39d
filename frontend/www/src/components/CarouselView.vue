
<script setup lang="ts">
import { computed, onMounted, onUnmounted, ref, watch } from "vue";

export interface CarouselImage {
    src: string;
}

const props = withDefaults(defineProps<{
    images: CarouselImage[];
    interval?: number;
    autoPlay?: boolean;
}>(), {
    interval: 5000,
    autoPlay: true
});

const index = ref(0);
const paused = ref(false);

const count = computed(() => props.images.length);

const currentImage = computed(() => {
    if (count.value === 0) {
        return undefined;
    }

    return props.images[index.value % count.value];
});

function previous() {
    index.value = (index.value - 1 + count.value) % count.value;
}

function next() {
    index.value = (index.value + 1) % count.value;
}

function select(i: number) {
    index.value = i;
}

watch(count, value => {
    if (value === 0) {
        index.value = 0;
    } else {
        index.value %= value;
    }
});

let timer: ReturnType<typeof setInterval> | undefined;

function start() {
    stop();

    if (!props.autoPlay || paused.value || count.value < 2) {
        return;
    }

    timer = setInterval(next, props.interval);
}

function stop() {
    if (timer !== undefined) {
        clearInterval(timer);
        timer = undefined;
    }
}

watch(
    () => [props.autoPlay, props.interval, paused.value, count.value],
    start
);

onMounted(start);
onUnmounted(stop);
</script>

<template>
    <div
        class="carousel"
        role="region"
        aria-roledescription="carousel"
        aria-label="Image carousel"
        @mouseenter="paused = true"
        @mouseleave="paused = false"
    >
        <template v-if="currentImage">
            <img
                class="carousel-image"
                :src="currentImage.src"
                alt=""
            />

        </template>
    </div>
</template>

<style scoped>
.carousel {
    position: relative;
    width: 100%;
    overflow: hidden;
    border-radius: 12px;
    background: #172033;
    aspect-ratio: 16 / 9;
}

.carousel-image {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.carousel-previous,
.carousel-next {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    border: 0;
    border-radius: 50%;
    width: 42px;
    height: 42px;
    color: white;
    background: rgba(0, 0, 0, 0.5);
    cursor: pointer;
    font-size: 20px;
}

.carousel-previous {
    left: 12px;
}

.carousel-next {
    right: 12px;
}

.carousel-indicators {
    position: absolute;
    bottom: 14px;
    left: 50%;
    transform: translateX(-50%);
    display: flex;
    gap: 9px;
}

.carousel-indicator {
    width: 10px;
    height: 10px;
    padding: 0;
    border: 0;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.55);
    cursor: pointer;
}

.carousel-indicator.active {
    background: white;
}
</style>
