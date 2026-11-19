<script setup lang="ts">
import { computed, ref } from 'vue';
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import {
    ArrowLeft,
    CalendarDays,
    Check,
    CircleCheck,
    Clock,
    HeartHandshake,
    MessageCircle,
    Send,
    Trash2,
    UserPlus,
    Users,
    X,
} from '@lucide/vue';

const props = defineProps<{
    project: any;
    myMembership: any;
    pendingMembers: any[];
    canManage: boolean;
    related: any[];
}>();

const page = usePage<any>();
const errors = computed(() => page.props.errors || {});
const message = ref('');
const comment = ref('');

const statusLabel: Record<string, string> = {
    open: 'Merekrut Anggota',
    in_progress: 'Sedang Berjalan',
    completed: 'Selesai',
};

const formatDate = (date: string) =>
    date
        ? new Date(date).toLocaleDateString('id-ID', {
              day: 'numeric',
              month: 'long',
              year: 'numeric',
          })
        : 'Tidak ditentukan';

const join = () =>
    router.post(`/proyek/${props.project.slug}/gabung`, {
        message: message.value,
    });
const updateMember = (id: number, status: string) =>
    router.patch(`/proyek/${props.project.slug}/anggota/${id}`, { status });
const updateStatus = (status: string) =>
    router.patch(`/proyek/${props.project.slug}/status`, { status });
const postComment = () => {
    router.post(
        `/proyek/${props.project.slug}/komentar`,
        { body: comment.value },
        { onSuccess: () => (comment.value = '') },
    );
};
const destroy = () => {
    if (
        confirm(
            'Yakin ingin menghapus proyek ini? Tindakan ini tidak dapat dibatalkan.',
        )
    ) {
        router.delete(`/proyek/${props.project.slug}`);
    }
};
</script>

