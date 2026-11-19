<script setup lang="ts">
import { Link } from '@inertiajs/vue3';
import { ArrowLeft, Sparkles } from '@lucide/vue';

defineProps<{
    title?: string;
    description?: string;
}>();
</script>

<template>
    <div class="flex min-h-svh bg-slate-50">
        <!-- Brand panel -->
        <div
            class="brand-gradient relative hidden w-1/2 overflow-hidden p-12 text-white lg:flex lg:flex-col lg:justify-between"
        >
            <div
                class="absolute -top-24 -left-24 size-96 rounded-full bg-white/10 blur-3xl"
            ></div>
            <div
                class="absolute -right-16 -bottom-32 size-[28rem] rounded-full bg-blue-400/20 blur-3xl"
            ></div>

            <Link
                href="/"
                class="relative z-10 flex items-center gap-2.5 text-xl font-extrabold"
            >
                <span
                    class="flex size-10 items-center justify-center rounded-xl bg-white/20 backdrop-blur"
                    ><Sparkles class="size-5"
                /></span>
                Kolab<span class="text-brand-200">Kreatif</span>
            </Link>

            <div class="relative z-10 max-w-md">
                <span
                    class="inline-flex items-center gap-2 rounded-full bg-white/15 px-4 py-2 text-xs font-bold backdrop-blur"
                >
                    <Sparkles class="size-3.5" /> Ruang untuk ide-ide besar
                </span>
                <h2
                    class="mt-6 text-4xl leading-tight font-extrabold tracking-tight"
                >
                    Berkarya lebih baik, bersama.
                </h2>
                <p class="mt-5 text-[15px] leading-8 text-white/80">
                    Temukan rekan kolaborasi, bagikan ide, bangun tim, dan
                    pamerkan hasil karya kamu kepada komunitas kreatif.
                </p>
                <div class="mt-10 flex gap-8">
                    <div>
                        <p class="text-2xl font-extrabold">10+</p>
                        <p class="text-xs text-white/70">Kreator aktif</p>
                    </div>
                    <div>
                        <p class="text-2xl font-extrabold">9+</p>
                        <p class="text-xs text-white/70">Proyek kreatif</p>
                    </div>
                    <div>
                        <p class="text-2xl font-extrabold">12+</p>
                        <p class="text-xs text-white/70">Karya inspiratif</p>
                    </div>
                </div>
            </div>

            <p class="relative z-10 text-xs text-white/60">
                © {{ new Date().getFullYear() }} KolabKreatif. Dibuat untuk
                kreator.
            </p>
        </div>

        <!-- Form panel -->
        <div
            class="flex w-full flex-col items-center justify-center px-6 py-12 lg:w-1/2"
        >
            <div class="animate-fade-up w-full max-w-md">
                <Link
                    href="/"
                    class="mb-8 inline-flex items-center gap-2 text-sm font-semibold text-slate-500 hover:text-brand-400 lg:hidden"
                >
                    <ArrowLeft class="size-4" /> Kembali ke beranda
                </Link>

                <div class="mb-8">
                    <Link
                        href="/"
                        class="mb-6 flex items-center gap-2.5 lg:hidden"
                    >
                        <span
                            class="brand-gradient flex size-9 items-center justify-center rounded-xl text-white"
                            ><Sparkles class="size-4"
                        /></span>
                        <span class="text-lg font-extrabold text-slate-900"
                            >Kolab<span class="gradient-text"
                                >Kreatif</span
                            ></span
                        >
                    </Link>
                    <h1
                        class="text-2xl font-extrabold tracking-tight text-slate-900 sm:text-3xl"
                    >
                        {{ title }}
                    </h1>
                    <p
                        v-if="description"
                        class="mt-2 text-sm leading-6 text-slate-500"
                    >
                        {{ description }}
                    </p>
                </div>

                <slot />

                <p class="mt-8 text-center text-xs text-slate-500">
                    KolabKreatif · Platform Kolaborasi Kreatif
                </p>
            </div>
        </div>
    </div>
</template>
