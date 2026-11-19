<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import {
    ArrowRight,
    Compass,
    HeartHandshake,
    Lightbulb,
    Sparkles,
    Target,
    Users,
} from '@lucide/vue';
import PageBanner from '@/components/site/PageBanner.vue';
import SectionHeading from '@/components/site/SectionHeading.vue';

defineProps<{
    stats: { projects: number; creators: number; artworks: number };
    team: any[];
}>();

const values = [
    {
        icon: Lightbulb,
        title: 'Kreativitas Tanpa Batas',
        description:
            'Setiap ide berharga. Kami memberi ruang bagi eksperimen dan hal-hal baru.',
    },
    {
        icon: HeartHandshake,
        title: 'Kolaborasi yang Setara',
        description:
            'Semua kreator punya suara yang sama, apa pun latar belakang dan keahliannya.',
    },
    {
        icon: Target,
        title: 'Pertumbuhan Bersama',
        description:
            'Kami percaya karya terbaik lahir ketika saling belajar dan menginspirasi.',
    },
];
</script>

<template>
    <Head title="Tentang Kami" />

    <PageBanner
        eyebrow="Tentang Kami"
        title="Membangun ruang bagi ide-ide yang ingin bergerak"
        description="KolabKreatif lahir dari keyakinan bahwa karya luar biasa jarang lahir sendirian. Di sini, kreator bertemu, ide bertumbuh, dan kolaborasi dimulai."
    />

    <!-- Story -->
    <section class="site-container section-pad">
        <div class="grid items-center gap-12 lg:grid-cols-2">
            <div>
                <SectionHeading
                    eyebrow="Cerita Kami"
                    title="Dari ide sederhana menjadi ruang kolaborasi"
                />
                <div
                    class="mt-6 space-y-4 text-[14px] leading-8 text-slate-600"
                >
                    <p>
                        Banyak kreator hebat memiliki ide yang berhenti di
                        kepala—bukan karena kurang bakat, tetapi karena sulit
                        menemukan orang yang tepat untuk mewujudkannya.
                    </p>
                    <p>
                        KolabKreatif hadir untuk menjembatani jarak itu. Kami
                        membuat platform di mana mahasiswa, desainer,
                        programmer, fotografer, penulis, ilustrator, dan kreator
                        lainnya bisa saling menemukan, berbagi ide, dan
                        membangun sesuatu bersama.
                    </p>
                    <p>
                        Lebih dari sekadar daftar proyek, kami ingin membangun
                        komunitas yang saling mendukung—tempat di mana setiap
                        kontribusi dihargai dan setiap karya punya cerita.
                    </p>
                </div>
                <Link href="/proyek" class="btn-primary mt-8">
                    Mulai Jelajahi <ArrowRight class="size-4" />
                </Link>
            </div>

            <div class="relative">
                <div
                    class="absolute -inset-5 rounded-[40px] bg-gradient-to-tr from-brand-500/15 to-teal-500/15 blur-2xl"
                ></div>
                <div class="relative grid grid-cols-2 gap-4">
                    <div
                        v-for="item in [
                            {
                                value: stats.creators,
                                label: 'Kreator Bergabung',
                                icon: Users,
                                color: 'from-brand-500 to-brand-600',
                            },
                            {
                                value: stats.projects,
                                label: 'Proyek Dibuat',
                                icon: Compass,
                                color: 'from-teal-500 to-teal-600',
                            },
                            {
                                value: stats.artworks,
                                label: 'Karya Dipamerkan',
                                icon: Sparkles,
                                color: 'from-blue-500 to-indigo-600',
                            },
                            {
                                value: '100%',
                                label: 'Untuk Komunitas',
                                icon: HeartHandshake,
                                color: 'from-indigo-500 to-blue-600',
                            },
                        ]"
                        :key="item.label"
                        class="card-soft flex flex-col p-5"
                    >
                        <span
                            :class="[
                                'flex size-10 items-center justify-center rounded-xl bg-gradient-to-br text-white',
                                item.color,
                            ]"
                        >
                            <component :is="item.icon" class="size-4" />
                        </span>
                        <p class="mt-4 text-2xl font-extrabold text-slate-900">
                            {{ item.value }}
                        </p>
                        <p class="text-xs text-slate-500">{{ item.label }}</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Values -->
    <section class="section-pad border-y border-slate-200/70 bg-white">
        <div class="site-container">
            <SectionHeading
                eyebrow="Nilai Kami"
                title="Apa yang kami yakini"
                align="center"
            />
            <div class="mt-12 grid gap-6 md:grid-cols-3">
                <div
                    v-for="value in values"
                    :key="value.title"
                    class="card-soft p-7"
                >
                    <span
                        class="flex size-12 items-center justify-center rounded-2xl bg-brand-500/10 text-brand-400"
                        ><component :is="value.icon" class="size-5"
                    /></span>
                    <h3 class="mt-5 text-base font-bold text-slate-900">
                        {{ value.title }}
                    </h3>
                    <p class="mt-2 text-[13px] leading-6 text-slate-500">
                        {{ value.description }}
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- Team -->
    <section class="site-container section-pad">
        <SectionHeading
            eyebrow="Tim KolabKreatif"
            title="Wajah di balik platform ini"
            description="Kami adalah sekumpulan kreator yang percaya pada kekuatan kolaborasi."
            align="center"
        />
        <div class="mt-12 grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
            <div
                v-for="member in team"
                :key="member.id"
                class="card-soft overflow-hidden text-center"
            >
                <div class="brand-gradient h-24"></div>
                <img
                    :src="member.avatar_url"
                    :alt="member.name"
                    class="-mt-10 size-20 rounded-2xl border-4 border-white object-cover shadow-md"
                />
                <div class="p-5 pt-3">
                    <h3 class="text-sm font-bold text-slate-900">
                        {{ member.name }}
                    </h3>
                    <p class="mt-1 text-xs font-semibold text-brand-400">
                        {{ member.expertise || 'Tim KolabKreatif' }}
                    </p>
                    <p
                        class="mt-3 line-clamp-2 text-[11px] leading-5 text-slate-500"
                    >
                        {{ member.bio }}
                    </p>
                </div>
            </div>
        </div>
    </section>

    <section class="site-container pb-20">
        <div
            class="brand-gradient relative overflow-hidden rounded-3xl px-6 py-14 text-center text-white"
        >
            <div
                class="absolute -top-20 -left-16 size-64 rounded-full bg-white/10 blur-2xl"
            ></div>
            <div
                class="absolute -right-10 -bottom-24 size-72 rounded-full bg-blue-400/25 blur-3xl"
            ></div>
            <div class="relative">
                <h2 class="text-3xl font-extrabold sm:text-4xl">
                    Mari ciptakan sesuatu bersama.
                </h2>
                <p class="mx-auto mt-4 max-w-xl text-sm text-white/80">
                    Tempatmu sudah menanti. Bergabunglah dan temukan kreator
                    yang sevisi denganmu.
                </p>
                <Link
                    href="/register"
                    class="mt-8 inline-flex items-center gap-2 rounded-xl bg-white px-6 py-3.5 text-sm font-bold text-brand-400 shadow-lg transition hover:-translate-y-0.5"
                >
                    Gabung KolabKreatif <ArrowRight class="size-4" />
                </Link>
            </div>
        </div>
    </section>
</template>
