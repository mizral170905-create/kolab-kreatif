<script setup lang="ts">
import { computed, ref } from 'vue';
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import {
    Heart,
    MessageCircle,
    MessagesSquare,
    Search,
    Send,
    Sparkles,
    Users,
} from '@lucide/vue';
import EmptyState from '@/components/site/EmptyState.vue';
import PageBanner from '@/components/site/PageBanner.vue';
import Pagination from '@/components/site/Pagination.vue';

const props = defineProps<{
    posts: any;
    topics: string[];
    members: any[];
    likedIds: number[];
    filters: { topic?: string; search?: string };
}>();

const page = usePage<any>();
const errors = computed(() => page.props.errors || {});
const search = ref(props.filters.search || '');
const showComments = ref<Record<number, boolean>>({});
const commentText = ref<Record<number, string>>({});
const composer = ref({ title: '', body: '', topic: 'Diskusi Umum' });

const apply = (overrides: Record<string, string | undefined> = {}) => {
    router.get(
        '/komunitas',
        {
            search: search.value || undefined,
            topic: props.filters.topic || undefined,
            ...overrides,
        },
        { preserveState: true, preserveScroll: true },
    );
};

const createPost = () => {
    router.post('/komunitas', composer.value, {
        preserveScroll: true,
        onSuccess: () =>
            (composer.value = { title: '', body: '', topic: 'Diskusi Umum' }),
    });
};

const toggleLike = (id: number) => {
    router.post(`/komunitas/${id}/suka`, {}, { preserveScroll: true });
};

const postComment = (id: number) => {
    router.post(
        `/komunitas/${id}/komentar`,
        { body: commentText.value[id] },
        {
            preserveScroll: true,
            onSuccess: () => (commentText.value[id] = ''),
        },
    );
};
</script>

