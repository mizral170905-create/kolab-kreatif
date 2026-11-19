<?php

namespace Database\Seeders;

use App\Models\Artwork;
use App\Models\Category;
use App\Models\Comment;
use App\Models\CommunityPost;
use App\Models\Like;
use App\Models\Notification;
use App\Models\Project;
use App\Models\ProjectMember;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    private function img(string $id, int $w = 1200): string
    {
        return "https://images.unsplash.com/{$id}?auto=format&fit=crop&w={$w}&q=80";
    }

    public function run(): void
    {
        $categories = [
            ['name' => 'Desain Grafis', 'icon' => 'palette', 'color' => '#8b5cf6', 'description' => 'Logo, branding, poster, dan identitas visual.'],
            ['name' => 'Pemrograman', 'icon' => 'code', 'color' => '#3b82f6', 'description' => 'Web, aplikasi, dan pengembangan perangkat lunak.'],
            ['name' => 'Fotografi', 'icon' => 'camera', 'color' => '#f97316', 'description' => 'Foto produk, portrait, dokumentasi, dan editorial.'],
            ['name' => 'Videografi', 'icon' => 'video', 'color' => '#ec4899', 'description' => 'Video promosi, dokumenter, dan konten kreatif.'],
            ['name' => 'Penulisan', 'icon' => 'pen', 'color' => '#14b8a6', 'description' => 'Copywriting, artikel, cerita, dan konten editorial.'],
            ['name' => 'Ilustrasi', 'icon' => 'brush', 'color' => '#6366f1', 'description' => 'Ilustrasi digital, karakter, dan seni visual.'],
        ];

        foreach ($categories as $category) {
            Category::updateOrCreate(
                ['slug' => Str::slug($category['name'])],
                $category,
            );
        }

        $people = [
            ['Nadia Putri', 'nadia@kolabkreatif.test', 'UI/UX Designer', 'Jakarta, Indonesia', ['Figma', 'UI Design', 'Prototyping'], 'Designer produk yang suka merubah ide kompleks jadi pengalaman sederhana.'],
            ['Raka Pratama', 'raka@kolabkreatif.test', 'Frontend Developer', 'Bandung, Indonesia', ['Vue.js', 'Laravel', 'TypeScript'], 'Fullstack developer dengan fokus pada performa dan detail.'],
            ['Salsa Amelia', 'salsa@kolabkreatif.test', 'Ilustrator', 'Yogyakarta, Indonesia', ['Procreate', 'Karakter', 'Storytelling'], 'Menggambar cerita kecil lewat warna dan karakter.'],
            ['Bagus Setiawan', 'bagus@kolabkreatif.test', 'Fotografer', 'Surabaya, Indonesia', ['Fotografi Produk', 'Lightroom', 'Portrait'], 'Menangkap momen yang sering terlewat.'],
            ['Citra Maharani', 'citra@kolabkreatif.test', 'Graphic Designer', 'Jakarta, Indonesia', ['Branding', 'Typography', 'Adobe CC'], 'Membangun identitas visual yang berkesan.'],
            ['Farhan Aditya', 'farhan@kolabkreatif.test', 'Video Editor', 'Semarang, Indonesia', ['Premiere Pro', 'Motion Graphics', 'Coloring'], 'Bercerita lewat ritme dan gambar.'],
            ['Alya Rahma', 'alya@kolabkreatif.test', 'Penulis Konten', 'Malang, Indonesia', ['Copywriting', 'Editorial', 'SEO'], 'Menulis kata-kata yang terasa seperti percakapan.'],
            ['Dimas Prasetyo', 'dimas@kolabkreatif.test', '3D Artist', 'Tangerang, Indonesia', ['Blender', '3D Modeling', 'Rendering'], 'Membuat dunia imajiner terasa nyata.'],
            ['Nabila Zahra', 'nabila@kolabkreatif.test', 'Motion Designer', 'Depok, Indonesia', ['After Effects', 'Animasi', 'UI Motion'], 'Animasi yang bikin produk terasa hidup.'],
            ['Reza Firmansyah', 'reza@kolabkreatif.test', 'Product Designer', 'Bekasi, Indonesia', ['Research', 'Wireframe', 'Design System'], 'Memecahkan masalah lewat desain berbasis riset.'],
        ];

        $users = [];
        foreach ($people as $index => $person) {
            [$name, $email, $expertise, $location, $skills, $bio] = $person;
            $users[] = User::updateOrCreate(
                ['email' => $email],
                [
                    'name' => $name,
                    'username' => Str::slug($name, '.'),
                    'password' => Hash::make('password'),
                    'expertise' => $expertise,
                    'skills' => $skills,
                    'bio' => $bio,
                    'location' => $location,
                    'avatar' => 'https://i.pravatar.cc/300?img='.(($index * 7) + 5),
                    'email_verified_at' => now(),
                    'website' => 'https://kolabkreatif.test',
                    'github' => 'https://github.com',
                    'instagram' => 'https://instagram.com',
                    'dribbble' => 'https://dribbble.com',
                ],
            );
        }

        $cat = fn (string $name) => Category::where('name', $name)->first()->id;

        $projectData = [
            ['Platform Kolaborasi Kreator Lokal', 'Pemrograman', 0, ['Vue.js', 'Laravel', 'UI Design'], 5, 'open', 'photo-1498050108023-c5249f4df085', 'Membangun platform web untuk menghubungkan kreator lokal dengan klien dan sesama kolaborator. Fokus pada kemudahan pencarian tim dan manajemen proyek.'],
            ['Identitas Visual Kopi Senja', 'Desain Grafis', 4, ['Logo Design', 'Branding', 'Packaging'], 3, 'open', 'photo-1558655146-9f40138edfeb', 'Menciptakan identitas visual hangat untuk brand kopi lokal. Termasuk logo, palet warna, dan desain kemasan.'],
            ['Seri Ilustrasi "Cerita Kota"', 'Ilustrasi', 2, ['Ilustrasi Digital', 'Karakter', 'Warna'], 4, 'open', 'photo-1513364776144-60967b0f800f', 'Seri ilustrasi yang menceritakan sudut-sudut kota yang penuh kenangan. Akan ditampilkan dalam pameran kecil.'],
            ['Dokumentasi Komunitas Seni', 'Fotografi', 3, ['Fotografi Dokumenter', 'Editing'], 3, 'in_progress', 'photo-1500534314209-a25ddb2bd429', 'Mendokumentasikan aktivitas komunitas seni selama tiga bulan untuk arsip dan publikasi daring.'],
            ['Video Profil Studio Kreatif', 'Videografi', 5, ['Videografi', 'Motion Graphics', 'Sound Design'], 4, 'open', 'photo-1485846234645-a62644f84728', 'Video profil 2 menit untuk memperkenalkan studio kreatif dan karya-karyanya kepada calon klien.'],
            ['Panduan Menulis untuk Kreator', 'Penulisan', 6, ['Copywriting', 'Editorial', 'Proofreading'], 2, 'open', 'photo-1455390582262-044cdead277a', 'E-book pendek berisi panduan menulis konten kreatif yang autentik dan mudah dipahami.'],
            ['Aplikasi Mobile Catatan Ide', 'Pemrograman', 1, ['React Native', 'UI Design', 'Backend'], 4, 'in_progress', 'photo-1550745165-9bc0b252726f', 'Aplikasi mobile sederhana untuk menyimpan dan mengorganisir ide-ide kreatif dengan sinkronisasi cloud.'],
            ['Eksperimen Seni 3D Abstrak', 'Ilustrasi', 7, ['Blender', '3D', 'Rendering'], 3, 'open', 'photo-1618005182384-a83a8bd57fbe', 'Eksplorasi bentuk dan cahaya dalam seni 3D abstrak untuk koleksi poster digital.'],
            ['Motion Branding KolabKreatif', 'Videografi', 8, ['After Effects', 'Animasi', 'Branding'], 3, 'completed', 'photo-1531403009284-440f080d1e12', 'Paket animasi logo dan transisi untuk kebutuhan branding video KolabKreatif.'],
        ];

        $projects = [];
        foreach ($projectData as $index => $p) {
            [$title, $categoryName, $ownerIndex, $skills, $teamSize, $status, $photo, $description] = $p;
            $projects[] = Project::updateOrCreate(
                ['slug' => Str::slug($title)],
                [
                    'title' => $title,
                    'user_id' => $users[$ownerIndex]->id,
                    'category_id' => $cat($categoryName),
                    'description' => $description,
                    'required_skills' => $skills,
                    'team_size' => $teamSize,
                    'deadline' => now()->addDays(7 + ($index * 6))->toDateString(),
                    'cover_image' => $this->img($photo),
                    'status' => $status,
                    'views' => 40 + ($index * 37),
                ],
            );
        }

        $membershipPlan = [
            [0, 1, 'accepted', 'Frontend Developer'],
            [0, 4, 'accepted', 'UI Designer'],
            [0, 9, 'pending', 'Product Designer'],
            [1, 2, 'accepted', 'Ilustrator'],
            [1, 6, 'pending', 'Copywriter'],
            [2, 7, 'accepted', '3D Artist'],
            [2, 8, 'pending', 'Motion Designer'],
            [3, 3, 'accepted', 'Fotografer'],
            [3, 5, 'accepted', 'Video Editor'],
            [4, 8, 'accepted', 'Motion Designer'],
            [4, 1, 'pending', 'Developer'],
            [5, 6, 'accepted', 'Penulis'],
            [6, 1, 'accepted', 'Developer'],
            [6, 4, 'accepted', 'UI Designer'],
            [7, 2, 'pending', 'Ilustrator'],
            [8, 8, 'accepted', 'Motion Designer'],
        ];

        foreach ($membershipPlan as [$projectIndex, $userIndex, $status, $role]) {
            ProjectMember::updateOrCreate(
                ['project_id' => $projects[$projectIndex]->id, 'user_id' => $users[$userIndex]->id],
                ['status' => $status, 'role' => $role],
            );
        }

        foreach ($projects as $project) {
            ProjectMember::firstOrCreate(
                ['project_id' => $project->id, 'user_id' => $project->user_id],
                ['status' => 'accepted', 'role' => 'Pemilik Proyek'],
            );
        }

        $artworkData = [
            ['Warna Kota Pagi', 2, 'Ilustrasi', 'photo-1541701494587-cb58502866ab', true, 'Eksplorasi warna dan geometri dari sudut kota di pagi hari.'],
            ['Minimalisme dalam Desain', 4, 'Desain Grafis', 'photo-1558655146-9f40138edfeb', true, 'Studi tentang kesederhanaan bentuk dan tipografi.'],
            ['Sesi Portrait Studio', 3, 'Fotografi', 'photo-1500534314209-a25ddb2bd429', true, 'Potret natural dengan pencahayaan sore hari.'],
            ['Antarmuka Aplikasi Catatan', 1, 'Pemrograman', 'photo-1460925895917-afdab827c52f', false, 'Tampilan dashboard aplikasi pencatat ide yang sedang kami kembangkan.'],
            ['Frame Video Dokumenter', 5, 'Videografi', 'photo-1485846234645-a62644f84728', false, 'Beberapa frame favorit dari proses penyuntingan dokumenter komunitas.'],
            ['Karakter Si Kecil', 2, 'Ilustrasi', 'photo-1513364776144-60967b0f800f', true, 'Desain karakter untuk seri cerita anak yang sedang dikerjakan.'],
            ['Komposisi 3D Soft', 7, 'Ilustrasi', 'photo-1618005182384-a83a8bd57fbe', false, 'Eksperimen material dan cahaya di Blender.'],
            ['Tipografi Ekspresif', 4, 'Desain Grafis', 'photo-1524178232363-1fb2b075b655', false, 'Percobaan komposisi huruf dengan pendekatan yang berani.'],
            ['Team Brainstorming', 0, 'Pemrograman', 'photo-1522202176988-66273c2fd55f', true, 'Dokumentasi sesi diskusi tim saat memulai proyek pertama kami.'],
            ['Kolase Digital Musim Panas', 8, 'Videografi', 'photo-1614850523459-c2f4c699c52e', false, 'Kolase warna cerah untuk kebutuhan konten media sosial.'],
            ['Kopi Senja Packaging', 4, 'Desain Grafis', 'photo-1511920170033-f8396924c348', true, 'Hasil akhir desain kemasan kopi senja.'],
            ['Studio Kreatif', 9, 'Pemrograman', 'photo-1516321318423-f06f85e504b3', false, 'Suasana ruang kerja tim kreatif saat proses produksi.'],
        ];

        $artworks = [];
        foreach ($artworkData as $index => $a) {
            [$title, $userIndex, $categoryName, $photo, $featured, $description] = $a;
            $artworks[] = Artwork::updateOrCreate(
                ['title' => $title],
                [
                    'user_id' => $users[$userIndex]->id,
                    'category_id' => $cat($categoryName),
                    'project_id' => $projects[$index % count($projects)]->id,
                    'description' => $description,
                    'image' => $this->img($photo),
                    'is_featured' => $featured,
                    'views' => 100 + ($index * 53),
                ],
            );
        }

        $commentTexts = [
            'Warnanya sangat menenangkan! Keren banget karyanya 👏',
            'Komposisinya menarik, bisa sharing prosesnya?',
            'Ini menginspirasi saya untuk mulai eksperimen juga.',
            'Detail kecilnya bikin beda. Mantap!',
            'Suka banget dengan pendekatan warnanya.',
        ];

        foreach ($artworks as $index => $artwork) {
            for ($i = 0; $i < 2 + ($index % 3); $i++) {
                Comment::create([
                    'user_id' => $users[($index + $i + 1) % count($users)]->id,
                    'commentable_type' => Artwork::class,
                    'commentable_id' => $artwork->id,
                    'body' => $commentTexts[($index + $i) % count($commentTexts)],
                    'created_at' => now()->subHours(($index * 5) + $i),
                ]);
            }
            for ($i = 0; $i < 3 + ($index % 8); $i++) {
                Like::firstOrCreate([
                    'user_id' => $users[($index + $i) % count($users)]->id,
                    'likeable_type' => Artwork::class,
                    'likeable_id' => $artwork->id,
                ]);
            }
        }

        foreach (array_slice($projects, 0, 5) as $index => $project) {
            Comment::create([
                'user_id' => $users[($index + 4) % count($users)]->id,
                'commentable_type' => Project::class,
                'commentable_id' => $project->id,
                'body' => 'Proyek ini menarik! Saya punya beberapa ide yang bisa kita diskusikan.',
            ]);
        }

        $postData = [
            ['Bagaimana cara kalian menemukan gaya visual sendiri?', 'Diskusi Umum', 0, 'Saya masih sering ragu saat memilih warna dan tipografi. Apakah ada proses atau latihan yang bisa membantu menemukan "suara visual" sendiri?'],
            ['Share portofolio kalian di sini!', 'Portofolio', 4, 'Yuk pamerkan karya terbaru kita. Saya mau saling menginspirasi dan memberi masukan satu sama lain.'],
            ['Tips mengatur waktu saat mengerjakan banyak proyek', 'Tips & Trik', 9, 'Saya biasa membagi hari menjadi blok fokus 90 menit dan istirahat 15 menit. Lumayan membantu menjaga kualitas kerja.'],
            ['Mencari mentor untuk belajar motion design', 'Kolaborasi', 8, 'Saya pemula di motion design dan ingin belajar dari teman-teman yang sudah berpengalaman. Ada yang mau berbagi?'],
            ['Ide kecil: perpustakaan aset gratis untuk komunitas', 'Ide Proyek', 2, 'Bagaimana kalau kita kumpulkan ikon, tekstur, dan template gratis yang bisa dipakai bersama? Bisa jadi proyek kolaborasi berikutnya.'],
            ['Pameran karya digital bulan depan, siapa mau ikut?', 'Acara', 3, 'Kami merencanakan pameran kecil-kecilan secara daring. Siapa pun boleh ikut, tidak perlu karya sempurna.'],
        ];

        $posts = [];
        foreach ($postData as $index => $post) {
            [$title, $topic, $userIndex, $body] = $post;
            $posts[] = CommunityPost::create([
                'user_id' => $users[$userIndex]->id,
                'title' => $title,
                'topic' => $topic,
                'body' => $body,
                'image' => $index === 1 ? $this->img('photo-1524178232363-1fb2b075b655', 800) : null,
                'created_at' => now()->subDays($index + 1),
            ]);
        }

        foreach ($posts as $index => $post) {
            for ($i = 0; $i < 2 + ($index % 3); $i++) {
                Comment::create([
                    'user_id' => $users[($index + $i + 2) % count($users)]->id,
                    'commentable_type' => CommunityPost::class,
                    'commentable_id' => $post->id,
                    'body' => [
                        'Setuju banget, ini juga jadi pengalaman saya.',
                        'Wah, ide yang bagus! Saya mau ikut.',
                        'Terima kasih sudah berbagi, sangat membantu.',
                        'Boleh saya coba ikut serta?',
                    ][($index + $i) % 4],
                ]);
            }
            for ($i = 0; $i < 4 + ($index % 6); $i++) {
                Like::firstOrCreate([
                    'user_id' => $users[($index + $i) % count($users)]->id,
                    'likeable_type' => CommunityPost::class,
                    'likeable_id' => $post->id,
                ]);
            }
        }

        $notificationData = [
            ['Raka Pratama', 'project', 'Pengajuan baru', 'Raka mengajukan diri untuk bergabung dengan proyek Platform Kolaborasi Kreator Lokal.', '/proyek/'.Str::slug('Platform Kolaborasi Kreator Lokal')],
            ['Citra Maharani', 'artwork', 'Karya baru', 'Citra mempublikasikan karya baru berjudul "Tipografi Ekspresif".', '/galeri'],
            ['Salsa Amelia', 'like', 'Suka baru', 'Salsa menyukai karya "Warna Kota Pagi" milikmu.', '/galeri'],
            ['Nabila Zahra', 'comment', 'Komentar baru', 'Nabila berkomentar di karya "Komposisi 3D Soft".', '/galeri'],
            ['Farhan Aditya', 'system', 'Selamat datang!', 'Profil kamu sudah aktif. Mulai jelajahi proyek dan temukan timmu.', '/proyek'],
        ];

        foreach ($notificationData as $index => $n) {
            [$name, $type, $title, $body, $link] = $n;
            $from = User::where('name', $name)->first();
            Notification::firstOrCreate(
                ['user_id' => $users[0]->id, 'title' => $title, 'from_user_id' => $from?->id],
                [
                    'type' => $type,
                    'body' => $body,
                    'link' => $link,
                    'read_at' => $index === 4 ? now()->subDays(2) : null,
                    'created_at' => now()->subHours($index * 8 + 2),
                ],
            );
        }
    }
}
