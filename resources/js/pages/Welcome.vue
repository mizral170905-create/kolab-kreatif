<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import {
    ArrowRight,
    Brush,
    Camera,
    Code2,
    Compass,
    Heart,
    Lightbulb,
    MessageCircle,
    Palette,
    PenLine,
    Search,
    Sparkles,
    Star,
    Target,
    Users,
    Video,
} from '@lucide/vue';
import ArtworkCard from '@/components/site/ArtworkCard.vue';
import HeroIllustration from '@/components/site/HeroIllustration.vue';
import ProjectCard from '@/components/site/ProjectCard.vue';
import SectionHeading from '@/components/site/SectionHeading.vue';

defineProps<{
    stats: {
        projects: number;
        creators: number;
        artworks: number;
        collaborations: number;
    };
    categories: any[];
    projects: any[];
    artworks: any[];
}>();

const categoryIcons: Record<string, any> = {
    'desain-grafis': Palette,
    pemrograman: Code2,
    fotografi: Camera,
    videografi: Video,
    penulisan: PenLine,
    ilustrasi: Brush,
};

const steps = [
    {
        icon: Search,
        title: 'Jelajahi & Temukan',
        description:
            'Cari proyek yang sesuai dengan minat dan keahlianmu, atau temukan kreator yang sevisi.',
        color: 'from-brand-500 to-brand-600',
    },
    {
        icon: Users,
        title: 'Bentuk Tim Impian',
        description:
            'Ajukan diri untuk bergabung atau undang orang lain. Diskusikan ide sebelum mulai berkarya.',
        color: 'from-teal-500 to-teal-600',
    },
    {
        icon: Lightbulb,
        title: 'Karya Bersama',
        description:
            'Kerjakan proyek bersama, pantau perkembangan, dan simpan setiap proses kolaborasi.',
        color: 'from-blue-500 to-indigo-600',
    },
    {
        icon: Star,
        title: 'Pamerkan Hasil',
        description:
            'Unggah karyamu ke galeri, dapatkan apresiasi, dan bangun portofolio yang menginspirasi.',
        color: 'from-indigo-500 to-blue-600',
    },
];

const testimonials = [
    {
        quote: 'Awalnya cuma cari teman buat bantu desain, eh malah dapet tim yang solid dan karya kami tampil di pameran kampus.',
        name: 'Salsa Amelia',
        role: 'Ilustrator',
        avatar: 'https://i.pravatar.cc/120?img=45',
    },
    {
        quote: 'KolabKreatif bikin proses nyari kolaborasi jadi jauh lebih gampang. Sekarang ide-ide yang mengendap akhirnya bisa jalan.',
        name: 'Raka Pratama',
        role: 'Frontend Developer',
        avatar: 'https://i.pravatar.cc/120?img=12',
    },
    {
        quote: 'Suka banget sama galerinya. Bisa lihat proses kerja teman-teman dan saling kasih masukan yang membangun.',
        name: 'Citra Maharani',
        role: 'Graphic Designer',
        avatar: 'https://i.pravatar.cc/120?img=32',
    },
];
</script>