<template>
    <Head title="Komunitas" />

    <PageBanner
        eyebrow="Komunitas"
        title="Bertukar ide, tumbuh bersama"
        description="Ruang diskusi terbuka untuk berbagi cerita, bertanya, memberi masukan, dan menemukan teman seperjuangan kreatif."
    />

    <div class="site-container grid gap-8 py-12 lg:grid-cols-[1fr_300px]">
        <div class="min-w-0">
            <!-- Composer -->
            <form
                v-if="page.props.auth.user"
                class="card-soft p-6"
                @submit.prevent="createPost"
            >
                <div class="flex items-center gap-3">
                    <img
                        :src="page.props.auth.user.avatar_url"
                        alt="Saya"
                        class="size-10 rounded-xl object-cover"
                    />
                    <div>
                        <p class="text-sm font-bold text-slate-900">
                            {{ page.props.auth.user.name }}
                        </p>
                        <p class="text-xs text-slate-500">
                            Bagikan sesuatu dengan komunitas
                        </p>
                    </div>
                </div>
                <input
                    v-model="composer.title"
                    class="field-input mt-5"
                    placeholder="Judul diskusi baru..."
                />
                <p v-if="errors.title" class="mt-1 text-xs text-red-600">
                    {{ errors.title }}
                </p>
                <textarea
                    v-model="composer.body"
                    rows="3"
                    class="field-input mt-3 resize-none"
                    placeholder="Tulis cerita, pertanyaan, atau ide kamu..."
                ></textarea>
                <p v-if="errors.body" class="mt-1 text-xs text-red-600">
                    {{ errors.body }}
                </p>
                <div class="mt-4 flex flex-wrap items-center gap-3">
                    <select
                        v-model="composer.topic"
                        class="field-input !w-auto !py-2.5 !text-xs"
                    >
                        <option
                            v-for="topic in topics"
                            :key="topic"
                            :value="topic"
                        >
                            {{ topic }}
                        </option>
                    </select>
                    <button
                        type="submit"
                        class="btn-primary ml-auto !px-4 !py-2.5 !text-xs"
                    >
                        <Send class="size-3.5" /> Terbitkan
                    </button>
                </div>
            </form>
            <div
                v-else
                class="card-soft flex flex-wrap items-center justify-between gap-4 p-6"
            >
                <div>
                    <p class="text-sm font-bold text-slate-900">
                        Punya ide atau pertanyaan?
                    </p>
                    <p class="mt-1 text-xs text-slate-500">
                        Masuk untuk ikut berdiskusi dengan kreator lain.
                    </p>
                </div>
                <Link href="/login" class="btn-primary !px-4 !py-2.5 !text-xs"
                    >Masuk & Berdiskusi</Link
                >
            </div>

            <!-- Filters -->
            <div class="mt-8 flex flex-wrap items-center gap-2">
                <form
                    class="relative min-w-52 flex-1"
                    @submit.prevent="apply()"
                >
                    <Search
                        class="absolute top-1/2 left-3.5 size-3.5 -translate-y-1/2 text-slate-500"
                    />
                    <input
                        v-model="search"
                        type="search"
                        placeholder="Cari diskusi..."
                        class="field-input !py-2.5 !pl-10 !text-xs"
                    />
                </form>
                <button
                    type="button"
                    class="rounded-xl border px-3 py-2 text-[11px] font-semibold transition"
                    :class="
                        !filters.topic
                            ? 'border-brand-600 bg-brand-600 text-white'
                            : 'border-slate-200 bg-white text-slate-600'
                    "
                    @click="apply({ topic: undefined })"
                >
                    Semua
                </button>
                <button
                    v-for="topic in topics"
                    :key="topic"
                    type="button"
                    class="rounded-xl border px-3 py-2 text-[11px] font-semibold transition"
                    :class="
                        filters.topic === topic
                            ? 'border-brand-600 bg-brand-600 text-white'
                            : 'border-slate-200 bg-white text-slate-600 hover:border-brand-500/40'
                    "
                    @click="apply({ topic })"
                >
                    {{ topic }}
                </button>
            </div>

            <!-- Posts -->
            <div class="mt-6 space-y-5">
                <article
                    v-for="post in posts.data"
                    :key="post.id"
                    class="card-soft p-6"
                >
                    <div class="flex items-center gap-3">
                        <img
                            :src="post.user.avatar_url"
                            :alt="post.user.name"
                            class="size-10 rounded-xl object-cover"
                        />
                        <div class="min-w-0">
                            <p
                                class="truncate text-sm font-bold text-slate-900"
                            >
                                {{ post.user.name }}
                            </p>
                            <p class="text-[11px] text-slate-500">
                                {{
                                    new Date(
                                        post.created_at,
                                    ).toLocaleDateString('id-ID', {
                                        day: 'numeric',
                                        month: 'long',
                                        year: 'numeric',
                                    })
                                }}
                            </p>
                        </div>
                        <span
                            class="ml-auto rounded-lg bg-brand-500/10 px-2.5 py-1 text-[10px] font-bold text-brand-400"
                            >{{ post.topic }}</span
                        >
                    </div>

                    <h2
                        class="mt-4 text-[17px] leading-snug font-bold text-slate-900"
                    >
                        {{ post.title }}
                    </h2>
                    <p
                        class="mt-2 text-[13px] leading-7 whitespace-pre-line text-slate-600"
                    >
                        {{ post.body }}
                    </p>
                    <img
                        v-if="post.image"
                        :src="post.image"
                        :alt="post.title"
                        class="mt-4 max-h-72 w-full rounded-xl object-cover"
                    />

                    <div
                        class="mt-5 flex items-center gap-4 border-t border-slate-200 pt-4"
                    >
                        <button
                            type="button"
                            class="flex items-center gap-1.5 text-xs font-bold transition"
                            :class="
                                likedIds.includes(post.id)
                                    ? 'text-rose-600'
                                    : 'text-slate-500 hover:text-rose-600'
                            "
                            @click="toggleLike(post.id)"
                        >
                            <Heart
                                class="size-4"
                                :fill="
                                    likedIds.includes(post.id)
                                        ? 'currentColor'
                                        : 'none'
                                "
                            />
                            {{ post.likes_count }}
                        </button>
                        <button
                            type="button"
                            class="flex items-center gap-1.5 text-xs font-bold text-slate-500 hover:text-brand-400"
                            @click="
                                showComments[post.id] = !showComments[post.id]
                            "
                        >
                            <MessageCircle class="size-4" />
                            {{ post.comments_count }} komentar
                        </button>
                    </div>

                    <div
                        v-if="showComments[post.id]"
                        class="mt-4 space-y-3 border-t border-slate-200 pt-4"
                    >
                        <div
                            v-for="item in post.comments"
                            :key="item.id"
                            class="flex gap-2.5"
                        >
                            <img
                                :src="item.user.avatar_url"
                                :alt="item.user.name"
                                class="size-8 shrink-0 rounded-lg object-cover"
                            />
                            <div
                                class="min-w-0 rounded-xl bg-slate-50 px-3 py-2"
                            >
                                <p class="text-xs font-bold text-slate-800">
                                    {{ item.user.name }}
                                </p>
                                <p
                                    class="mt-0.5 text-xs leading-5 text-slate-600"
                                >
                                    {{ item.body }}
                                </p>
                            </div>
                        </div>
                        <form
                            v-if="page.props.auth.user"
                            class="flex gap-2"
                            @submit.prevent="postComment(post.id)"
                        >
                            <input
                                v-model="commentText[post.id]"
                                class="field-input !py-2.5 !text-xs"
                                placeholder="Tulis komentar..."
                            />
                            <button
                                type="submit"
                                class="btn-primary shrink-0 !px-3 !py-2.5"
                            >
                                <Send class="size-3.5" />
                            </button>
                        </form>
                    </div>
                </article>

                <EmptyState
                    v-if="!posts.data.length"
                    title="Diskusi tidak ditemukan"
                    description="Coba kata kunci atau topik lain untuk menemukan percakapan yang menarik."
                />
            </div>

            <Pagination :links="posts.links" />
        </div>

        <!-- Sidebar -->
        <aside class="space-y-6">
            <div class="card-soft p-6">
                <h3
                    class="flex items-center gap-2 text-sm font-bold text-slate-900"
                >
                    <Users class="size-4 text-brand-400" /> Anggota Aktif
                </h3>
                <div class="mt-5 space-y-4">
                    <Link
                        v-for="member in members"
                        :key="member.id"
                        :href="'/profil/' + member.id"
                        class="flex items-center gap-3"
                    >
                        <img
                            :src="member.avatar_url"
                            :alt="member.name"
                            class="size-9 rounded-lg object-cover"
                        />
                        <div class="min-w-0">
                            <p
                                class="truncate text-xs font-bold text-slate-800"
                            >
                                {{ member.name }}
                            </p>
                            <p class="truncate text-[10px] text-slate-500">
                                {{ member.expertise || 'Kreator' }}
                            </p>
                        </div>
                    </Link>
                </div>
            </div>
            <div
                class="brand-gradient overflow-hidden rounded-2xl p-6 text-white"
            >
                <Sparkles class="size-6" />
                <h3 class="mt-4 text-base font-extrabold">
                    Ide bagus harus didengar.
                </h3>
                <p class="mt-2 text-xs leading-6 text-white/80">
                    Jangan ragu berbagi pertanyaan sederhana sekalipun.
                    Kolaborasi hebat sering dimulai dari obrolan kecil.
                </p>
                <MessagesSquare class="mt-5 size-8 text-white/30" />
            </div>
        </aside>
    </div>
</template>
