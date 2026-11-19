<script setup lang="ts">
import { Link } from '@inertiajs/vue3';
import { ChevronLeft, ChevronRight } from '@lucide/vue';

defineProps<{ links: any[] }>();
</script>

<template>
    <div
        v-if="links.length > 3"
        class="mt-10 flex flex-wrap justify-center gap-1.5"
    >
        <template v-for="(link, index) in links" :key="index">
            <span
                v-if="!link.url"
                class="flex size-9 items-center justify-center rounded-lg text-xs font-semibold text-slate-500"
                v-html="link.label"
            />
            <Link
                v-else
                :href="link.url"
                class="flex size-9 items-center justify-center rounded-lg border text-xs font-semibold transition"
                :class="
                    link.active
                        ? 'border-brand-600 bg-brand-600 text-white'
                        : 'border-slate-200 bg-white text-slate-600 hover:border-brand-500/40 hover:text-brand-400'
                "
                :aria-label="link.label"
            >
                <ChevronLeft
                    v-if="link.label.includes('Previous')"
                    class="size-4"
                />
                <ChevronRight
                    v-else-if="link.label.includes('Next')"
                    class="size-4"
                />
                <span v-else v-html="link.label" />
            </Link>
        </template>
    </div>
</template>
