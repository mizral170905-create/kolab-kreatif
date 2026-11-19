<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import {
    Bell,
    BellRing,
    CheckCheck,
    Heart,
    Image,
    MessageCircle,
    Sparkles,
    Users,
} from '@lucide/vue';
import EmptyState from '@/components/site/EmptyState.vue';
import PageBanner from '@/components/site/PageBanner.vue';
import Pagination from '@/components/site/Pagination.vue';

defineProps<{ notifications: any }>();

const icons: Record<string, any> = {
    project: Users,
    artwork: Image,
    like: Heart,
    comment: MessageCircle,
    system: Sparkles,
};

const colors: Record<string, string> = {
    project: 'bg-brand-500/10 text-brand-400',
    artwork: 'bg-teal-500/10 text-teal-700',
    like: 'bg-rose-50 text-rose-600',
    comment: 'bg-teal-500/10 text-teal-700',
    system: 'bg-emerald-500/10 text-emerald-700',
};

const read = (id: number) =>
    router.patch(`/notifikasi/${id}`, {}, { preserveScroll: true });
const readAll = () =>
    router.post('/notifikasi/dibaca-semua', {}, { preserveScroll: true });
</script>

<template>
    <Head title="Notifikasi" />

    <PageBanner
        eyebrow="Aktivitas"
        title="Notifikasi"
        description="Pantau semua aktivitas dan interaksi yang melibatkan kamu di KolabKreatif."
    >
        <button
            type="button"
            class="btn-secondary mt-6 !py-2.5 !text-xs"
            @click="readAll"
        >
            <CheckCheck class="size-3.5" /> Tandai semua dibaca
        </button>
    </PageBanner>

    <div class="site-container max-w-4xl py-12">
        <div class="card-soft divide-y divide-slate-200 overflow-hidden">
            <div
                v-for="item in notifications.data"
                :key="item.id"
                class="flex gap-4 px-5 py-5 transition sm:px-6"
                :class="item.read_at ? 'bg-white' : 'bg-brand-500/10'"
            >
                <span
                    :class="[
                        'flex size-11 shrink-0 items-center justify-center rounded-2xl',
                        colors[item.type] || colors.system,
                    ]"
                >
                    <component :is="icons[item.type] || Bell" class="size-5" />
                </span>
                <div class="min-w-0 flex-1">
                    <div class="flex flex-wrap items-center gap-2">
                        <p class="text-sm font-bold text-slate-900">
                            {{ item.title }}
                        </p>
                        <span
                            v-if="!item.read_at"
                            class="rounded-full bg-brand-600 px-2 py-0.5 text-[9px] font-bold text-white"
                            >BARU</span
                        >
                    </div>
                    <p class="mt-1 text-[13px] leading-6 text-slate-600">
                        {{ item.body }}
                    </p>
                    <div class="mt-2 flex items-center gap-3">
                        <span class="text-[11px] text-slate-500">{{
                            new Date(item.created_at).toLocaleString('id-ID', {
                                day: 'numeric',
                                month: 'long',
                                year: 'numeric',
                                hour: '2-digit',
                                minute: '2-digit',
                            })
                        }}</span>
                        <Link
                            v-if="item.link"
                            :href="item.link"
                            class="text-[11px] font-bold text-brand-400 hover:underline"
                            >Lihat detail →</Link
                        >
                        <button
                            v-if="!item.read_at"
                            type="button"
                            class="ml-auto text-[11px] font-bold text-slate-500 hover:text-brand-400"
                            @click="read(item.id)"
                        >
                            Tandai dibaca
                        </button>
                    </div>
                </div>
            </div>

            <EmptyState
                v-if="!notifications.data.length"
                title="Belum ada notifikasi"
                description="Aktivitas seperti permintaan bergabung, suka, dan komentar akan muncul di sini."
            >
                <Link href="/proyek" class="btn-primary mt-5 !py-2.5 !text-xs"
                    >Jelajahi Proyek</Link
                >
            </EmptyState>
        </div>

        <Pagination :links="notifications.links" />
    </div>
</template>
