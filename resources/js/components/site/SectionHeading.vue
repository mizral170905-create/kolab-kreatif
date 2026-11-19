<script setup lang="ts">
defineProps<{
    eyebrow?: string;
    title: string;
    description?: string;
    align?: 'left' | 'center';
}>();
</script>

<template>
    <div
        :class="
            align === 'center' ? 'mx-auto max-w-2xl text-center' : 'max-w-2xl'
        "
    >
        <span v-if="eyebrow" class="chip reveal mb-4">
            <span class="size-1.5 rounded-full bg-brand-500"></span>
            {{ eyebrow }}
        </span>
        <h2
            class="reveal reveal-delay-1 text-3xl font-extrabold tracking-tight text-slate-900 sm:text-4xl"
        >
            {{ title }}
        </h2>
        <p
            v-if="description"
            class="reveal reveal-delay-2 mt-4 text-[15px] leading-7 text-slate-600"
        >
            {{ description }}
        </p>
    </div>
</template>
