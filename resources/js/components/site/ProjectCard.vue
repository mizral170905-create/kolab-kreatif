<script setup lang="ts">
import { Link } from '@inertiajs/vue3';
import { CalendarDays, Users } from '@lucide/vue';

defineProps<{ project: any }>();

const statusLabel: Record<string, string> = {
    open: 'Merekrut Anggota',
    in_progress: 'Sedang Berjalan',
    completed: 'Selesai',
};

const statusClass: Record<string, string> = {
    open: 'bg-emerald-500/10 text-emerald-700',
    in_progress: 'bg-teal-500/10 text-teal-700',
    completed: 'bg-slate-100 text-slate-600',
};

const formatDate = (date: string) =>
    new Date(date).toLocaleDateString('id-ID', {
        day: 'numeric',
        month: 'short',
        year: 'numeric',
    });
</script>

<template>
    <Link
        :href="'/proyek/' + project.slug"
        class="card-soft group flex h-full flex-col overflow-hidden"
    >
        <div class="relative h-48 overflow-hidden bg-slate-100">
            <img
                :src="
                    project.cover_image ||
                    'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=800&q=80'
                "
                :alt="project.title"
                class="size-full object-cover transition-transform duration-500 group-hover:scale-105"
                loading="lazy"
            />
            <div
                class="absolute inset-0 bg-gradient-to-t from-slate-950/40 via-transparent to-transparent"
            ></div>
            <span
                v-if="project.category"
                class="absolute top-4 left-4 rounded-lg bg-slate-50/75 px-2.5 py-1 text-[11px] font-bold text-brand-300 shadow-sm backdrop-blur"
            >
                {{ project.category.name }}
            </span>
            <span
                :class="[
                    'absolute bottom-4 left-4 rounded-lg px-2.5 py-1 text-[11px] font-bold shadow-sm',
                    statusClass[project.status],
                ]"
            >
                {{ statusLabel[project.status] || project.status }}
            </span>
        </div>

        <div class="flex flex-1 flex-col p-5">
            <h3
                class="line-clamp-2 text-[17px] leading-snug font-bold text-slate-900 transition-colors group-hover:text-brand-400"
            >
                {{ project.title }}
            </h3>
            <p class="mt-2 line-clamp-2 text-[13px] leading-6 text-slate-500">
                {{ project.description }}
            </p>

            <div class="mt-4 flex flex-wrap gap-1.5">
                <span
                    v-for="skill in (project.required_skills || []).slice(0, 3)"
                    :key="skill"
                    class="rounded-md bg-slate-100 px-2 py-1 text-[10px] font-semibold text-slate-600"
                >
                    {{ skill }}
                </span>
            </div>

            <div
                class="mt-auto flex items-center justify-between border-t border-slate-200 pt-4"
            >
                <div class="flex min-w-0 items-center gap-2">
                    <img
                        :src="project.owner?.avatar_url"
                        :alt="project.owner?.name"
                        class="size-7 shrink-0 rounded-lg object-cover"
                    />
                    <span
                        class="truncate text-xs font-semibold text-slate-600"
                        >{{ project.owner?.name }}</span
                    >
                </div>
                <div
                    class="flex shrink-0 items-center gap-3 text-[11px] font-medium text-slate-500"
                >
                    <span class="flex items-center gap-1"
                        ><Users class="size-3.5" />
                        {{ project.members_count ?? 0 }}/{{
                            project.team_size
                        }}</span
                    >
                    <span class="flex items-center gap-1"
                        ><CalendarDays class="size-3.5" />
                        {{ formatDate(project.deadline) }}</span
                    >
                </div>
            </div>
        </div>
    </Link>
</template>
