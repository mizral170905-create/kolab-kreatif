<script setup lang="ts">
import { computed, ref } from 'vue';
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import { ArrowLeft, ImagePlus, Upload, X } from '@lucide/vue';
import PageBanner from '@/components/site/PageBanner.vue';

defineProps<{ categories: any[]; projects: any[] }>();

const page = usePage<any>();
const errors = computed(() => page.props.errors || {});
const preview = ref<string>('');

const form = ref({
    title: '',
    description: '',
    category_id: '',
    project_id: '',
    image_url: '',
    is_featured: false,
});

const onFile = (event: Event) => {
    const input = event.target as HTMLInputElement;
    const file = input.files?.[0];
    if (file) preview.value = URL.createObjectURL(file);
};

const submit = () => {
    const data = new FormData();
    data.append('title', form.value.title);
    data.append('description', form.value.description);
    data.append('category_id', form.value.category_id);
    data.append('project_id', form.value.project_id);
    data.append('is_featured', form.value.is_featured ? '1' : '0');
    if (form.value.image_url) data.append('image_url', form.value.image_url);

    const fileInput =
        document.querySelector<HTMLInputElement>('#artwork-image')?.files?.[0];
    if (fileInput) data.append('image', fileInput);

    router.post('/galeri', data, { forceFormData: true });
};
</script>

<template>
    <Head title="Unggah Karya" />

    <PageBanner
        eyebrow="Galeri Karya"
        title="Pamerkan karyamu kepada dunia"
        description="Unggah hasil karyamu, ceritakan prosesnya, dan biarkan komunitas mengapresiasi karyamu."
    />

    <div class="site-container max-w-4xl py-12">
        <Link
            href="/galeri"
            class="mb-6 inline-flex items-center gap-2 text-sm font-semibold text-slate-500 hover:text-brand-400"
        >
            <ArrowLeft class="size-4" /> Kembali ke galeri
        </Link>

        <form class="card-soft p-6 sm:p-8" @submit.prevent="submit">
            <div class="grid gap-6 sm:grid-cols-2">
                <div class="sm:col-span-2">
                    <label class="field-label" for="artwork-image"
                        >Gambar Karya *</label
                    >
                    <label
                        for="artwork-image"
                        class="flex cursor-pointer flex-col items-center justify-center rounded-2xl border-2 border-dashed border-brand-500/30 bg-brand-500/10 px-6 py-10 text-center transition hover:border-brand-400 hover:bg-brand-500/10"
                    >
                        <img
                            v-if="preview"
                            :src="preview"
                            alt="Pratinjau karya"
                            class="mb-4 max-h-64 rounded-xl object-contain"
                        />
                        <span
                            v-else
                            class="mb-3 flex size-12 items-center justify-center rounded-2xl bg-white text-brand-400 shadow-sm"
                            ><Upload class="size-5"
                        /></span>
                        <p class="text-sm font-bold text-slate-800">
                            Klik untuk memilih gambar
                        </p>
                        <p class="mt-1 text-xs text-slate-500">
                            PNG, JPG, atau WEBP · maksimal 5 MB
                        </p>
                        <input
                            id="artwork-image"
                            type="file"
                            accept="image/*"
                            class="hidden"
                            @change="onFile"
                        />
                    </label>
                    <p v-if="errors.image" class="mt-1.5 text-xs text-red-600">
                        {{ errors.image }}
                    </p>
                </div>

                <div class="sm:col-span-2">
                    <label class="field-label" for="image_url"
                        >Atau gunakan URL gambar</label
                    >
                    <input
                        id="image_url"
                        v-model="form.image_url"
                        type="url"
                        class="field-input"
                        placeholder="https://contoh.com/gambar.jpg"
                    />
                    <p
                        v-if="errors.image_url"
                        class="mt-1.5 text-xs text-red-600"
                    >
                        {{ errors.image_url }}
                    </p>
                </div>

                <div class="sm:col-span-2">
                    <label class="field-label" for="title">Judul Karya *</label>
                    <input
                        id="title"
                        v-model="form.title"
                        class="field-input"
                        placeholder="Contoh: Warna Kota Pagi"
                    />
                    <p v-if="errors.title" class="mt-1.5 text-xs text-red-600">
                        {{ errors.title }}
                    </p>
                </div>

                <div class="sm:col-span-2">
                    <label class="field-label" for="description"
                        >Deskripsi *</label
                    >
                    <textarea
                        id="description"
                        v-model="form.description"
                        rows="5"
                        class="field-input resize-y"
                        placeholder="Ceritakan ide, proses, atau hal menarik di balik karya ini..."
                    ></textarea>
                    <p
                        v-if="errors.description"
                        class="mt-1.5 text-xs text-red-600"
                    >
                        {{ errors.description }}
                    </p>
                </div>

                <div>
                    <label class="field-label" for="category">Kategori</label>
                    <select
                        id="category"
                        v-model="form.category_id"
                        class="field-input"
                    >
                        <option value="">Pilih kategori (opsional)</option>
                        <option
                            v-for="category in categories"
                            :key="category.id"
                            :value="category.id"
                        >
                            {{ category.name }}
                        </option>
                    </select>
                </div>

                <div>
                    <label class="field-label" for="project"
                        >Terkait Proyek</label
                    >
                    <select
                        id="project"
                        v-model="form.project_id"
                        class="field-input"
                    >
                        <option value="">Tidak ada (opsional)</option>
                        <option
                            v-for="project in projects"
                            :key="project.id"
                            :value="project.id"
                        >
                            {{ project.title }}
                        </option>
                    </select>
                </div>

                <label
                    class="flex cursor-pointer items-center gap-3 rounded-xl border border-slate-200 p-4 sm:col-span-2"
                >
                    <input
                        v-model="form.is_featured"
                        type="checkbox"
                        class="size-4 rounded border-slate-300 accent-brand-600"
                    />
                    <span>
                        <span class="block text-sm font-semibold text-slate-800"
                            >Tampilkan di karya pilihan</span
                        >
                        <span class="block text-xs text-slate-500"
                            >Karyamu berpeluang muncul di halaman utama.</span
                        >
                    </span>
                </label>
            </div>

            <div class="mt-8 flex gap-3 border-t border-slate-200 pt-6">
                <button type="submit" class="btn-primary">
                    <ImagePlus class="size-4" /> Publikasikan Karya
                </button>
                <Link href="/galeri" class="btn-secondary"
                    ><X class="size-4" /> Batal</Link
                >
            </div>
        </form>
    </div>
</template>
