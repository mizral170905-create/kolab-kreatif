<script setup lang="ts">
import { Link } from '@inertiajs/vue3';
import { Heart, MessageCircle } from '@lucide/vue';

defineProps<{ artwork: any; likedIds?: number[] }>();
</script>

<template>
    <Link
        :href="'/karya/' + artwork.id"
        class="card-soft group block overflow-hidden"
    >
        <div class="relative aspect-[4/3] overflow-hidden bg-slate-100">
            <img
                :src="artwork.image"
                :alt="artwork.title"
                class="size-full object-cover transition-transform duration-500 group-hover:scale-105"
                loading="lazy"
            />
            <div
                class="absolute inset-0 bg-gradient-to-t from-slate-950/50 via-transparent to-transparent opacity-0 transition-opacity duration-300 group-hover:opacity-100"
            ></div>
            <span
                class="absolute top-3 right-3 rounded-lg bg-slate-50/75 px-2.5 py-1 text-[10px] font-bold text-brand-300 opacity-0 shadow-sm transition-opacity group-hover:opacity-100"
            >
                {{ artwork.category?.name || 'Karya' }}
            </span>
            <div
                class="absolute bottom-3 left-4 flex gap-3 text-xs font-semibold text-white opacity-0 drop-shadow-md transition-opacity group-hover:opacity-100"
            >
                <span class="flex items-center gap-1"
                    ><Heart
                        class="size-3.5"
                        :fill="
                            likedIds?.includes(artwork.id)
                                ? 'currentColor'
                                : 'none'
                        "
                    />
                    {{ artwork.likes_count ?? 0 }}</span
                >
                <span class="flex items-center gap-1"
                    ><MessageCircle class="size-3.5" />
                    {{ artwork.comments_count ?? 0 }}</span
                >
            </div>
        </div>
        <div class="p-4">
            <h3
                class="truncate text-sm font-bold text-slate-900 group-hover:text-brand-400"
            >
                {{ artwork.title }}
            </h3>
            <div class="mt-2.5 flex items-center gap-2">
                <img
                    :src="artwork.user?.avatar_url"
                    :alt="artwork.user?.name"
                    class="size-6 rounded-full object-cover"
                />
                <span class="truncate text-xs text-slate-500">{{
                    artwork.user?.name
                }}</span>
                <span
                    v-if="artwork.user?.expertise"
                    class="ml-auto shrink-0 text-[10px] font-semibold text-brand-400"
                    >{{ artwork.user.expertise }}</span
                >
            </div>
        </div>
    </Link>
</template>
