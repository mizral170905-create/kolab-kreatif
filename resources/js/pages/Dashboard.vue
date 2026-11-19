<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import {
    ArrowRight,
    Bell,
    FolderKanban,
    Heart,
    Image,
    Plus,
    Sparkles,
    Users,
} from '@lucide/vue';
import PageBanner from '@/components/site/PageBanner.vue';

defineProps<{
    stats: {
        projects: number;
        collaborations: number;
        artworks: number;
        unread: number;
    };
    myProjects: any[];
    collaborations: any[];
    recentArtworks: any[];
    notifications: any[];
}>();

const formatDate = (date: string) =>
    date
        ? new Date(date).toLocaleDateString('id-ID', {
              day: 'numeric',
              month: 'short',
          })
        : '-';

const notificationIcon: Record<string, any> = {
    project: Users,
    artwork: Image,
    like: Heart,
    comment: Bell,
    system: Sparkles,
};
</script>

<template>
    <Head title="Dashboard" />

    <PageBanner
        eyebrow="Dashboard"
        :title="`Selamat datang kembali, ${$page.props.auth.user.name.split(' ')[0]}!`"
        description="Pantau proyek, kolaborasi, dan aktivitas kreatifmu dalam satu tempat."
    >
        <div class="mt-6 flex flex-wrap gap-3">
            <Link href="/proyek/buat" class="btn-primary !py-2.5 !text-xs"
                ><Plus class="size-3.5" /> Buat Proyek Baru</Link
            >
            <Link href="/galeri/unggah" class="btn-secondary !py-2.5 !text-xs"
                ><Image class="size-3.5" /> Unggah Karya</Link
            >
        </div>
    </PageBanner>

    <div class="site-container py-12">
        <!-- Stats -->
        <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            <div
                v-for="card in [
                    {
                        label: 'Proyek Saya',
                        value: stats.projects,
                        icon: FolderKanban,
                        color: 'from-brand-500 to-brand-600',
                        href: '/proyek',
                    },
                    {
                        label: 'Kolaborasi',
                        value: stats.collaborations,
                        icon: Users,
                        color: 'from-blue-600 to-indigo-600',
                        href: '/proyek',
                    },
                    {
                        label: 'Karya Dipublikasi',
                        value: stats.artworks,
                        icon: Image,
                        color: 'from-sky-600 to-blue-600',
                        href: '/galeri',
                    },
                    {
                        label: 'Notifikasi Baru',
                        value: stats.unread,
                        icon: Bell,
                        color: 'from-amber-600 to-orange-600',
                        href: '/notifikasi',
                    },
                ]"
                :key="card.label"
                class="card-soft flex items-center gap-4 p-5"
            >
                <span
                    :class="[
                        'flex size-12 items-center justify-center rounded-2xl bg-gradient-to-br text-white shadow-md',
                        card.color,
                    ]"
                >
                    <component :is="card.icon" class="size-5" />
                </span>
                <div>
                    <p class="text-2xl font-extrabold text-slate-900">
                        {{ card.value }}
                    </p>
                    <Link
                        :href="card.href"
                        class="text-xs font-semibold text-slate-500 hover:text-brand-400"
                        >{{ card.label }} →</Link
                    >
                </div>
            </div>
        </div>

        <div class="mt-8 grid gap-8 lg:grid-cols-[1fr_320px]">
            <div class="space-y-8">
                <!-- My projects -->
                <section class="card-soft p-6">
                    <div class="flex items-center justify-between">
                        <h2 class="text-base font-bold text-slate-900">
                            Proyek Aktif Saya
                        </h2>
                        <Link
                            href="/proyek"
                            class="text-xs font-bold text-brand-400 hover:underline"
                            >Lihat semua</Link
                        >
                    </div>
                    <div class="mt-5 space-y-3">
                        <Link
                            v-for="project in myProjects"
                            :key="project.id"
                            :href="'/proyek/' + project.slug"
                            class="group flex items-center gap-4 rounded-xl border border-slate-200 p-3 transition hover:border-brand-500/30 hover:bg-brand-500/10"
                        >
                            <img
                                :src="project.cover_image"
                                :alt="project.title"
                                class="size-14 shrink-0 rounded-xl object-cover"
                            />
                            <div class="min-w-0 flex-1">
                                <p
                                    class="truncate text-sm font-bold text-slate-900 group-hover:text-brand-400"
                                >
                                    {{ project.title }}
                                </p>
                                <p class="mt-0.5 text-xs text-slate-500">
                                    {{ project.category?.name || 'Proyek' }}
                                    · {{ project.members_count }} anggota ·
                                    {{ formatDate(project.deadline) }}
                                </p>
                            </div>
                            <span
                                class="rounded-lg px-2.5 py-1 text-[10px] font-bold"
                                :class="
                                    project.status === 'open'
                                        ? 'bg-emerald-500/10 text-emerald-700'
                                        : project.status === 'in_progress'
                                          ? 'bg-teal-500/10 text-teal-700'
                                          : 'bg-slate-100 text-slate-600'
                                "
                            >
                                {{
                                    project.status === 'open'
                                        ? 'Merekrut'
                                        : project.status === 'in_progress'
                                          ? 'Berjalan'
                                          : 'Selesai'
                                }}
                            </span>
                        </Link>
                        <p
                            v-if="!myProjects.length"
                            class="rounded-xl bg-slate-50 py-8 text-center text-sm text-slate-500"
                        >
                            Belum ada proyek.
                            <Link
                                href="/proyek/buat"
                                class="font-bold text-brand-400"
                                >Buat yang pertama!</Link
                            >
                        </p>
                    </div>
                </section>

                <!-- Collaborations -->
                <section class="card-soft p-6">
                    <h2 class="text-base font-bold text-slate-900">
                        Kolaborasi yang Diikuti
                    </h2>
                    <div class="mt-5 grid gap-3 sm:grid-cols-2">
                        <Link
                            v-for="item in collaborations"
                            :key="item.id"
                            :href="'/proyek/' + item.project.slug"
                            class="flex items-center gap-3 rounded-xl border border-slate-200 p-3 hover:border-brand-500/30"
                        >
                            <span
                                class="flex size-10 shrink-0 items-center justify-center rounded-xl text-xs font-extrabold text-slate-900"
                                :style="{
                                    background: `linear-gradient(135deg, ${item.project.category?.color || '#8b5cf6'}, #3b82f6)`,
                                }"
                                >{{
                                    (item.project.title || 'P').charAt(0)
                                }}</span
                            >
                            <div class="min-w-0">
                                <p
                                    class="truncate text-xs font-bold text-slate-900"
                                >
                                    {{ item.project.title }}
                                </p>
                                <p class="truncate text-[10px] text-slate-500">
                                    {{ item.role || 'Anggota Tim' }}
                                </p>
                            </div>
                        </Link>
                        <p
                            v-if="!collaborations.length"
                            class="text-sm text-slate-500"
                        >
                            Belum ada kolaborasi.
                            <Link
                                href="/proyek"
                                class="font-bold text-brand-400"
                                >Cari proyek!</Link
                            >
                        </p>
                    </div>
                </section>

                <!-- Recent artworks -->
                <section v-if="recentArtworks.length" class="card-soft p-6">
                    <h2 class="text-base font-bold text-slate-900">
                        Karya Terbaru Saya
                    </h2>
                    <div class="mt-5 grid grid-cols-2 gap-4 sm:grid-cols-4">
                        <Link
                            v-for="artwork in recentArtworks"
                            :key="artwork.id"
                            :href="'/karya/' + artwork.id"
                            class="group"
                        >
                            <img
                                :src="artwork.image"
                                :alt="artwork.title"
                                class="aspect-square w-full rounded-xl object-cover transition group-hover:opacity-80"
                            />
                            <p
                                class="mt-1.5 truncate text-xs font-semibold text-slate-800"
                            >
                                {{ artwork.title }}
                            </p>
                            <p class="text-[10px] text-slate-500">
                                {{ artwork.likes_count }} suka
                            </p>
                        </Link>
                    </div>
                </section>
            </div>

            <!-- Notifications -->
            <aside class="card-soft h-fit p-6">
                <div class="flex items-center justify-between">
                    <h2
                        class="flex items-center gap-2 text-base font-bold text-slate-900"
                    >
                        <Bell class="size-4 text-brand-400" /> Aktivitas Terbaru
                    </h2>
                    <Link
                        href="/notifikasi"
                        class="text-xs font-bold text-brand-400 hover:underline"
                        >Semua</Link
                    >
                </div>
                <div class="mt-5 space-y-1">
                    <Link
                        v-for="item in notifications"
                        :key="item.id"
                        :href="item.link || '/notifikasi'"
                        class="flex gap-3 rounded-xl px-2 py-3 transition hover:bg-slate-50"
                    >
                        <span
                            class="flex size-9 shrink-0 items-center justify-center rounded-xl"
                            :class="
                                item.read_at
                                    ? 'bg-slate-100 text-slate-500'
                                    : 'bg-brand-500/10 text-brand-400'
                            "
                        >
                            <component
                                :is="notificationIcon[item.type] || Bell"
                                class="size-4"
                            />
                        </span>
                        <div class="min-w-0">
                            <p
                                class="truncate text-xs font-bold text-slate-900"
                            >
                                {{ item.title }}
                            </p>
                            <p
                                class="mt-0.5 line-clamp-2 text-[11px] leading-4 text-slate-500"
                            >
                                {{ item.body }}
                            </p>
                            <p class="mt-1 text-[10px] text-slate-500">
                                {{
                                    new Date(
                                        item.created_at,
                                    ).toLocaleDateString('id-ID', {
                                        day: 'numeric',
                                        month: 'short',
                                    })
                                }}
                            </p>
                        </div>
                    </Link>
                    <p
                        v-if="!notifications.length"
                        class="py-8 text-center text-sm text-slate-500"
                    >
                        Belum ada aktivitas.
                    </p>
                </div>
                <Link
                    :href="'/profil/' + $page.props.auth.user.id"
                    class="btn-secondary mt-5 w-full !py-2.5 !text-xs"
                >
                    Lihat Profil Saya <ArrowRight class="size-3.5" />
                </Link>
            </aside>
        </div>
    </div>
</template>
