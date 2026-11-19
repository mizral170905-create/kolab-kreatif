<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import TextLink from '@/components/TextLink.vue';
import { Button } from '@/components/ui/button';
import { Spinner } from '@/components/ui/spinner';
import { ref } from 'vue';
import { logout } from '@/routes';

defineOptions({
    layout: {
        title: 'Verifikasi email',
        description:
            'Silakan verifikasi alamat email kamu melalui tautan yang kami kirimkan.',
    },
});

defineProps<{ status?: string }>();

const processing = ref(false);

const resend = () => {
    processing.value = true;
    router.post(
        '/email/verification-notification',
        {},
        { onFinish: () => (processing.value = false) },
    );
};
</script>

<template>
    <Head title="Verifikasi Email" />

    <div
        v-if="status === 'verification-link-sent'"
        class="mb-4 rounded-xl bg-emerald-500/10 px-4 py-3 text-center text-sm font-medium text-emerald-700"
    >
        Tautan verifikasi baru telah dikirim ke alamat email kamu.
    </div>

    <div class="space-y-6 text-center">
        <Button :disabled="processing" variant="secondary" @click="resend">
            <Spinner v-if="processing" />
            Kirim ulang email verifikasi
        </Button>

        <TextLink :href="logout()" as="button" class="mx-auto block text-sm">
            Keluar
        </TextLink>
    </div>
</template>
