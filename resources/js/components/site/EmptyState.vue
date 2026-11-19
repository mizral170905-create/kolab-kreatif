<script setup lang="ts">
import { SearchX } from '@lucide/vue';

defineProps<{ title?: string; description?: string }>();
</script>

<template>
    <div
        class="flex flex-col items-center justify-center rounded-2xl border border-dashed border-slate-300 bg-white px-6 py-16 text-center"
    >
        <span
            class="mb-4 flex size-14 items-center justify-center rounded-2xl bg-brand-500/10 text-brand-400"
        >
            <SearchX class="size-6" />
        </span>
        <h3 class="text-base font-bold text-slate-900">
            {{ title || 'Belum ada data' }}
        </h3>
        <p class="mt-2 max-w-sm text-sm text-slate-500">
            {{ description || 'Coba ubah filter atau kata kunci pencarianmu.' }}
        </p>
        <slot />
    </div>
</template>
