<script setup lang="ts">
import { ref } from 'vue';
import { Head, Link, router } from '@inertiajs/vue3';
import { Plus, Search, SlidersHorizontal } from '@lucide/vue';
import EmptyState from '@/components/site/EmptyState.vue';
import PageBanner from '@/components/site/PageBanner.vue';
import Pagination from '@/components/site/Pagination.vue';
import ProjectCard from '@/components/site/ProjectCard.vue';

const props = defineProps<{
    projects: any;
    categories: any[];
    filters: { search?: string; category?: string; status?: string };
}>();

const search = ref(props.filters.search || '');

const apply = () => {
    router.get(
        '/proyek',
        {
            search: search.value || undefined,
            category: props.filters.category || undefined,
            status: props.filters.status || undefined,
        },
        { preserveState: true, preserveScroll: true },
    );
};

const setFilter = (key: 'category' | 'status', value?: string) => {
    router.get(
        '/proyek',
        {
            search: search.value || undefined,
            category:
                key === 'category'
                    ? value || undefined
                    : props.filters.category || undefined,
            status:
                key === 'status'
                    ? value || undefined
                    : props.filters.status || undefined,
        },
        { preserveState: true, preserveScroll: true },
    );
};
</script>

<template>
    <Head title="Jelajahi Proyek" />

    <PageBanner
        eyebrow="Jelajahi Proyek"
        title="Temukan proyek yang cocok denganmu"
        description="Cari proyek menarik, bertemu kreator dari berbagai bidang, dan jadi bagian dari tim yang menciptakan sesuatu yang berarti."
    >
        <div class="mt-7 flex max-w-2xl flex-col gap-3 sm:flex-row">
            <form class="relative flex-1" @submit.prevent="apply">
                <Search
                    class="absolute top-1/2 left-4 size-4 -translate-y-1/2 text-slate-500"
                />
                <input
                    v-model="search"
                    type="search"
                    placeholder="Cari proyek, keahlian, atau kata kunci..."
                    class="field-input !bg-white !py-3.5 !pl-11 shadow-md shadow-slate-900/5"
                />
            </form>
            <Link href="/proyek/buat" class="btn-primary shrink-0 !py-3.5">
                <Plus class="size-4" /> Buat Proyek
            </Link>
        </div>
    </PageBanner>

    <div class="site-container py-12">
        <!-- Filters -->
        <div class="mb-8 flex flex-wrap items-center gap-2">
            <span
                class="mr-1 flex items-center gap-1.5 text-xs font-bold tracking-wide text-slate-500 uppercase"
            >
                <SlidersHorizontal class="size-3.5" /> Kategori
            </span>
            <button
                type="button"
                class="rounded-xl border px-3.5 py-2 text-xs font-semibold transition"
                :class="
                    !filters.category
                        ? 'border-brand-600 bg-brand-600 text-white'
                        : 'border-slate-200 bg-white text-slate-600 hover:border-brand-500/40'
                "
                @click="setFilter('category')"
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
                @click="setFilter('category', category.slug)"
            >
                {{ category.name }}
            </button>

            <span class="ml-2 hidden h-6 w-px bg-slate-200 sm:block"></span>
            <select
                class="rounded-xl border border-slate-200 bg-white px-3.5 py-2 text-xs font-semibold text-slate-600 outline-none focus:border-brand-400"
                :value="filters.status || ''"
                @change="
                    setFilter(
                        'status',
                        ($event.target as HTMLSelectElement).value,
                    )
                "
            >
                <option value="">Semua Status</option>
                <option value="open">Merekrut Anggota</option>
                <option value="in_progress">Sedang Berjalan</option>
                <option value="completed">Selesai</option>
            </select>
        </div>

        <div class="mb-6 flex items-center justify-between">
            <p class="text-sm text-slate-500">
                Menampilkan
                <span class="font-bold text-slate-900">{{
                    projects.total
                }}</span>
                proyek
                <span v-if="filters.search"> untuk “{{ filters.search }}”</span>
            </p>
        </div>

        <div
            v-if="projects.data.length"
            class="grid gap-6 md:grid-cols-2 lg:grid-cols-3"
        >
            <ProjectCard
                v-for="project in projects.data"
                :key="project.id"
                :project="project"
            />
        </div>
        <EmptyState
            v-else
            title="Proyek tidak ditemukan"
            description="Coba kata kunci lain atau ubah filter kategori untuk melihat lebih banyak proyek."
        />

        <Pagination :links="projects.links" />
    </div>
</template>
