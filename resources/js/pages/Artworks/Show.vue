<script setup lang="ts">
import { computed, ref } from 'vue';
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import {
    ArrowLeft,
    Eye,
    Heart,
    MapPin,
    MessageCircle,
    Send,
    Share2,
    Sparkles,
} from '@lucide/vue';
import ArtworkCard from '@/components/site/ArtworkCard.vue';

const props = defineProps<{
    artwork: any;
    likesCount: number;
    likedByMe: boolean;
    related: any[];
}>();

const page = usePage<any>();
const errors = computed(() => page.props.errors || {});
const comment = ref('');
const liked = ref(props.likedByMe);
const likes = ref(props.likesCount);

const toggleLike = () => {
    if (!page.props.auth.user) {
        router.visit('/login');
        return;
    }
    router.post(
        `/karya/${props.artwork.id}/suka`,
        {},
        {
            preserveScroll: true,
            onSuccess: () => {
                liked.value = !liked.value;
                likes.value += liked.value ? 1 : -1;
            },
        },
    );
};

const postComment = () => {
    router.post(
        `/karya/${props.artwork.id}/komentar`,
        { body: comment.value },
        {
            preserveScroll: true,
            onSuccess: () => (comment.value = ''),
        },
    );
};

const share = () => {
    if (navigator.share) {
        navigator
            .share({ title: props.artwork.title, url: window.location.href })
            .catch(() => {});
    } else {
        navigator.clipboard?.writeText(window.location.href);
    }
};
</script>

