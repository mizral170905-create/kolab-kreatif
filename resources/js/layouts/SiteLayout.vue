<script setup lang="ts">
import { ref, watch } from 'vue';
import { Link, router, usePage } from '@inertiajs/vue3';
import { toast } from 'vue-sonner';
import {
    ArrowRight,
    Bell,
    BriefcaseBusiness,
    Camera,
    ChevronDown,
    Compass,
    Frame,
    Globe,
    LayoutDashboard,
    LogOut,
    Menu,
    MessageCircle,
    Plus,
    Settings,
    Sparkles,
    User,
    X,
} from '@lucide/vue';
import { Toaster } from '@/components/ui/sonner';

const page = usePage<any>();
const mobileOpen = ref(false);
const userOpen = ref(false);

const navLinks = [
    { label: 'Beranda', href: '/' },
    { label: 'Jelajahi Proyek', href: '/proyek' },
    { label: 'Galeri Karya', href: '/galeri' },
    { label: 'Komunitas', href: '/komunitas' },
    { label: 'Tentang Kami', href: '/tentang-kami' },
];

const isActive = (href: string) =>
    href === '/' ? page.url === '/' : page.url.startsWith(href);

const closeMenus = () => {
    mobileOpen.value = false;
    userOpen.value = false;
};

const logout = () => {
    router.post('/logout', {}, { onFinish: closeMenus });
};

watch(
    () => page.props.flash,
    (flash: any) => {
        if (flash?.success) toast.success(flash.success);
        if (flash?.error) toast.error(flash.error);
    },
    { immediate: true },
);

watch(() => page.url, closeMenus);
</script>

