-- KolabKreatif — dump MySQL/MariaDB untuk InfinityFree
-- Sumber: database/database.sqlite (SQLite)
-- Cara pakai: phpMyAdmin > Database pilihan > Import > pilih file .sql ini
-- Setelah import, ubah .env: DB_CONNECTION=mysql, DB_HOST, DB_DATABASE, DB_USERNAME, DB_PASSWORD

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(191) NOT NULL,
  `email_verified_at` DATETIME NULL,
  `password` VARCHAR(255) NOT NULL,
  `remember_token` VARCHAR(255) NULL,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  `username` VARCHAR(191) NULL,
  `expertise` VARCHAR(255) NULL,
  `skills` TEXT NULL,
  `bio` TEXT NULL,
  `avatar` VARCHAR(255) NULL,
  `location` VARCHAR(255) NULL,
  `website` VARCHAR(255) NULL,
  `github` VARCHAR(255) NULL,
  `instagram` VARCHAR(255) NULL,
  `dribbble` VARCHAR(255) NULL,
  `two_factor_secret` TEXT NULL,
  `two_factor_recovery_codes` TEXT NULL,
  `two_factor_confirmed_at` DATETIME NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE `password_reset_tokens` (
  `email` VARCHAR(191) NOT NULL,
  `token` VARCHAR(255) NOT NULL,
  `created_at` DATETIME NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `cache`;
CREATE TABLE `cache` (
  `key` VARCHAR(255) NOT NULL,
  `value` TEXT NOT NULL,
  `expiration` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `cache_locks`;
CREATE TABLE `cache_locks` (
  `key` VARCHAR(255) NOT NULL,
  `owner` VARCHAR(255) NOT NULL,
  `expiration` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `queue` VARCHAR(191) NOT NULL,
  `payload` TEXT NOT NULL,
  `attempts` BIGINT UNSIGNED NOT NULL,
  `reserved_at` BIGINT UNSIGNED NULL,
  `available_at` BIGINT UNSIGNED NOT NULL,
  `created_at` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `job_batches`;
CREATE TABLE `job_batches` (
  `id` VARCHAR(255) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `total_jobs` BIGINT UNSIGNED NOT NULL,
  `pending_jobs` BIGINT UNSIGNED NOT NULL,
  `failed_jobs` BIGINT UNSIGNED NOT NULL,
  `failed_job_ids` TEXT NOT NULL,
  `options` TEXT NULL,
  `cancelled_at` BIGINT UNSIGNED NULL,
  `created_at` BIGINT UNSIGNED NOT NULL,
  `finished_at` BIGINT UNSIGNED NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE `failed_jobs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` VARCHAR(191) NOT NULL,
  `connection` VARCHAR(191) NOT NULL,
  `queue` VARCHAR(191) NOT NULL,
  `payload` TEXT NOT NULL,
  `exception` TEXT NOT NULL,
  `failed_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `passkeys`;
CREATE TABLE `passkeys` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `credential_id` VARCHAR(191) NOT NULL,
  `credential` TEXT NOT NULL,
  `last_used_at` DATETIME NULL,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_passkeys_user_id` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `slug` VARCHAR(191) NOT NULL,
  `icon` VARCHAR(255) NULL,
  `color` VARCHAR(255) NULL,
  `description` TEXT NULL,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `projects`;
CREATE TABLE `projects` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `category_id` BIGINT UNSIGNED NULL,
  `title` VARCHAR(255) NOT NULL,
  `slug` VARCHAR(191) NOT NULL,
  `description` TEXT NOT NULL,
  `required_skills` TEXT NULL,
  `team_size` BIGINT UNSIGNED NOT NULL DEFAULT 3,
  `deadline` DATE NULL,
  `cover_image` VARCHAR(255) NULL,
  `status` VARCHAR(255) NOT NULL DEFAULT 'open',
  `views` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_projects_user_id` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_projects_category_id` FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `project_members`;
CREATE TABLE `project_members` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` BIGINT UNSIGNED NOT NULL,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `status` VARCHAR(255) NOT NULL DEFAULT 'pending',
  `role` VARCHAR(255) NULL,
  `message` TEXT NULL,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_project_members_project_id` FOREIGN KEY (`project_id`) REFERENCES `projects`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_project_members_user_id` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `artworks`;
CREATE TABLE `artworks` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `project_id` BIGINT UNSIGNED NULL,
  `category_id` BIGINT UNSIGNED NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `image` VARCHAR(255) NOT NULL,
  `is_featured` TINYINT(1) NOT NULL DEFAULT 0,
  `views` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_artworks_user_id` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_artworks_project_id` FOREIGN KEY (`project_id`) REFERENCES `projects`(`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_artworks_category_id` FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `commentable_type` VARCHAR(191) NOT NULL,
  `commentable_id` BIGINT UNSIGNED NOT NULL,
  `body` TEXT NOT NULL,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_comments_user_id` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `likes`;
CREATE TABLE `likes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `likeable_type` VARCHAR(191) NOT NULL,
  `likeable_id` BIGINT UNSIGNED NOT NULL,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_likes_user_id` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `community_posts`;
CREATE TABLE `community_posts` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `body` TEXT NOT NULL,
  `topic` VARCHAR(255) NOT NULL DEFAULT 'Diskusi Umum',
  `image` VARCHAR(255) NULL,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_community_posts_user_id` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `from_user_id` BIGINT UNSIGNED NULL,
  `type` VARCHAR(255) NOT NULL DEFAULT 'info',
  `title` VARCHAR(255) NOT NULL,
  `body` TEXT NOT NULL,
  `link` VARCHAR(255) NULL,
  `data` TEXT NULL,
  `read_at` DATETIME NULL,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_notifications_user_id` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_notifications_from_user_id` FOREIGN KEY (`from_user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` VARCHAR(255) NOT NULL,
  `user_id` BIGINT UNSIGNED NULL,
  `ip_address` VARCHAR(255) NULL,
  `user_agent` TEXT NULL,
  `payload` TEXT NOT NULL,
  `last_activity` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` VARCHAR(255) NOT NULL,
  `batch` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX `cache_expiration_index` ON `cache` (`expiration`);
CREATE INDEX `cache_locks_expiration_index` ON `cache_locks` (`expiration`);
CREATE UNIQUE INDEX `categories_slug_unique` ON `categories` (`slug`);
CREATE INDEX `comments_commentable_type_commentable_id_index` ON `comments` (`commentable_type`, `commentable_id`);
CREATE INDEX `failed_jobs_connection_queue_failed_at_index` ON `failed_jobs` (`connection`, `queue`, `failed_at`);
CREATE UNIQUE INDEX `failed_jobs_uuid_unique` ON `failed_jobs` (`uuid`);
CREATE INDEX `jobs_queue_index` ON `jobs` (`queue`);
CREATE INDEX `likes_likeable_type_likeable_id_index` ON `likes` (`likeable_type`, `likeable_id`);
CREATE UNIQUE INDEX `likes_unique` ON `likes` (`user_id`, `likeable_type`, `likeable_id`);
CREATE UNIQUE INDEX `passkeys_credential_id_unique` ON `passkeys` (`credential_id`);
CREATE INDEX `passkeys_user_id_index` ON `passkeys` (`user_id`);
CREATE UNIQUE INDEX `project_members_project_id_user_id_unique` ON `project_members` (`project_id`, `user_id`);
CREATE UNIQUE INDEX `projects_slug_unique` ON `projects` (`slug`);
CREATE INDEX `sessions_last_activity_index` ON `sessions` (`last_activity`);
CREATE INDEX `sessions_user_id_index` ON `sessions` (`user_id`);
CREATE UNIQUE INDEX `users_email_unique` ON `users` (`email`);
CREATE UNIQUE INDEX `users_username_unique` ON `users` (`username`);

-- users: 10 baris
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `username`, `expertise`, `skills`, `bio`, `avatar`, `location`, `website`, `github`, `instagram`, `dribbble`, `two_factor_secret`, `two_factor_recovery_codes`, `two_factor_confirmed_at`) VALUES
(1, 'SystemX Nugroho', 'systemx@kolabkreatif.test', '2026-11-17 09:59:49', '$2y$12$RHUkmqVp.T.QU.NzBO9cWugLimFoesy8j6r4azVbYWla2t.FBoOa6', NULL, '2026-11-17 09:59:49', '2026-11-23 19:32:01', 'systemx', 'UI/UX Designer', '["Figma","UI Design","Prototyping"]', 'Kreator digital pria yang suka merubah ide kompleks jadi pengalaman sederhana.', 'https://i.pravatar.cc/300?img=15', 'Jakarta, Indonesia', 'https://kolabkreatif.test', 'https://github.com', 'https://instagram.com', 'https://dribbble.com', NULL, NULL, NULL),
(2, 'Raka Pratama', 'raka@kolabkreatif.test', '2026-11-17 09:59:49', '$2y$12$.MVPvqdTlp1ErENUD9a8luWH5WyrEQNngUZLtPJqIXM7LVJ9kfzlq', NULL, '2026-11-17 09:59:49', '2026-11-17 09:59:49', 'raka.pratama', 'Frontend Developer', '["Vue.js","Laravel","TypeScript"]', 'Fullstack developer dengan fokus pada performa dan detail.', 'https://i.pravatar.cc/300?img=12', 'Bandung, Indonesia', 'https://kolabkreatif.test', 'https://github.com', 'https://instagram.com', 'https://dribbble.com', NULL, NULL, NULL),
(3, 'Salsa Amelia', 'salsa@kolabkreatif.test', '2026-11-17 09:59:50', '$2y$12$wdBTvvUqFY61EeIwH493W.NtH6PKxmPiEPVc0HO5poyBVraao6VmK', NULL, '2026-11-17 09:59:50', '2026-11-17 09:59:50', 'salsa.amelia', 'Ilustrator', '["Procreate","Karakter","Storytelling"]', 'Menggambar cerita kecil lewat warna dan karakter.', 'https://i.pravatar.cc/300?img=19', 'Yogyakarta, Indonesia', 'https://kolabkreatif.test', 'https://github.com', 'https://instagram.com', 'https://dribbble.com', NULL, NULL, NULL),
(4, 'Bagus Setiawan', 'bagus@kolabkreatif.test', '2026-11-17 09:59:50', '$2y$12$guiQ9tr2Twm3VKcQc6O.keljJToj8cLjSaS1hsDggie1On.jdYBTq', NULL, '2026-11-17 09:59:50', '2026-11-17 09:59:50', 'bagus.setiawan', 'Fotografer', '["Fotografi Produk","Lightroom","Portrait"]', 'Menangkap momen yang sering terlewat.', 'https://i.pravatar.cc/300?img=26', 'Surabaya, Indonesia', 'https://kolabkreatif.test', 'https://github.com', 'https://instagram.com', 'https://dribbble.com', NULL, NULL, NULL),
(5, 'Citra Maharani', 'citra@kolabkreatif.test', '2026-11-17 09:59:50', '$2y$12$sOvFHwNqvYVsgM3uCcgJze4uVrUTQuXwEqv8ACpHwS4uh4oEr7NFy', NULL, '2026-11-17 09:59:50', '2026-11-17 09:59:50', 'citra.maharani', 'Graphic Designer', '["Branding","Typography","Adobe CC"]', 'Membangun identitas visual yang berkesan.', 'https://i.pravatar.cc/300?img=33', 'Jakarta, Indonesia', 'https://kolabkreatif.test', 'https://github.com', 'https://instagram.com', 'https://dribbble.com', NULL, NULL, NULL),
(6, 'Farhan Aditya', 'farhan@kolabkreatif.test', '2026-11-17 09:59:50', '$2y$12$ooshzM/cGFWk6alDtTA35eephhaskbl8BN9PI8Wn4WzOHNuj4qJUy', NULL, '2026-11-17 09:59:50', '2026-11-17 09:59:50', 'farhan.aditya', 'Video Editor', '["Premiere Pro","Motion Graphics","Coloring"]', 'Bercerita lewat ritme dan gambar.', 'https://i.pravatar.cc/300?img=40', 'Semarang, Indonesia', 'https://kolabkreatif.test', 'https://github.com', 'https://instagram.com', 'https://dribbble.com', NULL, NULL, NULL),
(7, 'Alya Rahma', 'alya@kolabkreatif.test', '2026-11-17 09:59:50', '$2y$12$uVmFTHX2aqpa9GBsN0DGJeFbe6DiBJ6pWXXJEva3Tg/5xKEXTnQMa', NULL, '2026-11-17 09:59:50', '2026-11-17 09:59:50', 'alya.rahma', 'Penulis Konten', '["Copywriting","Editorial","SEO"]', 'Menulis kata-kata yang terasa seperti percakapan.', 'https://i.pravatar.cc/300?img=47', 'Malang, Indonesia', 'https://kolabkreatif.test', 'https://github.com', 'https://instagram.com', 'https://dribbble.com', NULL, NULL, NULL),
(8, 'Dimas Prasetyo', 'dimas@kolabkreatif.test', '2026-11-17 09:59:51', '$2y$12$bld6tqVi8m0izC3TgKS7JOKf9ia761b8q19X.891A6bqQAhSXPY.C', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51', 'dimas.prasetyo', '3D Artist', '["Blender","3D Modeling","Rendering"]', 'Membuat dunia imajiner terasa nyata.', 'https://i.pravatar.cc/300?img=54', 'Tangerang, Indonesia', 'https://kolabkreatif.test', 'https://github.com', 'https://instagram.com', 'https://dribbble.com', NULL, NULL, NULL),
(9, 'Nabila Zahra', 'nabila@kolabkreatif.test', '2026-11-17 09:59:51', '$2y$12$1DxpRb/2ash0.9mTP7daseIRIC1g7GO8akNYng69z6qUG/egeyqfC', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51', 'nabila.zahra', 'Motion Designer', '["After Effects","Animasi","UI Motion"]', 'Animasi yang bikin produk terasa hidup.', 'https://i.pravatar.cc/300?img=61', 'Depok, Indonesia', 'https://kolabkreatif.test', 'https://github.com', 'https://instagram.com', 'https://dribbble.com', NULL, NULL, NULL),
(10, 'Reza Firmansyah', 'reza@kolabkreatif.test', '2026-11-17 09:59:51', '$2y$12$c4eNVd4nJWvQgFKOUJ9ZyuzLj4Bnc4pd1mKrNBnYUcEueRMKvTPi2', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51', 'reza.firmansyah', 'Product Designer', '["Research","Wireframe","Design System"]', 'Memecahkan masalah lewat desain berbasis riset.', 'https://i.pravatar.cc/300?img=68', 'Bekasi, Indonesia', 'https://kolabkreatif.test', 'https://github.com', 'https://instagram.com', 'https://dribbble.com', NULL, NULL, NULL);

-- cache: 2 baris
INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('kolabkreatif-cache-eec6ea2b0e69e950fe652e6fae583496:timer', 'i:1795462056;', 1795462056),
('kolabkreatif-cache-eec6ea2b0e69e950fe652e6fae583496', 'i:1;', 1795462056);

-- categories: 6 baris
INSERT INTO `categories` (`id`, `name`, `slug`, `icon`, `color`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Desain Grafis', 'desain-grafis', 'palette', '#8b5cf6', 'Logo, branding, poster, dan identitas visual.', '2026-11-17 09:59:49', '2026-11-17 09:59:49'),
(2, 'Pemrograman', 'pemrograman', 'code', '#3b82f6', 'Web, aplikasi, dan pengembangan perangkat lunak.', '2026-11-17 09:59:49', '2026-11-17 09:59:49'),
(3, 'Fotografi', 'fotografi', 'camera', '#f97316', 'Foto produk, portrait, dokumentasi, dan editorial.', '2026-11-17 09:59:49', '2026-11-17 09:59:49'),
(4, 'Videografi', 'videografi', 'video', '#ec4899', 'Video promosi, dokumenter, dan konten kreatif.', '2026-11-17 09:59:49', '2026-11-17 09:59:49'),
(5, 'Penulisan', 'penulisan', 'pen', '#14b8a6', 'Copywriting, artikel, cerita, dan konten editorial.', '2026-11-17 09:59:49', '2026-11-17 09:59:49'),
(6, 'Ilustrasi', 'ilustrasi', 'brush', '#6366f1', 'Ilustrasi digital, karakter, dan seni visual.', '2026-11-17 09:59:49', '2026-11-17 09:59:49');

-- projects: 9 baris
INSERT INTO `projects` (`id`, `user_id`, `category_id`, `title`, `slug`, `description`, `required_skills`, `team_size`, `deadline`, `cover_image`, `status`, `views`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 'Platform Kolaborasi Kreator Lokal', 'platform-kolaborasi-kreator-lokal', 'Membangun platform web untuk menghubungkan kreator lokal dengan klien dan sesama kolaborator. Fokus pada kemudahan pencarian tim dan manajemen proyek.', '["Vue.js","Laravel","UI Design"]', 5, '2026-11-24', 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=1200&q=80', 'open', 40, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(2, 5, 1, 'Identitas Visual Kopi Senja', 'identitas-visual-kopi-senja', 'Menciptakan identitas visual hangat untuk brand kopi lokal. Termasuk logo, palet warna, dan desain kemasan.', '["Logo Design","Branding","Packaging"]', 3, '2026-11-30', 'https://images.unsplash.com/photo-1558655146-9f40138edfeb?auto=format&fit=crop&w=1200&q=80', 'open', 77, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(3, 3, 6, 'Seri Ilustrasi "Cerita Kota"', 'seri-ilustrasi-cerita-kota', 'Seri ilustrasi yang menceritakan sudut-sudut kota yang penuh kenangan. Akan ditampilkan dalam pameran kecil.', '["Ilustrasi Digital","Karakter","Warna"]', 4, '2026-12-06', 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?auto=format&fit=crop&w=1200&q=80', 'open', 114, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(4, 4, 3, 'Dokumentasi Komunitas Seni', 'dokumentasi-komunitas-seni', 'Mendokumentasikan aktivitas komunitas seni selama tiga bulan untuk arsip dan publikasi daring.', '["Fotografi Dokumenter","Editing"]', 3, '2026-12-12', 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80', 'in_progress', 151, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(5, 6, 4, 'Video Profil Studio Kreatif', 'video-profil-studio-kreatif', 'Video profil 2 menit untuk memperkenalkan studio kreatif dan karya-karyanya kepada calon klien.', '["Videografi","Motion Graphics","Sound Design"]', 4, '2026-12-18', 'https://images.unsplash.com/photo-1485846234645-a62644f84728?auto=format&fit=crop&w=1200&q=80', 'open', 188, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(6, 7, 5, 'Panduan Menulis untuk Kreator', 'panduan-menulis-untuk-kreator', 'E-book pendek berisi panduan menulis konten kreatif yang autentik dan mudah dipahami.', '["Copywriting","Editorial","Proofreading"]', 2, '2026-12-24', 'https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=1200&q=80', 'open', 225, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(7, 2, 2, 'Aplikasi Mobile Catatan Ide', 'aplikasi-mobile-catatan-ide', 'Aplikasi mobile sederhana untuk menyimpan dan mengorganisir ide-ide kreatif dengan sinkronisasi cloud.', '["React Native","UI Design","Backend"]', 4, '2026-12-30', 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=1200&q=80', 'in_progress', 262, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(8, 8, 6, 'Eksperimen Seni 3D Abstrak', 'eksperimen-seni-3d-abstrak', 'Eksplorasi bentuk dan cahaya dalam seni 3D abstrak untuk koleksi poster digital.', '["Blender","3D","Rendering"]', 3, '2027-01-05', 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=1200&q=80', 'open', 299, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(9, 9, 4, 'Motion Branding KolabKreatif', 'motion-branding-kolabkreatif', 'Paket animasi logo dan transisi untuk kebutuhan branding video KolabKreatif.', '["After Effects","Animasi","Branding"]', 3, '2027-01-11', 'https://images.unsplash.com/photo-1531403009284-440f080d1e12?auto=format&fit=crop&w=1200&q=80', 'completed', 336, '2026-11-17 09:59:51', '2026-11-17 09:59:51');

-- project_members: 21 baris
INSERT INTO `project_members` (`id`, `project_id`, `user_id`, `status`, `role`, `message`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 'accepted', 'Frontend Developer', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(2, 1, 5, 'accepted', 'UI Designer', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(3, 1, 10, 'pending', 'Product Designer', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(4, 2, 3, 'accepted', 'Ilustrator', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(5, 2, 7, 'pending', 'Copywriter', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(6, 3, 8, 'accepted', '3D Artist', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(7, 3, 9, 'pending', 'Motion Designer', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(8, 4, 4, 'accepted', 'Fotografer', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(9, 4, 6, 'accepted', 'Video Editor', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(10, 5, 9, 'accepted', 'Motion Designer', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(11, 5, 2, 'pending', 'Developer', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(12, 6, 7, 'accepted', 'Penulis', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(13, 7, 2, 'accepted', 'Developer', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(14, 7, 5, 'accepted', 'UI Designer', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(15, 8, 3, 'pending', 'Ilustrator', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(16, 9, 9, 'accepted', 'Motion Designer', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(17, 1, 1, 'accepted', 'Pemilik Proyek', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(18, 2, 5, 'accepted', 'Pemilik Proyek', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(19, 3, 3, 'accepted', 'Pemilik Proyek', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(20, 5, 6, 'accepted', 'Pemilik Proyek', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(21, 8, 8, 'accepted', 'Pemilik Proyek', NULL, '2026-11-17 09:59:51', '2026-11-17 09:59:51');

-- artworks: 12 baris
INSERT INTO `artworks` (`id`, `user_id`, `project_id`, `category_id`, `title`, `description`, `image`, `is_featured`, `views`, `created_at`, `updated_at`) VALUES
(1, 3, 1, 6, 'Warna Kota Pagi', 'Eksplorasi warna dan geometri dari sudut kota di pagi hari.', 'https://images.unsplash.com/photo-1541701494587-cb58502866ab?auto=format&fit=crop&w=1200&q=80', 1, 100, '2026-11-17 09:59:51', '2026-11-17 09:59:51'),
(2, 5, 2, 1, 'Minimalisme dalam Desain', 'Studi tentang kesederhanaan bentuk dan tipografi.', 'https://images.unsplash.com/photo-1558655146-9f40138edfeb?auto=format&fit=crop&w=1200&q=80', 1, 153, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(3, 4, 3, 3, 'Sesi Portrait Studio', 'Potret natural dengan pencahayaan sore hari.', 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80', 1, 206, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(4, 2, 4, 2, 'Antarmuka Aplikasi Catatan', 'Tampilan dashboard aplikasi pencatat ide yang sedang kami kembangkan.', 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1200&q=80', 0, 259, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(5, 6, 5, 4, 'Frame Video Dokumenter', 'Beberapa frame favorit dari proses penyuntingan dokumenter komunitas.', 'https://images.unsplash.com/photo-1485846234645-a62644f84728?auto=format&fit=crop&w=1200&q=80', 0, 312, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(6, 3, 6, 6, 'Karakter Si Kecil', 'Desain karakter untuk seri cerita anak yang sedang dikerjakan.', 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?auto=format&fit=crop&w=1200&q=80', 1, 365, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(7, 8, 7, 6, 'Komposisi 3D Soft', 'Eksperimen material dan cahaya di Blender.', 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=1200&q=80', 0, 418, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(8, 5, 8, 1, 'Tipografi Ekspresif', 'Percobaan komposisi huruf dengan pendekatan yang berani.', 'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?auto=format&fit=crop&w=1200&q=80', 0, 471, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(9, 1, 9, 2, 'Team Brainstorming', 'Dokumentasi sesi diskusi tim saat memulai proyek pertama kami.', 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=1200&q=80', 1, 524, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(10, 9, 1, 4, 'Kolase Digital Musim Panas', 'Kolase warna cerah untuk kebutuhan konten media sosial.', 'https://images.unsplash.com/photo-1614850523459-c2f4c699c52e?auto=format&fit=crop&w=1200&q=80', 0, 577, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(11, 5, 2, 1, 'Kopi Senja Packaging', 'Hasil akhir desain kemasan kopi senja.', 'https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&w=1200&q=80', 1, 630, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(12, 10, 3, 2, 'Studio Kreatif', 'Suasana ruang kerja tim kreatif saat proses produksi.', 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1200&q=80', 0, 683, '2026-11-17 09:59:52', '2026-11-17 09:59:52');

-- comments: 59 baris
INSERT INTO `comments` (`id`, `user_id`, `commentable_type`, `commentable_id`, `body`, `created_at`, `updated_at`) VALUES
(1, 2, 'App\\Models\\Artwork', 1, 'Warnanya sangat menenangkan! Keren banget karyanya 👏', '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(2, 3, 'App\\Models\\Artwork', 1, 'Komposisinya menarik, bisa sharing prosesnya?', '2026-11-17 08:59:52', '2026-11-17 09:59:52'),
(3, 3, 'App\\Models\\Artwork', 2, 'Komposisinya menarik, bisa sharing prosesnya?', '2026-11-17 04:59:52', '2026-11-17 09:59:52'),
(4, 4, 'App\\Models\\Artwork', 2, 'Ini menginspirasi saya untuk mulai eksperimen juga.', '2026-11-17 03:59:52', '2026-11-17 09:59:52'),
(5, 5, 'App\\Models\\Artwork', 2, 'Detail kecilnya bikin beda. Mantap!', '2026-11-17 02:59:52', '2026-11-17 09:59:52'),
(6, 4, 'App\\Models\\Artwork', 3, 'Ini menginspirasi saya untuk mulai eksperimen juga.', '2026-11-16 23:59:52', '2026-11-17 09:59:52'),
(7, 5, 'App\\Models\\Artwork', 3, 'Detail kecilnya bikin beda. Mantap!', '2026-11-16 22:59:52', '2026-11-17 09:59:52'),
(8, 6, 'App\\Models\\Artwork', 3, 'Suka banget dengan pendekatan warnanya.', '2026-11-16 21:59:52', '2026-11-17 09:59:52'),
(9, 7, 'App\\Models\\Artwork', 3, 'Warnanya sangat menenangkan! Keren banget karyanya 👏', '2026-11-16 20:59:52', '2026-11-17 09:59:52'),
(10, 5, 'App\\Models\\Artwork', 4, 'Detail kecilnya bikin beda. Mantap!', '2026-11-16 18:59:52', '2026-11-17 09:59:52'),
(11, 6, 'App\\Models\\Artwork', 4, 'Suka banget dengan pendekatan warnanya.', '2026-11-16 17:59:52', '2026-11-17 09:59:52'),
(12, 6, 'App\\Models\\Artwork', 5, 'Suka banget dengan pendekatan warnanya.', '2026-11-16 13:59:52', '2026-11-17 09:59:52'),
(13, 7, 'App\\Models\\Artwork', 5, 'Warnanya sangat menenangkan! Keren banget karyanya 👏', '2026-11-16 12:59:52', '2026-11-17 09:59:52'),
(14, 8, 'App\\Models\\Artwork', 5, 'Komposisinya menarik, bisa sharing prosesnya?', '2026-11-16 11:59:52', '2026-11-17 09:59:52'),
(15, 7, 'App\\Models\\Artwork', 6, 'Warnanya sangat menenangkan! Keren banget karyanya 👏', '2026-11-16 08:59:52', '2026-11-17 09:59:52'),
(16, 8, 'App\\Models\\Artwork', 6, 'Komposisinya menarik, bisa sharing prosesnya?', '2026-11-16 07:59:52', '2026-11-17 09:59:52'),
(17, 9, 'App\\Models\\Artwork', 6, 'Ini menginspirasi saya untuk mulai eksperimen juga.', '2026-11-16 06:59:52', '2026-11-17 09:59:52'),
(18, 10, 'App\\Models\\Artwork', 6, 'Detail kecilnya bikin beda. Mantap!', '2026-11-16 05:59:52', '2026-11-17 09:59:52'),
(19, 8, 'App\\Models\\Artwork', 7, 'Komposisinya menarik, bisa sharing prosesnya?', '2026-11-16 03:59:52', '2026-11-17 09:59:52'),
(20, 9, 'App\\Models\\Artwork', 7, 'Ini menginspirasi saya untuk mulai eksperimen juga.', '2026-11-16 02:59:52', '2026-11-17 09:59:52'),
(21, 9, 'App\\Models\\Artwork', 8, 'Ini menginspirasi saya untuk mulai eksperimen juga.', '2026-11-15 22:59:52', '2026-11-17 09:59:52'),
(22, 10, 'App\\Models\\Artwork', 8, 'Detail kecilnya bikin beda. Mantap!', '2026-11-15 21:59:52', '2026-11-17 09:59:52'),
(23, 1, 'App\\Models\\Artwork', 8, 'Suka banget dengan pendekatan warnanya.', '2026-11-15 20:59:52', '2026-11-17 09:59:52'),
(24, 10, 'App\\Models\\Artwork', 9, 'Detail kecilnya bikin beda. Mantap!', '2026-11-15 17:59:52', '2026-11-17 09:59:52'),
(25, 1, 'App\\Models\\Artwork', 9, 'Suka banget dengan pendekatan warnanya.', '2026-11-15 16:59:52', '2026-11-17 09:59:52'),
(26, 2, 'App\\Models\\Artwork', 9, 'Warnanya sangat menenangkan! Keren banget karyanya 👏', '2026-11-15 15:59:52', '2026-11-17 09:59:52'),
(27, 3, 'App\\Models\\Artwork', 9, 'Komposisinya menarik, bisa sharing prosesnya?', '2026-11-15 14:59:52', '2026-11-17 09:59:52'),
(28, 1, 'App\\Models\\Artwork', 10, 'Suka banget dengan pendekatan warnanya.', '2026-11-15 12:59:52', '2026-11-17 09:59:52'),
(29, 2, 'App\\Models\\Artwork', 10, 'Warnanya sangat menenangkan! Keren banget karyanya 👏', '2026-11-15 11:59:52', '2026-11-17 09:59:52'),
(30, 2, 'App\\Models\\Artwork', 11, 'Warnanya sangat menenangkan! Keren banget karyanya 👏', '2026-11-15 07:59:53', '2026-11-17 09:59:53'),
(31, 3, 'App\\Models\\Artwork', 11, 'Komposisinya menarik, bisa sharing prosesnya?', '2026-11-15 06:59:53', '2026-11-17 09:59:53'),
(32, 4, 'App\\Models\\Artwork', 11, 'Ini menginspirasi saya untuk mulai eksperimen juga.', '2026-11-15 05:59:53', '2026-11-17 09:59:53'),
(33, 3, 'App\\Models\\Artwork', 12, 'Komposisinya menarik, bisa sharing prosesnya?', '2026-11-15 02:59:53', '2026-11-17 09:59:53'),
(34, 4, 'App\\Models\\Artwork', 12, 'Ini menginspirasi saya untuk mulai eksperimen juga.', '2026-11-15 01:59:53', '2026-11-17 09:59:53'),
(35, 5, 'App\\Models\\Artwork', 12, 'Detail kecilnya bikin beda. Mantap!', '2026-11-15 00:59:53', '2026-11-17 09:59:53'),
(36, 6, 'App\\Models\\Artwork', 12, 'Suka banget dengan pendekatan warnanya.', '2026-11-14 23:59:53', '2026-11-17 09:59:53'),
(37, 5, 'App\\Models\\Project', 1, 'Proyek ini menarik! Saya punya beberapa ide yang bisa kita diskusikan.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(38, 6, 'App\\Models\\Project', 2, 'Proyek ini menarik! Saya punya beberapa ide yang bisa kita diskusikan.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(39, 7, 'App\\Models\\Project', 3, 'Proyek ini menarik! Saya punya beberapa ide yang bisa kita diskusikan.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(40, 8, 'App\\Models\\Project', 4, 'Proyek ini menarik! Saya punya beberapa ide yang bisa kita diskusikan.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(41, 9, 'App\\Models\\Project', 5, 'Proyek ini menarik! Saya punya beberapa ide yang bisa kita diskusikan.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(42, 3, 'App\\Models\\CommunityPost', 1, 'Setuju banget, ini juga jadi pengalaman saya.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(43, 4, 'App\\Models\\CommunityPost', 1, 'Wah, ide yang bagus! Saya mau ikut.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(44, 4, 'App\\Models\\CommunityPost', 2, 'Wah, ide yang bagus! Saya mau ikut.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(45, 5, 'App\\Models\\CommunityPost', 2, 'Terima kasih sudah berbagi, sangat membantu.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(46, 6, 'App\\Models\\CommunityPost', 2, 'Boleh saya coba ikut serta?', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(47, 5, 'App\\Models\\CommunityPost', 3, 'Terima kasih sudah berbagi, sangat membantu.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(48, 6, 'App\\Models\\CommunityPost', 3, 'Boleh saya coba ikut serta?', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(49, 7, 'App\\Models\\CommunityPost', 3, 'Setuju banget, ini juga jadi pengalaman saya.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(50, 8, 'App\\Models\\CommunityPost', 3, 'Wah, ide yang bagus! Saya mau ikut.', '2026-11-17 09:59:53', '2026-11-17 09:59:53');
INSERT INTO `comments` (`id`, `user_id`, `commentable_type`, `commentable_id`, `body`, `created_at`, `updated_at`) VALUES
(51, 6, 'App\\Models\\CommunityPost', 4, 'Boleh saya coba ikut serta?', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(52, 7, 'App\\Models\\CommunityPost', 4, 'Setuju banget, ini juga jadi pengalaman saya.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(53, 7, 'App\\Models\\CommunityPost', 5, 'Setuju banget, ini juga jadi pengalaman saya.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(54, 8, 'App\\Models\\CommunityPost', 5, 'Wah, ide yang bagus! Saya mau ikut.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(55, 9, 'App\\Models\\CommunityPost', 5, 'Terima kasih sudah berbagi, sangat membantu.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(56, 8, 'App\\Models\\CommunityPost', 6, 'Wah, ide yang bagus! Saya mau ikut.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(57, 9, 'App\\Models\\CommunityPost', 6, 'Terima kasih sudah berbagi, sangat membantu.', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(58, 10, 'App\\Models\\CommunityPost', 6, 'Boleh saya coba ikut serta?', '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(59, 1, 'App\\Models\\CommunityPost', 6, 'Setuju banget, ini juga jadi pengalaman saya.', '2026-11-17 09:59:53', '2026-11-17 09:59:53');

-- likes: 109 baris
INSERT INTO `likes` (`id`, `user_id`, `likeable_type`, `likeable_id`, `created_at`, `updated_at`) VALUES
(1, 1, 'App\\Models\\Artwork', 1, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(2, 2, 'App\\Models\\Artwork', 1, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(3, 3, 'App\\Models\\Artwork', 1, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(4, 2, 'App\\Models\\Artwork', 2, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(5, 3, 'App\\Models\\Artwork', 2, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(6, 4, 'App\\Models\\Artwork', 2, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(7, 5, 'App\\Models\\Artwork', 2, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(8, 3, 'App\\Models\\Artwork', 3, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(9, 4, 'App\\Models\\Artwork', 3, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(10, 5, 'App\\Models\\Artwork', 3, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(11, 6, 'App\\Models\\Artwork', 3, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(12, 7, 'App\\Models\\Artwork', 3, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(13, 4, 'App\\Models\\Artwork', 4, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(14, 5, 'App\\Models\\Artwork', 4, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(15, 6, 'App\\Models\\Artwork', 4, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(16, 7, 'App\\Models\\Artwork', 4, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(17, 8, 'App\\Models\\Artwork', 4, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(18, 9, 'App\\Models\\Artwork', 4, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(19, 5, 'App\\Models\\Artwork', 5, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(20, 6, 'App\\Models\\Artwork', 5, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(21, 7, 'App\\Models\\Artwork', 5, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(22, 8, 'App\\Models\\Artwork', 5, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(23, 9, 'App\\Models\\Artwork', 5, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(24, 10, 'App\\Models\\Artwork', 5, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(25, 1, 'App\\Models\\Artwork', 5, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(26, 6, 'App\\Models\\Artwork', 6, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(27, 7, 'App\\Models\\Artwork', 6, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(28, 8, 'App\\Models\\Artwork', 6, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(29, 9, 'App\\Models\\Artwork', 6, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(30, 10, 'App\\Models\\Artwork', 6, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(31, 1, 'App\\Models\\Artwork', 6, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(32, 2, 'App\\Models\\Artwork', 6, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(33, 3, 'App\\Models\\Artwork', 6, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(34, 7, 'App\\Models\\Artwork', 7, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(35, 8, 'App\\Models\\Artwork', 7, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(36, 9, 'App\\Models\\Artwork', 7, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(37, 10, 'App\\Models\\Artwork', 7, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(38, 1, 'App\\Models\\Artwork', 7, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(39, 2, 'App\\Models\\Artwork', 7, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(40, 3, 'App\\Models\\Artwork', 7, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(41, 4, 'App\\Models\\Artwork', 7, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(42, 5, 'App\\Models\\Artwork', 7, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(43, 8, 'App\\Models\\Artwork', 8, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(44, 9, 'App\\Models\\Artwork', 8, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(45, 10, 'App\\Models\\Artwork', 8, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(46, 1, 'App\\Models\\Artwork', 8, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(47, 2, 'App\\Models\\Artwork', 8, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(48, 3, 'App\\Models\\Artwork', 8, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(49, 4, 'App\\Models\\Artwork', 8, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(50, 5, 'App\\Models\\Artwork', 8, '2026-11-17 09:59:52', '2026-11-17 09:59:52');
INSERT INTO `likes` (`id`, `user_id`, `likeable_type`, `likeable_id`, `created_at`, `updated_at`) VALUES
(51, 6, 'App\\Models\\Artwork', 8, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(52, 7, 'App\\Models\\Artwork', 8, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(53, 9, 'App\\Models\\Artwork', 9, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(54, 10, 'App\\Models\\Artwork', 9, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(55, 1, 'App\\Models\\Artwork', 9, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(56, 10, 'App\\Models\\Artwork', 10, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(57, 1, 'App\\Models\\Artwork', 10, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(58, 2, 'App\\Models\\Artwork', 10, '2026-11-17 09:59:52', '2026-11-17 09:59:52'),
(59, 3, 'App\\Models\\Artwork', 10, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(60, 1, 'App\\Models\\Artwork', 11, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(61, 2, 'App\\Models\\Artwork', 11, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(62, 3, 'App\\Models\\Artwork', 11, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(63, 4, 'App\\Models\\Artwork', 11, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(64, 5, 'App\\Models\\Artwork', 11, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(65, 2, 'App\\Models\\Artwork', 12, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(66, 3, 'App\\Models\\Artwork', 12, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(67, 4, 'App\\Models\\Artwork', 12, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(68, 5, 'App\\Models\\Artwork', 12, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(69, 6, 'App\\Models\\Artwork', 12, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(70, 7, 'App\\Models\\Artwork', 12, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(71, 1, 'App\\Models\\CommunityPost', 1, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(72, 2, 'App\\Models\\CommunityPost', 1, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(73, 3, 'App\\Models\\CommunityPost', 1, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(74, 4, 'App\\Models\\CommunityPost', 1, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(75, 2, 'App\\Models\\CommunityPost', 2, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(76, 3, 'App\\Models\\CommunityPost', 2, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(77, 4, 'App\\Models\\CommunityPost', 2, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(78, 5, 'App\\Models\\CommunityPost', 2, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(79, 6, 'App\\Models\\CommunityPost', 2, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(80, 3, 'App\\Models\\CommunityPost', 3, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(81, 4, 'App\\Models\\CommunityPost', 3, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(82, 5, 'App\\Models\\CommunityPost', 3, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(83, 6, 'App\\Models\\CommunityPost', 3, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(84, 7, 'App\\Models\\CommunityPost', 3, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(85, 8, 'App\\Models\\CommunityPost', 3, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(86, 4, 'App\\Models\\CommunityPost', 4, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(87, 5, 'App\\Models\\CommunityPost', 4, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(88, 6, 'App\\Models\\CommunityPost', 4, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(89, 7, 'App\\Models\\CommunityPost', 4, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(90, 8, 'App\\Models\\CommunityPost', 4, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(91, 9, 'App\\Models\\CommunityPost', 4, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(92, 10, 'App\\Models\\CommunityPost', 4, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(93, 5, 'App\\Models\\CommunityPost', 5, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(94, 6, 'App\\Models\\CommunityPost', 5, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(95, 7, 'App\\Models\\CommunityPost', 5, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(96, 8, 'App\\Models\\CommunityPost', 5, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(97, 9, 'App\\Models\\CommunityPost', 5, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(98, 10, 'App\\Models\\CommunityPost', 5, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(99, 1, 'App\\Models\\CommunityPost', 5, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(100, 2, 'App\\Models\\CommunityPost', 5, '2026-11-17 09:59:53', '2026-11-17 09:59:53');
INSERT INTO `likes` (`id`, `user_id`, `likeable_type`, `likeable_id`, `created_at`, `updated_at`) VALUES
(101, 6, 'App\\Models\\CommunityPost', 6, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(102, 7, 'App\\Models\\CommunityPost', 6, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(103, 8, 'App\\Models\\CommunityPost', 6, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(104, 9, 'App\\Models\\CommunityPost', 6, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(105, 10, 'App\\Models\\CommunityPost', 6, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(106, 1, 'App\\Models\\CommunityPost', 6, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(107, 2, 'App\\Models\\CommunityPost', 6, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(108, 3, 'App\\Models\\CommunityPost', 6, '2026-11-17 09:59:53', '2026-11-17 09:59:53'),
(109, 4, 'App\\Models\\CommunityPost', 6, '2026-11-17 09:59:53', '2026-11-17 09:59:53');

-- community_posts: 6 baris
INSERT INTO `community_posts` (`id`, `user_id`, `title`, `body`, `topic`, `image`, `created_at`, `updated_at`) VALUES
(1, 1, 'Bagaimana cara kalian menemukan gaya visual sendiri?', 'Saya masih sering ragu saat memilih warna dan tipografi. Apakah ada proses atau latihan yang bisa membantu menemukan "suara visual" sendiri?', 'Diskusi Umum', NULL, '2026-11-16 09:59:53', '2026-11-17 09:59:53'),
(2, 5, 'Share portofolio kalian di sini!', 'Yuk pamerkan karya terbaru kita. Saya mau saling menginspirasi dan memberi masukan satu sama lain.', 'Portofolio', 'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?auto=format&fit=crop&w=800&q=80', '2026-11-15 09:59:53', '2026-11-17 09:59:53'),
(3, 10, 'Tips mengatur waktu saat mengerjakan banyak proyek', 'Saya biasa membagi hari menjadi blok fokus 90 menit dan istirahat 15 menit. Lumayan membantu menjaga kualitas kerja.', 'Tips & Trik', NULL, '2026-11-14 09:59:53', '2026-11-17 09:59:53'),
(4, 9, 'Mencari mentor untuk belajar motion design', 'Saya pemula di motion design dan ingin belajar dari teman-teman yang sudah berpengalaman. Ada yang mau berbagi?', 'Kolaborasi', NULL, '2026-11-13 09:59:53', '2026-11-17 09:59:53'),
(5, 3, 'Ide kecil: perpustakaan aset gratis untuk komunitas', 'Bagaimana kalau kita kumpulkan ikon, tekstur, dan template gratis yang bisa dipakai bersama? Bisa jadi proyek kolaborasi berikutnya.', 'Ide Proyek', NULL, '2026-11-12 09:59:53', '2026-11-17 09:59:53'),
(6, 4, 'Pameran karya digital bulan depan, siapa mau ikut?', 'Kami merencanakan pameran kecil-kecilan secara daring. Siapa pun boleh ikut, tidak perlu karya sempurna.', 'Acara', NULL, '2026-11-11 09:59:53', '2026-11-17 09:59:53');

-- notifications: 5 baris
INSERT INTO `notifications` (`id`, `user_id`, `from_user_id`, `type`, `title`, `body`, `link`, `data`, `read_at`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 'project', 'Pengajuan baru', 'Raka mengajukan diri untuk bergabung dengan proyek Platform Kolaborasi Kreator Lokal.', '/proyek/platform-kolaborasi-kreator-lokal', NULL, NULL, '2026-11-17 07:59:53', '2026-11-17 09:59:53'),
(2, 1, 5, 'artwork', 'Karya baru', 'Citra mempublikasikan karya baru berjudul "Tipografi Ekspresif".', '/galeri', NULL, NULL, '2026-11-16 23:59:53', '2026-11-17 09:59:53'),
(3, 1, 3, 'like', 'Suka baru', 'Salsa menyukai karya "Warna Kota Pagi" milikmu.', '/galeri', NULL, NULL, '2026-11-16 15:59:53', '2026-11-17 09:59:53'),
(4, 1, 9, 'comment', 'Komentar baru', 'Nabila berkomentar di karya "Komposisi 3D Soft".', '/galeri', NULL, NULL, '2026-11-16 07:59:53', '2026-11-17 09:59:53'),
(5, 1, 6, 'system', 'Selamat datang!', 'Profil kamu sudah aktif. Mulai jelajahi proyek dan temukan timmu.', '/proyek', NULL, '2026-11-15 09:59:53', '2026-11-15 23:59:53', '2026-11-17 09:59:53');

-- Sengaja kosong: sesi lama tidak diimpor
-- migrations: 14 baris
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2024_01_01_000000_create_passkeys_table', 1),
(5, '2024_01_02_000001_add_profile_fields_to_users_table', 1),
(6, '2024_01_02_000002_create_categories_table', 1),
(7, '2024_01_02_000003_create_projects_table', 1),
(8, '2024_01_02_000004_create_project_members_table', 1),
(9, '2024_01_02_000005_create_artworks_table', 1),
(10, '2024_01_02_000006_create_comments_table', 1),
(11, '2024_01_02_000007_create_likes_table', 1),
(12, '2024_01_02_000008_create_community_posts_table', 1),
(13, '2024_01_02_000009_create_notifications_table', 1),
(14, '2025_08_14_170933_add_two_factor_columns_to_users_table', 1);

SET FOREIGN_KEY_CHECKS=1;
