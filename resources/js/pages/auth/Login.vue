<script setup lang="ts">
import { Form, Head } from '@inertiajs/vue3';
import InputError from '@/components/InputError.vue';
import PasswordInput from '@/components/PasswordInput.vue';
import TextLink from '@/components/TextLink.vue';
import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Spinner } from '@/components/ui/spinner';
import { register } from '@/routes';
import { store } from '@/routes/login';
import { request } from '@/routes/password';

defineOptions({
    layout: {
        title: 'Selamat datang kembali',
        description:
            'Masuk dengan email dan password untuk melanjutkan kolaborasimu.',
    },
});

defineProps<{
    status?: string;
    canResetPassword: boolean;
}>();
</script>

<template>
    <Head title="Masuk" />

    <div
        v-if="status"
        class="mb-4 rounded-xl bg-emerald-500/10 px-4 py-3 text-center text-sm font-medium text-emerald-700"
    >
        {{ status }}
    </div>

    <Form
        v-bind="store.form()"
        :reset-on-success="['password']"
        v-slot="{ errors, processing }"
        class="flex flex-col gap-5"
    >
        <div class="grid gap-5">
            <div class="grid gap-2">
                <Label for="email">Alamat Email</Label>
                <Input
                    id="email"
                    type="email"
                    name="email"
                    required
                    v-focus
                    :tabindex="1"
                    autocomplete="email"
                    placeholder="nama@email.com"
                />
                <InputError :message="errors.email" />
            </div>

            <div class="grid gap-2">
                <div class="flex items-center justify-between">
                    <Label for="password">Password</Label>
                    <TextLink
                        v-if="canResetPassword"
                        :href="request()"
                        class="text-xs font-semibold"
                        :tabindex="5"
                    >
                        Lupa password?
                    </TextLink>
                </div>
                <PasswordInput
                    id="password"
                    name="password"
                    required
                    :tabindex="2"
                    autocomplete="current-password"
                    placeholder="Masukkan password"
                />
                <InputError :message="errors.password" />
            </div>

            <Label
                for="remember"
                class="flex items-center space-x-3 text-sm text-slate-600"
            >
                <Checkbox id="remember" name="remember" :tabindex="3" />
                <span>Ingat saya</span>
            </Label>

            <Button
                type="submit"
                class="mt-2 w-full !bg-brand-600 !py-6 hover:!bg-brand-700"
                :tabindex="4"
                :disabled="processing"
                data-test="login-button"
            >
                <Spinner v-if="processing" />
                Masuk ke Akun
            </Button>
        </div>

        <div
            class="rounded-xl border border-brand-500/20 bg-brand-500/10 px-4 py-3 text-xs leading-6 text-slate-600"
        >
            <p class="font-bold text-slate-800">Akun demo untuk mencoba:</p>
            <p>
                <span class="font-semibold">systemx@kolabkreatif.test</span> ·
                password: <span class="font-semibold">password</span>
            </p>
        </div>

        <div class="text-center text-sm text-slate-500">
            Belum punya akun?
            <TextLink :href="register()" :tabindex="6" class="font-bold"
                >Daftar Sekarang</TextLink
            >
        </div>
    </Form>
</template>
