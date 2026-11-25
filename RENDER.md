# Hosting KolabKreatif di Render

Panduan ini menjelaskan apa saja yang perlu disiapkan untuk memindahkan hosting dari InfinityFree ke Render.

## 1. Yang dibuat di Render

| Resource                 | Pengaturan                                                                                                                       |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| **Postgres database**    | Nama `kolabkreatif-db`, region **Singapore**, plan `free` untuk uji coba. Free DB kedaluwarsa setelah 30 hari dan maksimal 1 GB. |
| **Web Service**          | Nama `kolabkreatif`, runtime **Docker**, branch `main`, region **Singapore**, health check `/`.                                  |
| **Blueprint (opsional)** | `render.yaml` sudah dibuat; cukup **New → Blueprint** dan pilih repo ini.                                                        |

Kalau tidak memakai Blueprint, buat manual: **New → Web Service → Git Provider → Dockerfile**, lalu isi environment variable seperti di `.env.render.example`.

## 2. Yang sudah disiapkan di repository

| Berkas                                         | Fungsi                                                                                                      |
| ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `Dockerfile`                                   | Build aset Vue/Tailwind dengan Node 22, install vendor produksi, lalu image final Nginx + PHP-FPM 8.4.      |
| `.dockerignore`                                | Mencegah `node_modules`, `vendor` lokal, `.env`, `SystemX`, dan cache lokal masuk ke image.                 |
| `docker/nginx.conf.template`                   | Konfigurasi Nginx yang menuju ke `public/index.php` dan mengikuti `$PORT` dari Render.                      |
| `docker/php.ini`                               | `memory_limit=256M`, batas upload 20 MB, dan OPcache.                                                       |
| `docker/entrypoint.sh`                         | Menjalankan `storage:link`, `package:discover`, `optimize`, `migrate`, dan seed jika database masih kosong. |
| `app/Console/Commands/SeedIfDatabaseEmpty.php` | Mencegah data seed dobel setiap kali container restart.                                                     |
| `app/Providers/AppServiceProvider.php`         | Memaksa skema `https` di production karena TLS diakhiri Render.                                             |
| `render.yaml`                                  | Blueprint Postgres + Web Service + seluruh environment variable.                                            |
| `.env.render.example`                          | Referensi variabel lingkungan.                                                                              |

## 3. Langkah deploy

1. Push branch `main` ke GitHub.
2. Di Render: **New → Blueprint** → pilih repository `kolab-kreatif` → **Apply**.
3. Tunggu database dan web service selesai dibangun. Build pertama memakan waktu beberapa menit.
4. Buka URL yang diberikan Render, biasanya `https://kolabkreatif.onrender.com`.
5. Uji login: `systemx@kolabkreatif.test` / `password`.
6. Jangan jalankan `migrate:fresh`; entrypoint hanya menjalankan `migrate` dan seed sekali saat database kosong.

## 4. Environment variable penting

| Key                                                 | Nilai                                                                                       |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| `APP_KEY`                                           | Di-generate Blueprint otomatis. Kalau manual, salin dari `php artisan key:generate --show`. |
| `APP_URL`                                           | URL Render/custom domain Anda.                                                              |
| `DB_CONNECTION`                                     | `pgsql`                                                                                     |
| `DATABASE_URL`                                      | **Internal Database URL** dari Postgres Render ( Blueprint mengisi otomatis).               |
| `SESSION_DRIVER`, `CACHE_STORE`, `QUEUE_CONNECTION` | `database`                                                                                  |
| `LOG_CHANNEL`                                       | `stderr` agar log tampil di Dashboard Render.                                               |

## 5. Keterbatasan yang harus diketahui

- Web service **free mati setelah 15 menit tanpa traffic** dan bangun lagi sekitar 1 menit.
- Filesystem bersifat **ephemeral**: file yang diunggah pengguna ke `storage/app/public` akan hilang saat redeploy/restart. Untuk produksi, gunakan persistent disk (paid) atau object storage seperti S3/Cloudinary.
- Postgres **free expired 30 hari** setelah dibuat; upgrade ke paid sebelum itu kalau ingin tetap pakai.
- `php artisan optimize` aman dipakai karena endpoint passkey sudah memakai controller, bukan closure.

## 6. Custom domain

1. Di Render → service `kolabkreatif` → **Settings → Custom Domains → Add Custom Domain**.
2. Tambahkan DNS CNAME sesuai instruksi Render.
3. Update `APP_URL` di environment variable ke domain tersebut.
