<script setup lang="ts">
defineProps<{
    eyebrow?: string;
    title: string;
    description?: string;
}>();
</script>

<template>
    <section
        class="relative overflow-hidden border-b border-brand-500/20 bg-gradient-to-br from-brand-500/10 via-white to-teal-500/10"
    >
        <div
            class="absolute -top-28 -left-20 size-80 rounded-full bg-brand-500/20 blur-3xl"
        ></div>
        <div
            class="absolute right-0 -bottom-32 size-96 rounded-full bg-teal-500/20 blur-3xl"
        ></div>
        <div class="site-container relative py-14 sm:py-16">
            <span v-if="eyebrow" class="chip reveal mb-4">{{ eyebrow }}</span>
            <h1
                class="reveal reveal-delay-1 max-w-3xl text-3xl font-extrabold tracking-tight text-slate-900 sm:text-[42px] sm:leading-[1.15]"
            >
                {{ title }}
            </h1>
            <p
                v-if="description"
                class="reveal reveal-delay-2 mt-4 max-w-2xl text-[15px] leading-7 text-slate-600"
            >
                {{ description }}
            </p>
            <slot />
        </div>
    </section>
</template>
