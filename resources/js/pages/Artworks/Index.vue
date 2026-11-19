<script setup lang="ts">
import { ref } from 'vue';
import { Head, Link, router } from '@inertiajs/vue3';
import { ImagePlus, Search, Sparkles } from '@lucide/vue';
import ArtworkCard from '@/components/site/ArtworkCard.vue';
import EmptyState from '@/components/site/EmptyState.vue';
import PageBanner from '@/components/site/PageBanner.vue';
import Pagination from '@/components/site/Pagination.vue';

const props = defineProps<{
    artworks: any;
    categories: any[];
    likedIds: number[];
    filters: { search?: string; category?: string; sort?: string };
}>();

const search = ref(props.filters.search || '');

const apply = (overrides: Record<string, string | undefined> = {}) => {
    router.get(
        '/galeri',
        {
            search: search.value || undefined,
            category: props.filters.category || undefined,
            sort: props.filters.sort || undefined,
            ...overrides,
        },
        { preserveState: true, preserveScroll: true },
    );
};
</script>

<template>
    <Head title="Galeri Karya" />

    <PageBanner
        eyebrow="Galeri Karya"
        title="Inspirasi lahir dari karya yang dibagikan"
        description="Jelajahi karya-karya terbaik para kreator, berikan apresiasi, dan temukan ide untuk proyekmu berikutnya."
    >
        <div class="mt-7 flex max-w-2xl flex-col gap-3 sm:flex-row">
            <form class="relative flex-1" @submit.prevent="apply()">
                <Search
                    class="absolute top-1/2 left-4 size-4 -translate-y-1/2 text-slate-500"
                />
                <input
                    v-model="search"
                    type="search"
                    placeholder="Cari karya atau kreator..."
                    class="field-input !bg-white !py-3.5 !pl-11 shadow-md shadow-slate-900/5"
                />
            </form>
            <Link href="/galeri/unggah" class="btn-primary shrink-0 !py-3.5"
                ><ImagePlus class="size-4" /> Unggah Karya</Link
            >
        </div>
    </PageBanner>

    <div class="site-container py-12">
        <div class="mb-8 flex flex-wrap items-center gap-2">
            <span
                class="mr-1 text-xs font-bold tracking-wide text-slate-500 uppercase"
                >Kategori</span
            >
            <button
                type="button"
                class="rounded-xl border px-3.5 py-2 text-xs font-semibold transition"
                :class="
                    !filters.category
                        ? 'border-brand-600 bg-brand-600 text-white'
                        : 'border-slate-200 bg-white text-slate-600 hover:border-brand-500/40'
                "
                @click="apply({ category: undefined })"
            >
                Semua
            </button>
            <button
                v-for="category in categories"
                :key="category.id"
                type="button"
                class="rounded-xl border px-3.5 py-2 text-xs font-semibold transition"
                :class="
                    filters.category === category.slug
                        ? 'border-brand-600 bg-brand-600 text-white'
                        : 'border-slate-200 bg-white text-slate-600 hover:border-brand-500/40'
                "
                @click="apply({ category: category.slug })"
            >
                {{ category.name }}
            </button>
            <select
                class="ml-auto rounded-xl border border-slate-200 bg-white px-3.5 py-2 text-xs font-semibold text-slate-600 outline-none focus:border-brand-400"
                :value="filters.sort || 'latest'"
                @change="
                    apply({ sort: ($event.target as HTMLSelectElement).value })
                "
            >
                <option value="latest">Terbaru</option>
                <option value="popular">Paling Populer</option>
            </select>
        </div>

        <div
            v-if="artworks.data.length"
            class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4"
        >
            <ArtworkCard
                v-for="artwork in artworks.data"
                :key="artwork.id"
                :artwork="artwork"
                :liked-ids="likedIds"
            />
        </div>
        <EmptyState
            v-else
            title="Karya tidak ditemukan"
            description="Coba kata kunci atau kategori lain untuk menemukan karya yang kamu cari."
        />

        <Pagination :links="artworks.links" />

        <!-- CTA -->
        <div
            class="mt-14 flex flex-col items-center gap-4 rounded-3xl border border-brand-500/20 bg-gradient-to-r from-brand-500/10 to-teal-500/10 px-6 py-10 text-center"
        >
            <span
                class="flex size-12 items-center justify-center rounded-2xl bg-white text-brand-400 shadow-sm"
                ><Sparkles class="size-5"
            /></span>
            <h3 class="text-xl font-extrabold text-slate-900">
                Punya karya yang ingin kamu pamerkan?
            </h3>
            <p class="max-w-lg text-sm text-slate-600">
                Bagikan hasil karyamu dan dapatkan apresiasi dari komunitas
                kreatif.
            </p>
            <Link href="/galeri/unggah" class="btn-primary"
                ><ImagePlus class="size-4" /> Unggah Karya Sekarang</Link
            >
        </div>
    </div>
</template>
