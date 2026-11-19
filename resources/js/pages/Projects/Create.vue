<script setup lang="ts">
import { computed, ref } from 'vue';
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import { ArrowLeft, ImagePlus, Plus, Sparkles, X } from '@lucide/vue';
import PageBanner from '@/components/site/PageBanner.vue';

defineProps<{ categories: any[] }>();

const page = usePage<any>();
const errors = computed(() => page.props.errors || {});

const form = ref({
    title: '',
    description: '',
    category_id: '',
    required_skills: [] as string[],
    skillInput: '',
    team_size: 3,
    deadline: '',
    cover_image: '',
});

const addSkill = () => {
    const value = form.value.skillInput.trim();
    if (value && !form.value.required_skills.includes(value)) {
        form.value.required_skills.push(value);
    }
    form.value.skillInput = '';
};

const submit = () => {
    router.post('/proyek', {
        title: form.value.title,
        description: form.value.description,
        category_id: form.value.category_id,
        required_skills: form.value.required_skills,
        team_size: form.value.team_size,
        deadline: form.value.deadline || null,
        cover_image: form.value.cover_image || null,
    });
};
</script>

<template>
    <Head title="Buat Proyek" />

    <PageBanner
        eyebrow="Buat Proyek Baru"
        title="Wujudkan idemu, ajak kreator lain bergabung"
        description="Ceritakan proyekmu dengan jelas agar orang yang tepat tertarik untuk ikut berkolaborasi."
    />

    <div class="site-container max-w-4xl py-12">
        <Link
            href="/proyek"
            class="mb-6 inline-flex items-center gap-2 text-sm font-semibold text-slate-500 hover:text-brand-400"
        >
            <ArrowLeft class="size-4" /> Kembali ke proyek
        </Link>

        <form class="card-soft p-6 sm:p-8" @submit.prevent="submit">
            <div
                class="mb-8 flex items-center gap-3 border-b border-slate-200 pb-6"
            >
                <span
                    class="flex size-11 items-center justify-center rounded-xl bg-brand-500/10 text-brand-400"
                    ><Sparkles class="size-5"
                /></span>
                <div>
                    <h2 class="text-lg font-bold text-slate-900">
                        Detail Proyek
                    </h2>
                    <p class="text-xs text-slate-500">
                        Semua field bertanda * wajib diisi.
                    </p>
                </div>
            </div>

            <div class="grid gap-6 sm:grid-cols-2">
                <div class="sm:col-span-2">
                    <label class="field-label" for="title">Nama Proyek *</label>
                    <input
                        id="title"
                        v-model="form.title"
                        class="field-input"
                        placeholder="Contoh: Platform Kolaborasi Kreator Lokal"
                    />
                    <p v-if="errors.title" class="mt-1.5 text-xs text-red-600">
                        {{ errors.title }}
                    </p>
                </div>

                <div class="sm:col-span-2">
                    <label class="field-label" for="description"
                        >Deskripsi Proyek *</label
                    >
                    <textarea
                        id="description"
                        v-model="form.description"
                        rows="6"
                        class="field-input resize-y"
                        placeholder="Ceritakan tujuan proyek, lingkup pekerjaan, dan hasil yang ingin dicapai..."
                    ></textarea>
                    <p
                        v-if="errors.description"
                        class="mt-1.5 text-xs text-red-600"
                    >
                        {{ errors.description }}
                    </p>
                </div>

                <div>
                    <label class="field-label" for="category">Kategori *</label>
                    <select
                        id="category"
                        v-model="form.category_id"
                        class="field-input"
                    >
                        <option value="" disabled>Pilih kategori</option>
                        <option
                            v-for="category in categories"
                            :key="category.id"
                            :value="category.id"
                        >
                            {{ category.name }}
                        </option>
                    </select>
                    <p
                        v-if="errors.category_id"
                        class="mt-1.5 text-xs text-red-600"
                    >
                        {{ errors.category_id }}
                    </p>
                </div>

                <div>
                    <label class="field-label" for="team_size"
                        >Jumlah Anggota Tim *</label
                    >
                    <input
                        id="team_size"
                        v-model.number="form.team_size"
                        type="number"
                        min="1"
                        max="20"
                        class="field-input"
                    />
                    <p
                        v-if="errors.team_size"
                        class="mt-1.5 text-xs text-red-600"
                    >
                        {{ errors.team_size }}
                    </p>
                </div>

                <div class="sm:col-span-2">
                    <label class="field-label" for="skills"
                        >Keterampilan yang Dibutuhkan</label
                    >
                    <div class="flex gap-2">
                        <input
                            id="skills"
                            v-model="form.skillInput"
                            class="field-input"
                            placeholder="Contoh: UI Design"
                            @keydown.enter.prevent="addSkill"
                        />
                        <button
                            type="button"
                            class="btn-secondary shrink-0 !px-4"
                            @click="addSkill"
                        >
                            <Plus class="size-4" />
                        </button>
                    </div>
                    <div
                        v-if="form.required_skills.length"
                        class="mt-3 flex flex-wrap gap-2"
                    >
                        <span
                            v-for="skill in form.required_skills"
                            :key="skill"
                            class="chip"
                        >
                            {{ skill }}
                            <button
                                type="button"
                                class="ml-1 text-brand-400 hover:text-brand-400"
                                @click="
                                    form.required_skills =
                                        form.required_skills.filter(
                                            (s) => s !== skill,
                                        )
                                "
                            >
                                <X class="size-3" />
                            </button>
                        </span>
                    </div>
                    <p class="mt-2 text-xs text-slate-500">
                        Tekan Enter atau tombol + untuk menambahkan keahlian.
                    </p>
                </div>

                <div>
                    <label class="field-label" for="deadline"
                        >Batas Waktu Pengerjaan</label
                    >
                    <input
                        id="deadline"
                        v-model="form.deadline"
                        type="date"
                        class="field-input"
                    />
                    <p
                        v-if="errors.deadline"
                        class="mt-1.5 text-xs text-red-600"
                    >
                        {{ errors.deadline }}
                    </p>
                </div>

                <div>
                    <label class="field-label" for="cover"
                        >URL Gambar Sampul</label
                    >
                    <input
                        id="cover"
                        v-model="form.cover_image"
                        type="url"
                        class="field-input"
                        placeholder="https://..."
                    />
                    <p
                        v-if="errors.cover_image"
                        class="mt-1.5 text-xs text-red-600"
                    >
                        {{ errors.cover_image }}
                    </p>
                </div>
            </div>

            <div
                v-if="form.cover_image"
                class="mt-6 overflow-hidden rounded-2xl border border-slate-200"
            >
                <img
                    :src="form.cover_image"
                    alt="Pratinjau sampul"
                    class="h-48 w-full object-cover"
                />
            </div>
            <div
                v-else
                class="mt-6 flex items-center gap-3 rounded-2xl border border-dashed border-slate-300 bg-slate-50 px-5 py-6 text-sm text-slate-500"
            >
                <ImagePlus class="size-5" /> Pratinjau gambar sampul akan tampil
                di sini.
            </div>

            <div
                class="mt-8 flex flex-wrap gap-3 border-t border-slate-200 pt-6"
            >
                <button type="submit" class="btn-primary">
                    Publikasikan Proyek <Sparkles class="size-4" />
                </button>
                <Link href="/proyek" class="btn-secondary">Batal</Link>
            </div>
        </form>
    </div>
</template>
