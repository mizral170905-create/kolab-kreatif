# Berkas Bantu Hosting

Folder ini berisi berkas untuk hosting shared InfinityFree. Untuk Render, gunakan `Dockerfile`, `render.yaml`, dan berkas di folder `docker/` di root repository; panduannya ada di `RENDER.md`.

## `htdocs/.htaccess`

Salin berkas ini ke **root folder yang ditunjuk kartu Directory Status** domain di panel InfinityFree, dengan nama persis `.htaccess`.

- Untuk domain utama, biasanya `htdocs/.htaccess`.
- Untuk domain tambahan/pengganti, bisa berupa `kolab-kratif.free.nf/htdocs/.htaccess`.

Aturan di dalamnya mengarahkan semua request ke `public/index.php` Laravel. Jangan menaruhnya di `htdocs/public/.htaccess`; file `.htaccess` bawaan Laravel di `public/` sudah cukup dan harus dibiarkan.

## Checklist sebelum upload

1. Jalankan `npm run build` dan pastikan folder `public/build` ada.
2. Hapus `public/hot` (hanya dipakai Vite development).
3. Salin `.env.hosting.contoh` menjadi `.env`, lalu isi `DB_HOST`, `DB_DATABASE`, `DB_USERNAME`, dan `DB_PASSWORD` persis dari panel InfinityFree.
4. Buang `node_modules`, `tests`, `SystemX`, `.git`, log/cache `storage`, dan dependensi development `vendor` (`composer dump-autoload --no-dev`).
5. Impor `database/mysql/kolab_kreatif.sql` lewat phpMyAdmin setelah database dipilih.
6. Unggah **isi** paket produksi langsung ke folder Directory Status, bukan ke folder bersarang.

Batasan yang perlu diingat: maksimal 10 MB per berkas (1 MB untuk HTML/CSS/JS, 1 KB untuk `.htaccess`) dan sekitar 30.000 inode pada akun gratis. Karena itu unggah memakai FTP client lebih aman daripada satu arsip ZIP besar.

Panduan lengkap ada di `SystemX/.../04_Pengembangan_Aplikasi/database/Panduan Hosting InfinityFree.md`.