<template>
    <Head :title="project.title" />

    <div class="site-container py-10">
        <Link
            href="/proyek"
            class="mb-6 inline-flex items-center gap-2 text-sm font-semibold text-slate-500 hover:text-brand-400"
        >
            <ArrowLeft class="size-4" /> Kembali ke daftar proyek
        </Link>

        <div class="grid gap-8 lg:grid-cols-[1fr_340px]">
            <div class="min-w-0 space-y-8">
                <!-- Cover -->
                <div
                    class="overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-sm"
                >
                    <div class="relative h-56 sm:h-72">
                        <img
                            :src="project.cover_image"
                            :alt="project.title"
                            class="size-full object-cover"
                        />
                        <div
                            class="absolute inset-0 bg-gradient-to-t from-slate-950/70 via-transparent to-transparent"
                        ></div>
                        <div
                            class="absolute right-6 bottom-5 left-6 flex flex-wrap items-end justify-between gap-3"
                        >
                            <div>
                                <span
                                    v-if="project.category"
                                    class="rounded-lg bg-white/90 px-3 py-1.5 text-[11px] font-bold text-slate-800 backdrop-blur"
                                    >{{ project.category.name }}</span
                                >
                                <h1
                                    class="mt-3 text-2xl leading-tight font-extrabold text-slate-900 sm:text-3xl"
                                >
                                    {{ project.title }}
                                </h1>
                            </div>
                            <span
                                class="rounded-lg bg-brand-600 px-3 py-1.5 text-[11px] font-bold text-white"
                                >{{ statusLabel[project.status] }}</span
                            >
                        </div>
                    </div>
                    <div
                        class="flex flex-wrap items-center gap-5 px-6 py-4 text-xs font-medium text-slate-500"
                    >
                        <span class="flex items-center gap-1.5"
                            ><CalendarDays class="size-4 text-brand-500" />
                            Tenggat: {{ formatDate(project.deadline) }}</span
                        >
                        <span class="flex items-center gap-1.5"
                            ><Users class="size-4 text-teal-700" />
                            {{ project.accepted_members.length }}/{{
                                project.team_size
                            }}
                            anggota</span
                        >
                        <span class="flex items-center gap-1.5"
                            ><MessageCircle class="size-4 text-teal-700" />
                            {{ project.comments.length }} diskusi</span
                        >
                    </div>
                </div>

                <!-- Description -->
                <section class="card-soft p-6 sm:p-7">
                    <h2 class="text-lg font-bold text-slate-900">
                        Tentang Proyek
                    </h2>
                    <p
                        class="mt-4 text-[14px] leading-8 whitespace-pre-line text-slate-600"
                    >
                        {{ project.description }}
                    </p>

                    <div v-if="project.required_skills?.length" class="mt-6">
                        <h3
                            class="text-xs font-bold tracking-wide text-slate-500 uppercase"
                        >
                            Keahlian yang dibutuhkan
                        </h3>
                        <div class="mt-3 flex flex-wrap gap-2">
                            <span
                                v-for="skill in project.required_skills"
                                :key="skill"
                                class="chip"
                                >{{ skill }}</span
                            >
                        </div>
                    </div>
                </section>

                <!-- Team -->
                <section class="card-soft p-6 sm:p-7">
                    <div class="flex items-center justify-between">
                        <h2 class="text-lg font-bold text-slate-900">
                            Tim Proyek
                        </h2>
                        <span class="chip"
                            >{{ project.accepted_members.length }} anggota</span
                        >
                    </div>
                    <div class="mt-5 grid gap-3 sm:grid-cols-2">
                        <Link
                            v-for="member in project.accepted_members"
                            :key="member.id"
                            :href="'/profil/' + member.user.id"
                            class="flex items-center gap-3 rounded-xl border border-slate-200 bg-slate-50/60 p-3 transition hover:border-brand-500/30 hover:bg-brand-500/10"
                        >
                            <img
                                :src="member.user.avatar_url"
                                :alt="member.user.name"
                                class="size-11 rounded-xl object-cover"
                            />
                            <div class="min-w-0">
                                <p
                                    class="truncate text-sm font-bold text-slate-900"
                                >
                                    {{ member.user.name }}
                                </p>
                                <p class="truncate text-xs text-slate-500">
                                    {{
                                        member.role ||
                                        member.user.expertise ||
                                        'Anggota'
                                    }}
                                </p>
                            </div>
                            <CircleCheck
                                v-if="member.user.id === project.user_id"
                                class="ml-auto size-4 shrink-0 text-brand-500"
                            />
                        </Link>
                    </div>

                    <!-- Pending requests (owner only) -->
                    <div
                        v-if="canManage && pendingMembers.length"
                        class="mt-7 border-t border-slate-200 pt-6"
                    >
                        <h3
                            class="flex items-center gap-2 text-sm font-bold text-slate-900"
                        >
                            <Clock class="size-4 text-teal-700" /> Pengajuan
                            Menunggu ({{ pendingMembers.length }})
                        </h3>
                        <div class="mt-4 space-y-3">
                            <div
                                v-for="request in pendingMembers"
                                :key="request.id"
                                class="rounded-xl border border-teal-500/20 bg-teal-500/10 p-4"
                            >
                                <div class="flex flex-wrap items-center gap-3">
                                    <img
                                        :src="request.user.avatar_url"
                                        :alt="request.user.name"
                                        class="size-10 rounded-lg object-cover"
                                    />
                                    <div class="min-w-0 flex-1">
                                        <p
                                            class="truncate text-sm font-bold text-slate-900"
                                        >
                                            {{ request.user.name }}
                                        </p>
                                        <p
                                            class="truncate text-xs text-slate-500"
                                        >
                                            {{
                                                request.user.expertise ||
                                                'Kreator'
                                            }}
                                        </p>
                                    </div>
                                    <button
                                        type="button"
                                        class="rounded-lg bg-brand-600 px-3 py-2 text-xs font-bold text-white hover:bg-brand-700"
                                        @click="
                                            updateMember(request.id, 'accepted')
                                        "
                                    >
                                        <Check class="mr-1 inline size-3.5" />
                                        Terima
                                    </button>
                                    <button
                                        type="button"
                                        class="rounded-lg border border-slate-200 bg-white px-3 py-2 text-xs font-bold text-slate-600 hover:border-red-200 hover:text-red-600"
                                        @click="
                                            updateMember(request.id, 'rejected')
                                        "
                                    >
                                        <X class="mr-1 inline size-3.5" /> Tolak
                                    </button>
                                </div>
                                <p
                                    v-if="request.message"
                                    class="mt-3 rounded-lg bg-white px-3 py-2 text-xs text-slate-500 italic"
                                >
                                    “{{ request.message }}”
                                </p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Discussion -->
                <section class="card-soft p-6 sm:p-7">
                    <h2
                        class="flex items-center gap-2 text-lg font-bold text-slate-900"
                    >
                        <MessageCircle class="size-5 text-brand-500" /> Ruang
                        Diskusi
                    </h2>
                    <p class="mt-1 text-xs text-slate-500">
                        Tempat tim dan calon anggota bertukar ide seputar proyek
                        ini.
                    </p>

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
                                rows="2"
                                class="field-input resize-none"
                                placeholder="Tulis pesan atau pertanyaanmu..."
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
                                <Send class="size-3.5" /> Kirim Pesan
                            </button>
                        </div>
                    </form>
                    <div
                        v-else
                        class="mt-5 rounded-xl bg-slate-50 px-4 py-3 text-sm text-slate-500"
                    >
                        <Link
                            href="/login"
                            class="font-bold text-brand-400 hover:underline"
                            >Masuk</Link
                        >
                        untuk ikut berdiskusi.
                    </div>

                    <div class="mt-6 space-y-4">
                        <div
                            v-for="item in project.comments"
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
                                            ).toLocaleDateString('id-ID')
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
                            v-if="!project.comments.length"
                            class="text-center text-sm text-slate-500"
                        >
                            Belum ada diskusi. Jadilah yang pertama!
                        </p>
                    </div>
                </section>
            </div>

            <!-- Sidebar -->
            <aside class="space-y-6">
                <div class="card-soft sticky top-24 p-6">
                    <!-- Join box -->
                    <template v-if="!canManage">
                        <div
                            v-if="myMembership?.status === 'accepted'"
                            class="rounded-xl bg-emerald-500/10 px-4 py-3 text-center text-sm font-bold text-emerald-700"
                        >
                            <CircleCheck class="mx-auto mb-1 size-5" /> Kamu
                            adalah anggota tim ini
                        </div>
                        <div
                            v-else-if="myMembership?.status === 'pending'"
                            class="rounded-xl bg-teal-500/10 px-4 py-3 text-center text-sm font-bold text-teal-700"
                        >
                            <Clock class="mx-auto mb-1 size-5" /> Pengajuanmu
                            sedang ditinjau
                        </div>
                        <form
                            v-else-if="page.props.auth.user"
                            class="space-y-3"
                            @submit.prevent="join"
                        >
                            <h3
                                class="flex items-center gap-2 text-base font-bold text-slate-900"
                            >
                                <HeartHandshake class="size-5 text-brand-400" />
                                Gabung Proyek
                            </h3>
                            <p class="text-xs leading-5 text-slate-500">
                                Perkenalkan dirimu dan ceritakan apa yang bisa
                                kamu kontribusikan.
                            </p>
                            <textarea
                                v-model="message"
                                rows="4"
                                class="field-input resize-none"
                                placeholder="Halo! Saya tertarik bergabung karena..."
                            ></textarea>
                            <p
                                v-if="errors.message"
                                class="text-xs text-red-600"
                            >
                                {{ errors.message }}
                            </p>
                            <button type="submit" class="btn-primary w-full">
                                <UserPlus class="size-4" /> Ajukan Diri
                            </button>
                        </form>
                        <div v-else class="text-center">
                            <h3 class="text-base font-bold text-slate-900">
                                Tertarik proyek ini?
                            </h3>
                            <p class="mt-2 text-xs text-slate-500">
                                Masuk untuk mengajukan diri sebagai anggota tim.
                            </p>
                            <Link href="/login" class="btn-primary mt-4 w-full"
                                >Masuk untuk Bergabung</Link
                            >
                        </div>
                    </template>

                    <template v-else>
                        <h3 class="text-base font-bold text-slate-900">
                            Kelola Proyek
                        </h3>
                        <p class="mt-1 text-xs text-slate-500">
                            Perbarui status atau hapus proyekmu.
                        </p>
                        <select
                            class="field-input mt-4"
                            :value="project.status"
                            @change="
                                updateStatus(
                                    ($event.target as HTMLSelectElement).value,
                                )
                            "
                        >
                            <option value="open">Merekrut Anggota</option>
                            <option value="in_progress">Sedang Berjalan</option>
                            <option value="completed">Selesai</option>
                        </select>
                        <button
                            type="button"
                            class="mt-3 flex w-full items-center justify-center gap-2 rounded-xl border border-red-200 py-2.5 text-xs font-bold text-red-600 hover:bg-red-50"
                            @click="destroy"
                        >
                            <Trash2 class="size-3.5" /> Hapus Proyek
                        </button>
                    </template>

                    <div class="mt-6 border-t border-slate-200 pt-6">
                        <h4
                            class="text-xs font-bold tracking-wide text-slate-500 uppercase"
                        >
                            Dibuat oleh
                        </h4>
                        <Link
                            :href="'/profil/' + project.owner.id"
                            class="mt-3 flex items-center gap-3"
                        >
                            <img
                                :src="project.owner.avatar_url"
                                :alt="project.owner.name"
                                class="size-11 rounded-xl object-cover"
                            />
                            <div class="min-w-0">
                                <p
                                    class="truncate text-sm font-bold text-slate-900"
                                >
                                    {{ project.owner.name }}
                                </p>
                                <p class="truncate text-xs text-slate-500">
                                    {{ project.owner.expertise || 'Kreator' }}
                                </p>
                            </div>
                        </Link>
                        <p
                            v-if="project.owner.bio"
                            class="mt-3 line-clamp-3 text-xs leading-5 text-slate-500"
                        >
                            {{ project.owner.bio }}
                        </p>
                    </div>
                </div>

                <!-- Related -->
                <div v-if="related.length" class="card-soft p-6">
                    <h3 class="text-sm font-bold text-slate-900">
                        Proyek Serupa
                    </h3>
                    <div class="mt-4 space-y-3">
                        <Link
                            v-for="item in related"
                            :key="item.id"
                            :href="'/proyek/' + item.slug"
                            class="group flex gap-3"
                        >
                            <img
                                :src="item.cover_image"
                                :alt="item.title"
                                class="size-14 shrink-0 rounded-lg object-cover"
                            />
                            <div class="min-w-0">
                                <p
                                    class="line-clamp-2 text-xs font-bold text-slate-800 group-hover:text-brand-400"
                                >
                                    {{ item.title }}
                                </p>
                                <p class="mt-1 text-[10px] text-slate-500">
                                    {{ item.owner?.name }}
                                </p>
                            </div>
                        </Link>
                    </div>
                </div>
            </aside>
        </div>
    </div>
</template>