<template>
    <Head :title="artwork.title" />

    <div class="site-container py-10">
        <Link
            href="/galeri"
            class="mb-6 inline-flex items-center gap-2 text-sm font-semibold text-slate-500 hover:text-brand-400"
        >
            <ArrowLeft class="size-4" /> Kembali ke galeri
        </Link>

        <div class="grid gap-8 lg:grid-cols-[1fr_320px]">
            <div class="min-w-0">
                <div
                    class="overflow-hidden rounded-3xl border border-slate-200 bg-white p-2 shadow-sm"
                >
                    <img
                        :src="artwork.image"
                        :alt="artwork.title"
                        class="w-full rounded-2xl object-contain"
                    />
                </div>

                <section class="card-soft mt-6 p-6 sm:p-7">
                    <div
                        class="flex flex-wrap items-start justify-between gap-4"
                    >
                        <div>
                            <span v-if="artwork.category" class="chip">{{
                                artwork.category.name
                            }}</span>
                            <h1
                                class="mt-3 text-2xl font-extrabold tracking-tight text-slate-900 sm:text-3xl"
                            >
                                {{ artwork.title }}
                            </h1>
                        </div>
                        <div class="flex gap-2">
                            <button
                                type="button"
                                class="flex items-center gap-2 rounded-xl border px-4 py-2.5 text-sm font-bold transition"
                                :class="
                                    liked
                                        ? 'border-rose-200 bg-rose-50 text-rose-600'
                                        : 'border-slate-200 bg-white text-slate-600 hover:border-rose-200 hover:text-rose-600'
                                "
                                @click="toggleLike"
                            >
                                <Heart
                                    class="size-4"
                                    :fill="liked ? 'currentColor' : 'none'"
                                />
                                {{ likes }}
                            </button>
                            <button
                                type="button"
                                class="flex size-10 items-center justify-center rounded-xl border border-slate-200 text-slate-500 hover:bg-slate-50"
                                aria-label="Bagikan"
                                @click="share"
                            >
                                <Share2 class="size-4" />
                            </button>
                        </div>
                    </div>
                    <p
                        class="mt-5 text-[15px] leading-8 whitespace-pre-line text-slate-600"
                    >
                        {{ artwork.description }}
                    </p>
                    <div
                        class="mt-6 flex flex-wrap gap-5 border-t border-slate-200 pt-5 text-xs font-medium text-slate-500"
                    >
                        <span class="flex items-center gap-1.5"
                            ><Eye class="size-4 text-brand-500" />
                            {{ artwork.views }} dilihat</span
                        >
                        <span class="flex items-center gap-1.5"
                            ><MessageCircle class="size-4 text-teal-700" />
                            {{ artwork.comments.length }} komentar</span
                        >
                        <span class="flex items-center gap-1.5"
                            ><Heart class="size-4 text-rose-500" />
                            {{ likes }} suka</span
                        >
                    </div>
                </section>

                <!-- Comments -->
                <section class="card-soft mt-6 p-6 sm:p-7">
                    <h2
                        class="flex items-center gap-2 text-lg font-bold text-slate-900"
                    >
                        <MessageCircle class="size-5 text-brand-500" /> Komentar
                        ({{ artwork.comments.length }})
                    </h2>

                    <form
                        v-if="page.props.auth.user"
                        class="mt-5 flex gap-3"
                        @submit.prevent="postComment"
                    >
                        <img
                            :src="page.props.auth.user.avatar_url"
                            alt="Saya"
                            class="size-10 shrink-0 rounded-xl object-cover"
                        />
                        <div class="flex-1">
                            <textarea
                                v-model="comment"
                                rows="3"
                                class="field-input resize-none"
                                placeholder="Berikan apresiasi atau masukanmu..."
                            ></textarea>
                            <p
                                v-if="errors.body"
                                class="mt-1 text-xs text-red-600"
                            >
                                {{ errors.body }}
                            </p>
                            <button
                                type="submit"
                                class="btn-primary mt-2 !px-4 !py-2 !text-xs"
                            >
                                <Send class="size-3.5" /> Kirim Komentar
                            </button>
                        </div>
                    </form>
                    <p
                        v-else
                        class="mt-5 rounded-xl bg-slate-50 px-4 py-3 text-sm text-slate-500"
                    >
                        <Link
                            href="/login"
                            class="font-bold text-brand-400 hover:underline"
                            >Masuk</Link
                        >
                        untuk memberi komentar.
                    </p>

                    <div class="mt-6 space-y-4">
                        <div
                            v-for="item in artwork.comments"
                            :key="item.id"
                            class="flex gap-3 border-t border-slate-200 pt-4"
                        >
                            <img
                                :src="item.user.avatar_url"
                                :alt="item.user.name"
                                class="size-9 shrink-0 rounded-lg object-cover"
                            />
                            <div class="min-w-0">
                                <p class="text-sm font-bold text-slate-900">
                                    {{ item.user.name }}
                                    <span
                                        class="ml-1 text-[11px] font-normal text-slate-500"
                                        >{{
                                            new Date(
                                                item.created_at,
                                            ).toLocaleDateString('id-ID', {
                                                day: 'numeric',
                                                month: 'short',
                                            })
                                        }}</span
                                    >
                                </p>
                                <p
                                    class="mt-1 text-[13px] leading-6 text-slate-600"
                                >
                                    {{ item.body }}
                                </p>
                            </div>
                        </div>
                        <p
                            v-if="!artwork.comments.length"
                            class="text-center text-sm text-slate-500"
                        >
                            Belum ada komentar. Jadilah yang pertama!
                        </p>
                    </div>
                </section>
            </div>

            <aside class="space-y-6">
                <div class="card-soft p-6">
                    <h3
                        class="text-xs font-bold tracking-wide text-slate-500 uppercase"
                    >
                        Kreator
                    </h3>
                    <Link
                        :href="'/profil/' + artwork.user.id"
                        class="mt-4 flex items-center gap-3"
                    >
                        <img
                            :src="artwork.user.avatar_url"
                            :alt="artwork.user.name"
                            class="size-12 rounded-xl object-cover"
                        />
                        <div class="min-w-0">
                            <p
                                class="truncate text-sm font-bold text-slate-900"
                            >
                                {{ artwork.user.name }}
                            </p>
                            <p class="truncate text-xs text-brand-400">
                                {{ artwork.user.expertise || 'Kreator' }}
                            </p>
                        </div>
                    </Link>
                    <p
                        v-if="artwork.user.bio"
                        class="mt-4 text-xs leading-6 text-slate-500"
                    >
                        {{ artwork.user.bio }}
                    </p>
                    <p
                        v-if="artwork.user.location"
                        class="mt-3 flex items-center gap-1.5 text-xs text-slate-500"
                    >
                        <MapPin class="size-3.5" /> {{ artwork.user.location }}
                    </p>
                </div>

                <div v-if="artwork.project" class="card-soft p-6">
                    <h3
                        class="text-xs font-bold tracking-wide text-slate-500 uppercase"
                    >
                        Bagian dari proyek
                    </h3>
                    <Link
                        :href="'/proyek/' + artwork.project.slug"
                        class="mt-3 flex items-center gap-2 text-sm font-bold text-brand-400 hover:underline"
                    >
                        <Sparkles class="size-4" /> {{ artwork.project.title }}
                    </Link>
                </div>

                <div v-if="related.length" class="card-soft p-6">
                    <h3 class="text-sm font-bold text-slate-900">
                        Karya lainnya
                    </h3>
                    <div class="mt-4 grid grid-cols-2 gap-3">
                        <Link
                            v-for="item in related"
                            :key="item.id"
                            :href="'/karya/' + item.id"
                            class="group"
                        >
                            <img
                                :src="item.image"
                                :alt="item.title"
                                class="aspect-square w-full rounded-lg object-cover transition group-hover:opacity-80"
                            />
                            <p
                                class="mt-1.5 line-clamp-1 text-[11px] font-semibold text-slate-600"
                            >
                                {{ item.title }}
                            </p>
                        </Link>
                    </div>
                </div>
            </aside>
        </div>

        <section v-if="related.length" class="mt-14">
            <h2 class="mb-6 text-xl font-extrabold text-slate-900">
                Karya serupa untukmu
            </h2>
            <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
                <ArtworkCard
                    v-for="item in related"
                    :key="item.id"
                    :artwork="item"
                />
            </div>
        </section>
    </div>
</template>
