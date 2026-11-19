<script setup lang="ts">
import { computed, ref } from 'vue';
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import {
    BriefcaseBusiness,
    Camera,
    Code2,
    Globe,
    MapPin,
    Palette,
    Pencil,
    Save,
    Sparkles,
    Users,
    X,
} from '@lucide/vue';
import ArtworkCard from '@/components/site/ArtworkCard.vue';
import EmptyState from '@/components/site/EmptyState.vue';
import ProjectCard from '@/components/site/ProjectCard.vue';

const props = defineProps<{
    profile: any;
    collaborations: any[];
    isOwn: boolean;
}>();

const page = usePage<any>();
const errors = computed(() => page.props.errors || {});
const activeTab = ref<'projects' | 'artworks' | 'collaborations'>('projects');
const editing = ref(false);

const form = ref({
    name: props.profile.name,
    email: props.profile.email,
    expertise: props.profile.expertise || '',
    skills: (props.profile.skills || []).join(', '),
    bio: props.profile.bio || '',
    location: props.profile.location || '',
    website: props.profile.website || '',
    github: props.profile.github || '',
    instagram: props.profile.instagram || '',
    dribbble: props.profile.dribbble || '',
});

const save = () => {
    const data: any = {
        ...form.value,
        skills: form.value.skills
            .split(',')
            .map((s: string) => s.trim())
            .filter(Boolean),
    };
    const file =
        document.querySelector<HTMLInputElement>('#profile-avatar')?.files?.[0];
    if (file) data.avatar = file;
    router.patch('/profil', data, {
        forceFormData: !!file,
        preserveScroll: true,
        onSuccess: () => (editing.value = false),
    });
};
</script>

