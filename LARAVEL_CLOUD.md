# Deploy KolabKreatif ke Laravel Cloud

Panduan ini berisi pengaturan yang harus dipilih di dashboard Laravel Cloud untuk repository ini.

## 1. Yang perlu disiapkan

| Item               | Nilai / catatan                                                              |
| ------------------ | ---------------------------------------------------------------------------- |
| Akun Laravel Cloud | Pakai **Starter**. 31 hari pertama gratis + $5 usage credit.                 |
| Kartu pembayaran   | Tetap diminta saat sign-up walaupun trial gratis.                            |
| GitHub             | Hubungkan akun GitHub yang berisi repo `kolab-kreatif`.                      |
| Runtime            | **PHP 8.4** (juga bisa 8.5).                                                 |
| Region             | **Singapore** (`ap-southeast-1`) — harus sama untuk app dan database.        |
| Database           | **Laravel Serverless Postgres 18**, nama database `kolabkreatif`.            |
| Domain             | Otomatis dapat `*.laravel.cloud`; custom domain opsional.                    |
| Object storage     | Opsional, tapi disarankan agar upload karya/avatar tidak hilang saat deploy. |

## 2. Langkah deploy

1. Buka **https://cloud.laravel.com**, sign up / login, pilih **Starter**.
2. Klik **+ New Application**.
3. **Connect to GitHub** → pilih repo `mizral170905-create/kolab-kreatif`.
4. Isi nama aplikasi, misalnya `kolabkreatif`.
5. Pilih region **Singapore**, lalu **Create Application**.
6. Di **Environment Settings → General**, set runtime **PHP 8.4**.
7. Di infrastructure canvas, klik **Add database** → **Laravel Serverless Postgres**.
8. Pilih **Postgres 18**, cluster name `kolabkreatif-db`, region **Singapore**, database name `kolabkreatif`.
9. Attach database ke environment, lalu isi build & deploy command seperti di bawah.
10. Isi environment variables, lalu klik **Deploy**.
11. Buka URL `*.laravel.cloud` yang muncul dan uji login dengan `systemx@kolabkreatif.test` / `password`.

## 3. Build command

Masukkan ini di **Environment Settings → Build Commands**:

```sh
composer install --no-dev --prefer-dist --optimize-autoloader
npm ci --audit false
npm run build
php artisan optimize
```

`php artisan optimize` aman karena endpoint `.well-known/passkey-endpoints` sudah memakai `WellKnownController`, bukan closure.

## 4. Deploy command

Masukkan ini di **Environment Settings → Deploy Commands**:

```sh
php artisan migrate --force
php artisan kolab:seed-if-empty
```

`kolab:seed-if-empty` mengisi data demo hanya jika tabel `users` masih kosong, jadi aman jika deploy diulang.

## 5. Environment variables

Isi minimal:

```env
APP_NAME=KolabKreatif
APP_ENV=production
APP_KEY=base64:...hasil php artisan key:generate --show...
APP_DEBUG=false
APP_URL=https://nama-app.laravel.cloud

SESSION_DRIVER=database
CACHE_STORE=database
QUEUE_CONNECTION=database

MAIL_MAILER=log
VITE_APP_NAME=KolabKreatif
```

Generate `APP_KEY` di lokal:

```sh
php artisan key:generate --show
```

Laravel Cloud otomatis mengisi `DB_CONNECTION`, `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, dan `DB_PASSWORD` saat database di-attach. Tidak perlu menambahnya manual.

## 6. Upload file

Filesystem Laravel Cloud ephemeral dan di-reset setiap deploy. Untuk menyimpan hasil upload secara permanen:

1. Klik **Add bucket** → **Laravel Object Storage**.
2. Tambahkan dependency di lokal, commit, dan push:
    ```sh
    composer require league/flysystem-aws-s3-v3 "^3.0" --with-all-dependencies
    ```
3. Laravel Cloud otomatis mengisi `FILESYSTEM_DISK` dan kredensial bucket.

## 7. Biaya

- Starter: 31 hari pertama gratis + $5 credit.
- Setelah itu `$5/bulan + usage`.
- Scale-to-zero aktif default, sehingga biaya sangat kecil saat tidak ada traffic.
- Disarankan memasang **spending limit** di dashboard.

## 8. Catatan

File `Dockerfile`, `docker/`, dan `render.yaml` di repo adalah untuk Render dan tidak dipakai Laravel Cloud. Laravel Cloud mendeteksi aplikasi ini sebagai Laravel dari `composer.json`, sehingga file-file tersebut tidak mengganggu.