<template>
    <div class="flex min-h-screen flex-col bg-slate-50">
        <!-- Top strip -->
        <div
            class="brand-gradient relative overflow-hidden py-2 text-center text-[11px] font-medium tracking-wide text-white/90"
        >
            <div class="relative z-10">
                ✨ Ruang untuk ide-ide besar — temukan timmu, wujudkan karyamu.
            </div>
            <div
                class="absolute -top-16 -left-10 size-40 rounded-full bg-white/10 blur-2xl"
            ></div>
            <div
                class="absolute -right-10 -bottom-20 size-48 rounded-full bg-blue-400/20 blur-2xl"
            ></div>
        </div>

        <!-- Navbar -->
        <header class="glass sticky top-0 z-50 border-b border-slate-200/70">
            <div
                class="site-container flex h-[72px] items-center justify-between gap-6"
            >
                <Link
                    href="/"
                    class="group flex shrink-0 items-center gap-2.5"
                    @click="closeMenus"
                >
                    <span
                        class="brand-gradient flex size-10 items-center justify-center rounded-xl text-white shadow-lg shadow-brand-500/25 transition-transform duration-300 group-hover:rotate-6"
                    >
                        <Sparkles class="size-5" :stroke-width="2.2" />
                    </span>
                    <span
                        class="text-[19px] font-extrabold tracking-tight text-slate-900"
                    >
                        Kolab<span class="gradient-text">Kreatif</span>
                    </span>
                </Link>

                <nav class="hidden items-center gap-1 lg:flex">
                    <Link
                        v-for="link in navLinks"
                        :key="link.href"
                        :href="link.href"
                        class="relative rounded-lg px-3.5 py-2 text-[13px] font-semibold transition-colors"
                        :class="
                            isActive(link.href)
                                ? 'text-brand-400'
                                : 'text-slate-600 hover:text-brand-400'
                        "
                    >
                        {{ link.label }}
                        <span
                            v-if="isActive(link.href)"
                            class="absolute inset-x-3 -bottom-[13px] h-0.5 rounded-full bg-brand-600"
                        ></span>
                    </Link>
                </nav>

                <div class="hidden items-center gap-2 lg:flex">
                    <template v-if="page.props.auth.user">
                        <Link
                            href="/notifikasi"
                            class="relative flex size-10 items-center justify-center rounded-xl text-slate-500 transition-colors hover:bg-brand-500/10 hover:text-brand-400"
                            aria-label="Notifikasi"
                        >
                            <Bell class="size-[18px]" />
                            <span
                                v-if="page.props.unreadNotifications > 0"
                                class="animate-soft-pulse absolute -top-0.5 -right-0.5 flex min-w-4 items-center justify-center rounded-full bg-brand-600 px-1 text-[10px] font-bold text-white ring-2 ring-white"
                            >
                                {{ page.props.unreadNotifications }}
                            </span>
                        </Link>

                        <div class="relative">
                            <button
                                type="button"
                                class="flex items-center gap-2 rounded-xl border border-slate-200 py-1.5 pr-2.5 pl-1.5 transition-colors hover:border-brand-500/30 hover:bg-brand-500/10"
                                @click="userOpen = !userOpen"
                            >
                                <img
                                    :src="page.props.auth.user.avatar_url"
                                    :alt="page.props.auth.user.name"
                                    class="size-8 rounded-lg object-cover"
                                />
                                <span
                                    class="max-w-24 truncate text-[13px] font-semibold text-slate-800"
                                >
                                    {{
                                        page.props.auth.user.name.split(' ')[0]
                                    }}
                                </span>
                                <ChevronDown class="size-3.5 text-slate-500" />
                            </button>

                            <Transition
                                enter-active-class="transition duration-150 ease-out"
                                enter-from-class="-translate-y-1 opacity-0"
                                leave-active-class="transition duration-100 ease-in"
                                leave-to-class="-translate-y-1 opacity-0"
                            >
                                <div
                                    v-if="userOpen"
                                    class="absolute top-full right-0 z-50 mt-2 w-56 overflow-hidden rounded-2xl border border-slate-200 bg-white p-1.5 shadow-xl shadow-slate-900/10"
                                    @click="userOpen = false"
                                >
                                    <div
                                        class="border-b border-slate-200 px-3 py-2.5"
                                    >
                                        <p
                                            class="truncate text-sm font-semibold text-slate-900"
                                        >
                                            {{ page.props.auth.user.name }}
                                        </p>
                                        <p
                                            class="truncate text-xs text-slate-500"
                                        >
                                            {{ page.props.auth.user.email }}
                                        </p>
                                    </div>
                                    <Link
                                        :href="
                                            '/profil/' + page.props.auth.user.id
                                        "
                                        class="flex items-center gap-2.5 rounded-lg px-3 py-2 text-sm text-slate-600 hover:bg-brand-500/10 hover:text-brand-400"
                                    >
                                        <User class="size-4" /> Profil Saya
                                    </Link>
                                    <Link
                                        href="/dashboard"
                                        class="flex items-center gap-2.5 rounded-lg px-3 py-2 text-sm text-slate-600 hover:bg-brand-500/10 hover:text-brand-400"
                                    >
                                        <LayoutDashboard class="size-4" />
                                        Dashboard
                                    </Link>
                                    <Link
                                        href="/settings/profile"
                                        class="flex items-center gap-2.5 rounded-lg px-3 py-2 text-sm text-slate-600 hover:bg-brand-500/10 hover:text-brand-400"
                                    >
                                        <Settings class="size-4" /> Pengaturan
                                    </Link>
                                    <button
                                        type="button"
                                        class="flex w-full items-center gap-2.5 rounded-lg px-3 py-2 text-sm text-red-600 hover:bg-red-50"
                                        @click="logout"
                                    >
                                        <LogOut class="size-4" /> Keluar
                                    </button>
                                </div>
                            </Transition>
                        </div>

                        <Link
                            href="/proyek/buat"
                            class="btn-primary !px-4 !py-2.5"
                        >
                            <Plus class="size-4" /> Buat Proyek
                        </Link>
                    </template>
                    <template v-else>
                        <Link href="/login" class="btn-ghost">Masuk</Link>
                        <Link
                            href="/register"
                            class="btn-primary !px-4 !py-2.5"
                        >
                            Daftar Gratis <ArrowRight class="size-4" />
                        </Link>
                    </template>
                </div>

                <button
                    type="button"
                    class="flex size-10 items-center justify-center rounded-xl border border-slate-200 text-slate-600 lg:hidden"
                    aria-label="Buka menu"
                    @click="mobileOpen = !mobileOpen"
                >
                    <X v-if="mobileOpen" class="size-5" />
                    <Menu v-else class="size-5" />
                </button>
            </div>

            <!-- Mobile nav -->
            <Transition
                enter-active-class="transition duration-200 ease-out"
                enter-from-class="-translate-y-2 opacity-0"
                leave-active-class="transition duration-150 ease-in"
                leave-to-class="-translate-y-2 opacity-0"
            >
                <div
                    v-if="mobileOpen"
                    class="border-t border-slate-200 bg-white px-5 py-4 lg:hidden"
                >
                    <nav class="flex flex-col gap-1">
                        <Link
                            v-for="link in navLinks"
                            :key="link.href"
                            :href="link.href"
                            class="rounded-xl px-4 py-3 text-sm font-semibold"
                            :class="
                                isActive(link.href)
                                    ? 'bg-brand-500/10 text-brand-400'
                                    : 'text-slate-600 hover:bg-slate-50'
                            "
                            @click="closeMenus"
                        >
                            {{ link.label }}
                        </Link>
                    </nav>
                    <div
                        class="mt-3 flex flex-col gap-2 border-t border-slate-200 pt-4"
                    >
                        <template v-if="page.props.auth.user">
                            <Link
                                href="/dashboard"
                                class="btn-secondary w-full"
                                @click="closeMenus"
                            >
                                <LayoutDashboard class="size-4" /> Dashboard
                            </Link>
                            <Link
                                href="/notifikasi"
                                class="btn-secondary w-full"
                                @click="closeMenus"
                            >
                                <Bell class="size-4" /> Notifikasi
                                <span
                                    v-if="page.props.unreadNotifications > 0"
                                    class="ml-1 rounded-full bg-brand-600 px-2 py-0.5 text-[10px] text-white"
                                    >{{ page.props.unreadNotifications }}</span
                                >
                            </Link>
                            <Link
                                href="/proyek/buat"
                                class="btn-primary w-full"
                                @click="closeMenus"
                            >
                                <Plus class="size-4" /> Buat Proyek
                            </Link>
                            <button
                                type="button"
                                class="btn-ghost w-full text-red-600"
                                @click="logout"
                            >
                                <LogOut class="size-4" /> Keluar
                            </button>
                        </template>
                        <template v-else>
                            <Link
                                href="/login"
                                class="btn-secondary w-full"
                                @click="closeMenus"
                                >Masuk</Link
                            >
                            <Link
                                href="/register"
                                class="btn-primary w-full"
                                @click="closeMenus"
                                >Daftar Gratis</Link
                            >
                        </template>
                    </div>
                </div>
            </Transition>
        </header>

        <!-- Content -->
        <main class="flex-1">
            <slot />
        </main>

        <!-- Footer -->
        <footer class="relative mt-10 overflow-hidden bg-white text-slate-600">
            <div
                class="absolute top-0 -left-24 size-72 rounded-full bg-brand-600/20 blur-3xl"
            ></div>
            <div
                class="absolute -right-20 bottom-0 size-72 rounded-full bg-teal-600/20 blur-3xl"
            ></div>
            <div
                class="site-container relative grid gap-12 py-16 md:grid-cols-2 lg:grid-cols-5"
            >
                <div class="lg:col-span-2">
                    <div class="flex items-center gap-2.5">
                        <span
                            class="brand-gradient flex size-10 items-center justify-center rounded-xl text-white"
                        >
                            <Sparkles class="size-5" />
                        </span>
                        <span class="text-xl font-extrabold text-slate-900"
                            >Kolab<span class="text-brand-300"
                                >Kreatif</span
                            ></span
                        >
                    </div>
                    <p class="mt-5 max-w-sm text-sm leading-7 text-slate-500">
                        Platform kolaborasi kreatif untuk bertemu, berbagi ide,
                        membangun tim, dan menghasilkan karya luar biasa
                        bersama.
                    </p>
                    <div class="mt-6 flex gap-3">
                        <a
                            href="https://instagram.com"
                            target="_blank"
                            rel="noreferrer"
                            class="flex size-10 items-center justify-center rounded-xl bg-slate-100 text-slate-600 transition hover:bg-brand-600 hover:text-white"
                            aria-label="Instagram"
                            ><Camera class="size-[18px]"
                        /></a>
                        <a
                            href="https://facebook.com"
                            target="_blank"
                            rel="noreferrer"
                            class="flex size-10 items-center justify-center rounded-xl bg-slate-100 text-slate-600 transition hover:bg-brand-600 hover:text-white"
                            aria-label="Facebook"
                            ><Globe class="size-[18px]"
                        /></a>
                        <a
                            href="https://linkedin.com"
                            target="_blank"
                            rel="noreferrer"
                            class="flex size-10 items-center justify-center rounded-xl bg-slate-100 text-slate-600 transition hover:bg-brand-600 hover:text-white"
                            aria-label="LinkedIn"
                            ><BriefcaseBusiness class="size-[18px]"
                        /></a>
                        <a
                            href="https://discord.com"
                            target="_blank"
                            rel="noreferrer"
                            class="flex size-10 items-center justify-center rounded-xl bg-slate-100 text-slate-600 transition hover:bg-brand-600 hover:text-white"
                            aria-label="Discord"
                            ><MessageCircle class="size-[18px]"
                        /></a>
                    </div>
                </div>

                <div>
                    <h4 class="mb-5 text-sm font-bold text-slate-900">
                        Jelajahi
                    </h4>
                    <ul class="space-y-3 text-sm">
                        <li>
                            <Link href="/" class="hover:text-brand-300"
                                >Beranda</Link
                            >
                        </li>
                        <li>
                            <Link href="/proyek" class="hover:text-brand-300"
                                >Proyek Terbaru</Link
                            >
                        </li>
                        <li>
                            <Link href="/galeri" class="hover:text-brand-300"
                                >Galeri Karya</Link
                            >
                        </li>
                        <li>
                            <Link href="/komunitas" class="hover:text-brand-300"
                                >Komunitas</Link
                            >
                        </li>
                    </ul>
                </div>

                <div>
                    <h4 class="mb-5 text-sm font-bold text-slate-900">
                        Kategori
                    </h4>
                    <ul class="space-y-3 text-sm">
                        <li>
                            <Link
                                href="/proyek?category=desain-grafis"
                                class="hover:text-brand-300"
                                >Desain Grafis</Link
                            >
                        </li>
                        <li>
                            <Link
                                href="/proyek?category=pemrograman"
                                class="hover:text-brand-300"
                                >Pemrograman</Link
                            >
                        </li>
                        <li>
                            <Link
                                href="/proyek?category=fotografi"
                                class="hover:text-brand-300"
                                >Fotografi</Link
                            >
                        </li>
                        <li>
                            <Link
                                href="/proyek?category=ilustrasi"
                                class="hover:text-brand-300"
                                >Ilustrasi</Link
                            >
                        </li>
                    </ul>
                </div>

                <div>
                    <h4 class="mb-5 text-sm font-bold text-slate-900">
                        Tentang
                    </h4>
                    <ul class="space-y-3 text-sm">
                        <li>
                            <Link
                                href="/tentang-kami"
                                class="hover:text-brand-300"
                                >Tentang Kami</Link
                            >
                        </li>
                        <li>
                            <Link
                                href="/proyek/buat"
                                class="hover:text-brand-300"
                                >Buat Proyek</Link
                            >
                        </li>
                        <li>
                            <Link
                                href="/galeri/unggah"
                                class="hover:text-brand-300"
                                >Unggah Karya</Link
                            >
                        </li>
                        <li>
                            <a
                                href="mailto:halo@kolabkreatif.test"
                                class="hover:text-brand-300"
                                >Hubungi Kami</a
                            >
                        </li>
                    </ul>
                </div>
            </div>

            <div class="relative border-t border-slate-200">
                <div
                    class="site-container flex flex-col gap-2 py-6 text-xs text-slate-500 sm:flex-row sm:items-center sm:justify-between"
                >
                    <p>
                        © {{ new Date().getFullYear() }} KolabKreatif. Dibuat
                        untuk kreator, oleh kreator.
                    </p>
                    <p class="flex items-center gap-1.5">
                        <Frame class="size-3.5" /> Kolaborasi · Kreativitas ·
                        Komunitas
                    </p>
                </div>
            </div>
        </footer>

        <Toaster position="top-center" rich-colors close-button />
    </div>
</template>