<template>
    <Head :title="`Profil ${profile.name}`" />

    <div class="site-container py-10">
        <!-- Cover -->
        <div
            class="brand-gradient relative h-40 overflow-hidden rounded-3xl sm:h-52"
        >
            <div
                class="absolute -top-20 -left-10 size-64 rounded-full bg-white/15 blur-2xl"
            ></div>
            <div
                class="absolute right-10 -bottom-24 size-72 rounded-full bg-blue-400/25 blur-3xl"
            ></div>
            <div
                class="absolute right-6 bottom-5 flex items-center gap-2 text-white/70"
            >
                <Sparkles class="size-4" /> Kreator KolabKreatif
            </div>
        </div>

        <div class="grid gap-8 lg:grid-cols-[320px_1fr]">
            <!-- Identity sidebar -->
            <aside class="-mt-16 lg:-mt-20">
                <div class="card-soft relative p-6 pt-16 text-center">
                    <img
                        :src="profile.avatar_url"
                        :alt="profile.name"
                        class="absolute -top-14 left-1/2 size-28 -translate-x-1/2 rounded-2xl border-4 border-white object-cover shadow-lg"
                    />

                    <div class="flex items-center justify-center gap-2">
                        <h1 class="text-xl font-extrabold text-slate-900">
                            {{ profile.name }}
                        </h1>
                        <span
                            class="flex size-5 items-center justify-center rounded-full bg-brand-500/15 text-brand-400"
                            ><Sparkles class="size-3"
                        /></span>
                    </div>
                    <p class="mt-1 text-sm font-semibold text-brand-400">
                        {{ profile.expertise || 'Kreator' }}
                    </p>
                    <p
                        v-if="profile.location"
                        class="mt-2 flex items-center justify-center gap-1 text-xs text-slate-500"
                    >
                        <MapPin class="size-3.5" /> {{ profile.location }}
                    </p>

                    <p
                        v-if="profile.bio"
                        class="mt-5 text-[13px] leading-6 text-slate-600"
                    >
                        {{ profile.bio }}
                    </p>

                    <div
                        v-if="profile.skills?.length"
                        class="mt-5 flex flex-wrap justify-center gap-1.5"
                    >
                        <span
                            v-for="skill in profile.skills"
                            :key="skill"
                            class="rounded-lg bg-slate-100 px-2.5 py-1 text-[10px] font-semibold text-slate-600"
                            >{{ skill }}</span
                        >
                    </div>

                    <button
                        v-if="isOwn"
                        type="button"
                        class="btn-secondary mt-6 w-full !py-2.5 !text-xs"
                        @click="editing = !editing"
                    >
                        <component
                            :is="editing ? X : Pencil"
                            class="size-3.5"
                        />
                        {{ editing ? 'Tutup Editor' : 'Edit Profil' }}
                    </button>

                    <div
                        v-if="
                            profile.website ||
                            profile.github ||
                            profile.instagram ||
                            profile.dribbble
                        "
                        class="mt-6 flex justify-center gap-2 border-t border-slate-200 pt-5"
                    >
                        <a
                            v-if="profile.website"
                            :href="profile.website"
                            target="_blank"
                            rel="noreferrer"
                            class="flex size-9 items-center justify-center rounded-lg bg-slate-50 text-slate-500 hover:bg-brand-500/10 hover:text-brand-400"
                            aria-label="Website"
                            ><Palette class="size-4"
                        /></a>
                        <a
                            v-if="profile.github"
                            :href="profile.github"
                            target="_blank"
                            rel="noreferrer"
                            class="flex size-9 items-center justify-center rounded-lg bg-slate-50 text-slate-500 hover:bg-brand-500/10 hover:text-brand-400"
                            aria-label="GitHub"
                            ><Code2 class="size-4"
                        /></a>
                        <a
                            v-if="profile.instagram"
                            :href="profile.instagram"
                            target="_blank"
                            rel="noreferrer"
                            class="flex size-9 items-center justify-center rounded-lg bg-slate-50 text-slate-500 hover:bg-brand-500/10 hover:text-brand-400"
                            aria-label="Instagram"
                            ><Camera class="size-4"
                        /></a>
                        <a
                            v-if="profile.dribbble"
                            :href="profile.dribbble"
                            target="_blank"
                            rel="noreferrer"
                            class="flex size-9 items-center justify-center rounded-lg bg-slate-50 text-slate-500 hover:bg-brand-500/10 hover:text-brand-400"
                            aria-label="Dribbble"
                            ><Globe class="size-4"
                        /></a>
                    </div>
                </div>

                <div
                    class="card-soft mt-6 grid grid-cols-3 divide-x divide-slate-200 p-4 text-center"
                >
                    <div>
                        <p class="text-lg font-extrabold text-slate-900">
                            {{ profile.projects.length }}
                        </p>
                        <p class="text-[10px] text-slate-500">Proyek</p>
                    </div>
                    <div>
                        <p class="text-lg font-extrabold text-slate-900">
                            {{ profile.artworks.length }}
                        </p>
                        <p class="text-[10px] text-slate-500">Karya</p>
                    </div>
                    <div>
                        <p class="text-lg font-extrabold text-slate-900">
                            {{ collaborations.length }}
                        </p>
                        <p class="text-[10px] text-slate-500">Kolaborasi</p>
                    </div>
                </div>
            </aside>

            <!-- Main -->
            <div class="min-w-0 pt-6 lg:pt-0">
                <!-- Edit form -->
                <form
                    v-if="isOwn && editing"
                    class="card-soft mb-8 p-6"
                    @submit.prevent="save"
                >
                    <h2
                        class="mb-5 flex items-center gap-2 text-base font-bold text-slate-900"
                    >
                        <Pencil class="size-4 text-brand-400" /> Edit Profil
                    </h2>
                    <div class="grid gap-4 sm:grid-cols-2">
                        <div>
                            <label class="field-label">Nama</label>
                            <input v-model="form.name" class="field-input" />
                            <p
                                v-if="errors.name"
                                class="mt-1 text-xs text-red-600"
                            >
                                {{ errors.name }}
                            </p>
                        </div>
                        <div>
                            <label class="field-label">Email</label>
                            <input
                                v-model="form.email"
                                type="email"
                                class="field-input"
                            />
                            <p
                                v-if="errors.email"
                                class="mt-1 text-xs text-red-600"
                            >
                                {{ errors.email }}
                            </p>
                        </div>
                        <div>
                            <label class="field-label">Bidang Keahlian</label>
                            <input
                                v-model="form.expertise"
                                class="field-input"
                            />
                        </div>
                        <div>
                            <label class="field-label">Lokasi</label>
                            <input
                                v-model="form.location"
                                class="field-input"
                            />
                        </div>
                        <div>
                            <label class="field-label"
                                >Keahlian (pisahkan dengan koma)</label
                            >
                            <input
                                v-model="form.skills"
                                class="field-input"
                                placeholder="Figma, UI Design, Laravel"
                            />
                        </div>
                        <div>
                            <label class="field-label">Foto Profil</label>
                            <input
                                id="profile-avatar"
                                type="file"
                                accept="image/*"
                                class="field-input !py-2.5 !text-xs"
                            />
                        </div>
                        <div class="sm:col-span-2">
                            <label class="field-label">Bio</label>
                            <textarea
                                v-model="form.bio"
                                rows="3"
                                class="field-input resize-none"
                            ></textarea>
                        </div>
                        <div>
                            <label class="field-label">Website</label
                            ><input
                                v-model="form.website"
                                class="field-input"
                            />
                        </div>
                        <div>
                            <label class="field-label">GitHub</label
                            ><input v-model="form.github" class="field-input" />
                        </div>
                        <div>
                            <label class="field-label">Instagram</label
                            ><input
                                v-model="form.instagram"
                                class="field-input"
                            />
                        </div>
                        <div>
                            <label class="field-label">Dribbble</label
                            ><input
                                v-model="form.dribbble"
                                class="field-input"
                            />
                        </div>
                    </div>
                    <button
                        type="submit"
                        class="btn-primary mt-5 !py-2.5 !text-xs"
                    >
                        <Save class="size-3.5" /> Simpan Perubahan
                    </button>
                </form>

                <!-- Tabs -->
                <div
                    class="no-scrollbar mb-6 flex gap-1 overflow-x-auto rounded-xl border border-slate-200 bg-white p-1"
                >
                    <button
                        v-for="tab in [
                            {
                                key: 'projects',
                                label: 'Proyek',
                                icon: BriefcaseBusiness,
                                count: profile.projects.length,
                            },
                            {
                                key: 'artworks',
                                label: 'Karya',
                                icon: Camera,
                                count: profile.artworks.length,
                            },
                            {
                                key: 'collaborations',
                                label: 'Kolaborasi',
                                icon: Users,
                                count: collaborations.length,
                            },
                        ]"
                        :key="tab.key"
                        type="button"
                        class="flex shrink-0 items-center gap-2 rounded-lg px-4 py-2.5 text-xs font-bold transition"
                        :class="
                            activeTab === tab.key
                                ? 'bg-brand-600 text-white shadow-sm'
                                : 'text-slate-500 hover:bg-slate-50'
                        "
                        @click="activeTab = tab.key as any"
                    >
                        <component :is="tab.icon" class="size-3.5" />
                        {{ tab.label }} ({{ tab.count }})
                    </button>
                </div>

                <div
                    v-if="activeTab === 'projects'"
                    class="grid gap-5 sm:grid-cols-2"
                >
                    <ProjectCard
                        v-for="project in profile.projects"
                        :key="project.id"
                        :project="project"
                    />
                    <EmptyState
                        v-if="!profile.projects.length"
                        title="Belum ada proyek"
                        description="Proyek yang dibuat akan tampil di sini."
                    />
                </div>

                <div
                    v-else-if="activeTab === 'artworks'"
                    class="grid gap-5 sm:grid-cols-2 xl:grid-cols-3"
                >
                    <ArtworkCard
                        v-for="artwork in profile.artworks"
                        :key="artwork.id"
                        :artwork="artwork"
                    />
                    <EmptyState
                        v-if="!profile.artworks.length"
                        title="Belum ada karya"
                        description="Karya yang dipublikasikan akan tampil di sini."
                    />
                </div>

                <div v-else class="space-y-3">
                    <div
                        v-for="item in collaborations"
                        :key="item.id"
                        class="card-soft flex items-center gap-4 p-4"
                    >
                        <span
                            class="flex size-12 shrink-0 items-center justify-center rounded-xl text-sm font-extrabold text-slate-900"
                            :style="{
                                background: `linear-gradient(135deg, ${item.project.category?.color || '#8b5cf6'}, #3b82f6)`,
                            }"
                        >
                            {{ (item.project.title || 'K').charAt(0) }}
                        </span>
                        <div class="min-w-0 flex-1">
                            <Link
                                :href="'/proyek/' + item.project.slug"
                                class="truncate text-sm font-bold text-slate-900 hover:text-brand-400"
                                >{{ item.project.title }}</Link
                            >
                            <p class="mt-0.5 text-xs text-slate-500">
                                {{ item.role || 'Anggota Tim' }} ·
                                {{ item.project.category?.name || 'Proyek' }}
                            </p>
                        </div>
                        <span
                            class="rounded-lg bg-emerald-500/10 px-2.5 py-1 text-[10px] font-bold text-emerald-700"
                            >Aktif</span
                        >
                    </div>
                    <EmptyState
                        v-if="!collaborations.length"
                        title="Belum ada kolaborasi"
                        description="Proyek yang kamu ikuti akan tampil di sini."
                    />
                </div>
            </div>
        </div>
    </div>
</template>