<template>
    <Head title="Beranda">
        <meta
            name="description"
            content="KolabKreatif — platform kolaborasi kreatif untuk bertemu, berbagi ide, membangun tim, dan memamerkan karya."
        />
    </Head>

    <!-- Hero -->
    <section
        class="relative overflow-hidden border-b border-brand-500/20 bg-gradient-to-br from-brand-500/10 via-white to-teal-500/10"
    >
        <div
            class="absolute top-10 -left-32 size-96 rounded-full bg-brand-500/20 blur-3xl"
        ></div>
        <div
            class="absolute -right-40 bottom-0 size-[28rem] rounded-full bg-teal-500/20 blur-3xl"
        ></div>
        <div
            class="site-container relative grid items-center gap-12 py-16 lg:grid-cols-2 lg:gap-8 lg:py-24"
        >
            <div class="reveal">
                <span
                    class="inline-flex items-center gap-2 rounded-full border border-brand-500/30 bg-white/80 px-4 py-2 text-xs font-bold text-brand-400 shadow-sm backdrop-blur"
                >
                    <Sparkles class="size-3.5" />
                    Tempat bertemunya ide dan kolaborator
                </span>

                <h1
                    class="mt-6 text-[38px] leading-[1.12] font-extrabold tracking-tight text-slate-900 sm:text-5xl lg:text-[56px]"
                >
                    Berkolaborasi, Berkreasi, dan
                    <span class="gradient-text">Ciptakan Karya Luar Biasa</span>
                </h1>

                <p
                    class="mt-6 max-w-xl text-base leading-8 text-slate-600 sm:text-[17px]"
                >
                    KolabKreatif adalah ruang digital bagi kreator untuk
                    bertemu, bertukar ide, membentuk tim, mengerjakan proyek
                    bersama, dan memamerkan hasil karya kepada dunia.
                </p>

                <div class="mt-8 flex flex-wrap items-center gap-3">
                    <Link
                        href="/proyek"
                        class="btn-primary !px-6 !py-3.5 !text-sm"
                    >
                        Mulai Berkolaborasi <ArrowRight class="size-4" />
                    </Link>
                    <Link
                        href="/galeri"
                        class="btn-secondary !px-6 !py-3.5 !text-sm"
                    >
                        <Compass class="size-4" /> Jelajahi Karya
                    </Link>
                </div>

                <div
                    class="mt-10 flex flex-wrap items-center gap-x-8 gap-y-4 border-t border-slate-200/80 pt-7"
                >
                    <div
                        v-for="item in [
                            { value: stats.projects, label: 'Proyek Aktif' },
                            { value: stats.creators, label: 'Kreator' },
                            { value: stats.artworks, label: 'Karya' },
                            {
                                value: stats.collaborations,
                                label: 'Kolaborasi',
                            },
                        ]"
                        :key="item.label"
                        class="flex items-baseline gap-2"
                    >
                        <span class="text-2xl font-extrabold text-slate-900"
                            >{{ item.value }}+</span
                        >
                        <span class="text-xs font-medium text-slate-500">{{
                            item.label
                        }}</span>
                    </div>
                </div>
            </div>

            <div class="animate-float-slow relative">
                <div
                    class="absolute -inset-6 rounded-[44px] bg-gradient-to-tr from-brand-500/20 to-teal-500/20 blur-2xl"
                ></div>
                <div
                    class="relative rounded-[36px] border border-white bg-white/60 p-3 shadow-2xl shadow-brand-900/10 backdrop-blur"
                >
                    <HeroIllustration />
                </div>
            </div>
        </div>
    </section>

    <!-- Categories -->
    <section class="site-container section-pad">
        <SectionHeading
            eyebrow="Bidang Kreativitas"
            title="Temukan Ruang Kreativitasmu"
            description="Dari desain hingga teknologi, semua bidang kreatif punya tempat di sini. Pilih kategori yang kamu suka dan mulai jelajahi."
            align="center"
        />

        <div class="mt-12 grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-6">
            <Link
                v-for="category in categories"
                :key="category.id"
                :href="'/proyek?category=' + category.slug"
                class="card-soft group flex flex-col items-center px-3 py-6 text-center"
            >
                <span
                    class="flex size-12 items-center justify-center rounded-2xl text-slate-900 shadow-lg transition-transform duration-300 group-hover:scale-110 group-hover:-rotate-6"
                    :style="{
                        background: `linear-gradient(135deg, ${category.color}, ${category.color}cc)`,
                    }"
                >
                    <component
                        :is="categoryIcons[category.slug] || Sparkles"
                        class="size-5"
                    />
                </span>
                <h3 class="mt-4 text-[13px] font-bold text-slate-900">
                    {{ category.name }}
                </h3>
                <p class="mt-1 text-[11px] text-slate-500">
                    {{ category.projects_count }} proyek
                </p>
            </Link>
        </div>
    </section>

    <!-- Latest projects -->
    <section class="border-y border-slate-200/70 bg-white">
        <div class="site-container section-pad">
            <div
                class="flex flex-col gap-6 sm:flex-row sm:items-end sm:justify-between"
            >
                <SectionHeading
                    eyebrow="Proyek Terbaru"
                    title="Ada Proyek yang Menunggumu"
                    description="Temukan proyek yang sedang mencari anggota. Bergabunglah dan jadikan ide itu nyata."
                />
                <Link
                    href="/proyek"
                    class="btn-secondary shrink-0 self-start sm:self-auto"
                >
                    Lihat Semua Proyek <ArrowRight class="size-4" />
                </Link>
            </div>

            <div class="mt-12 grid gap-6 md:grid-cols-2 lg:grid-cols-3">
                <ProjectCard
                    v-for="project in projects"
                    :key="project.id"
                    :project="project"
                />
            </div>
        </div>
    </section>

    <!-- How it works -->
    <section class="site-container section-pad">
        <SectionHeading
            eyebrow="Cara Kerja"
            title="Empat Langkah Menuju Karya Hebat"
            description="Kolaborasi yang mudah, transparan, dan menyenangkan — dari ide pertama sampai karya siap dipamerkan."
            align="center"
        />

        <div class="relative mt-14 grid gap-6 md:grid-cols-2 lg:grid-cols-4">
            <div
                class="absolute top-10 left-1/2 hidden h-0.5 w-[70%] -translate-x-1/2 bg-gradient-to-r from-brand-500/20 via-teal-500/20 to-teal-500/20 lg:block"
            ></div>
            <div
                v-for="(step, index) in steps"
                :key="step.title"
                class="relative"
            >
                <div class="card-soft h-full p-6">
                    <span
                        :class="[
                            'flex size-12 items-center justify-center rounded-2xl bg-gradient-to-br text-white shadow-lg',
                            step.color,
                        ]"
                    >
                        <component :is="step.icon" class="size-5" />
                    </span>
                    <span
                        class="absolute top-5 right-5 text-3xl font-extrabold text-slate-900"
                        >0{{ index + 1 }}</span
                    >
                    <h3 class="mt-5 text-base font-bold text-slate-900">
                        {{ step.title }}
                    </h3>
                    <p class="mt-2 text-[13px] leading-6 text-slate-500">
                        {{ step.description }}
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured artworks -->
    <section class="border-y border-slate-200/70 bg-white">
        <div class="site-container section-pad">
            <div
                class="flex flex-col gap-6 sm:flex-row sm:items-end sm:justify-between"
            >
                <SectionHeading
                    eyebrow="Karya Pilihan"
                    title="Karya yang Layak Kamu Lihat"
                    description="Hasil kolaborasi para kreator yang sudah kami pilih untuk menginspirasimu."
                />
                <Link
                    href="/galeri"
                    class="btn-secondary shrink-0 self-start sm:self-auto"
                >
                    Jelajahi Galeri <ArrowRight class="size-4" />
                </Link>
            </div>

            <div class="mt-12 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
                <ArtworkCard
                    v-for="artwork in artworks"
                    :key="artwork.id"
                    :artwork="artwork"
                />
            </div>
        </div>
    </section>

    <!-- Testimonials -->
    <section class="site-container section-pad">
        <SectionHeading
            eyebrow="Cerita Kreator"
            title="Kata Mereka Tentang KolabKreatif"
            description="Lebih dari sekadar platform, KolabKreatif sudah menjadi tempat lahirnya banyak kolaborasi."
            align="center"
        />

        <div class="mt-12 grid gap-6 md:grid-cols-3">
            <div
                v-for="testimonial in testimonials"
                :key="testimonial.name"
                class="card-soft flex h-full flex-col p-6"
            >
                <div class="flex gap-1 text-teal-700">
                    <Star
                        v-for="i in 5"
                        :key="i"
                        class="size-3.5 fill-current"
                    />
                </div>
                <p class="mt-5 flex-1 text-[14px] leading-7 text-slate-600">
                    “{{ testimonial.quote }}”
                </p>
                <div
                    class="mt-6 flex items-center gap-3 border-t border-slate-200 pt-5"
                >
                    <img
                        :src="testimonial.avatar"
                        :alt="testimonial.name"
                        class="size-10 rounded-full object-cover"
                    />
                    <div>
                        <p class="text-sm font-bold text-slate-900">
                            {{ testimonial.name }}
                        </p>
                        <p class="text-xs text-slate-500">
                            {{ testimonial.role }}
                        </p>
                    </div>
                    <MessageCircle class="ml-auto size-4 text-brand-300" />
                </div>
            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="site-container pb-20">
        <div
            class="brand-gradient relative overflow-hidden rounded-3xl px-6 py-14 text-center shadow-2xl shadow-brand-900/20 sm:px-12"
        >
            <div
                class="absolute -top-20 -left-16 size-64 rounded-full bg-white/10 blur-2xl"
            ></div>
            <div
                class="absolute -right-10 -bottom-24 size-72 rounded-full bg-blue-400/25 blur-3xl"
            ></div>
            <div class="relative">
                <span
                    class="inline-flex items-center gap-2 rounded-full bg-white/15 px-4 py-1.5 text-xs font-bold text-white backdrop-blur"
                >
                    <Target class="size-3.5" /> Siap memulai?
                </span>
                <h2
                    class="mt-5 text-3xl font-extrabold tracking-tight text-white sm:text-4xl"
                >
                    ide terbaik tidak lahir sendiri.
                </h2>
                <p
                    class="mx-auto mt-4 max-w-xl text-sm leading-7 text-white/80"
                >
                    Bergabunglah dengan ratusan kreator yang sudah menemukan tim
                    mereka. Mulai dari satu proyek kecil, ciptakan sesuatu yang
                    luar biasa.
                </p>
                <div class="mt-8 flex flex-wrap justify-center gap-3">
                    <Link
                        href="/register"
                        class="inline-flex items-center gap-2 rounded-xl bg-white px-6 py-3.5 text-sm font-bold text-brand-400 shadow-lg transition hover:-translate-y-0.5 hover:shadow-xl"
                    >
                        Gabung Sekarang <ArrowRight class="size-4" />
                    </Link>
                    <Link
                        href="/tentang-kami"
                        class="inline-flex items-center gap-2 rounded-xl border border-white/40 px-6 py-3.5 text-sm font-bold text-white transition hover:bg-white/10"
                    >
                        Kenali Kami
                    </Link>
                </div>
            </div>
        </div>
    </section>
</template>
