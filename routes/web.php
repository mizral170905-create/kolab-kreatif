<?php

use App\Http\Controllers\AboutController;
use App\Http\Controllers\ArtworkController;
use App\Http\Controllers\CommunityController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\ProjectController;
use Illuminate\Support\Facades\Route;

Route::get('/', [HomeController::class, 'index'])->name('home');

Route::get('/proyek', [ProjectController::class, 'index'])->name('projects.index');
Route::get('/proyek/buat', [ProjectController::class, 'create'])->name('projects.create')->middleware('auth');
Route::post('/proyek', [ProjectController::class, 'store'])->name('projects.store')->middleware('auth');
Route::get('/proyek/{project:slug}', [ProjectController::class, 'show'])->name('projects.show');
Route::post('/proyek/{project:slug}/gabung', [ProjectController::class, 'join'])->name('projects.join')->middleware('auth');
Route::patch('/proyek/{project:slug}/anggota/{member}', [ProjectController::class, 'updateMember'])->name('projects.member.update')->middleware('auth');
Route::patch('/proyek/{project:slug}/status', [ProjectController::class, 'updateStatus'])->name('projects.status')->middleware('auth');
Route::post('/proyek/{project:slug}/komentar', [ProjectController::class, 'comment'])->name('projects.comment')->middleware('auth');
Route::delete('/proyek/{project:slug}', [ProjectController::class, 'destroy'])->name('projects.destroy')->middleware('auth');

Route::get('/galeri', [ArtworkController::class, 'index'])->name('artworks.index');
Route::get('/galeri/unggah', [ArtworkController::class, 'create'])->name('artworks.create')->middleware('auth');
Route::post('/galeri', [ArtworkController::class, 'store'])->name('artworks.store')->middleware('auth');
Route::get('/karya/{artwork}', [ArtworkController::class, 'show'])->name('artworks.show');
Route::post('/karya/{artwork}/suka', [ArtworkController::class, 'like'])->name('artworks.like')->middleware('auth');
Route::post('/karya/{artwork}/komentar', [ArtworkController::class, 'comment'])->name('artworks.comment')->middleware('auth');

Route::get('/komunitas', [CommunityController::class, 'index'])->name('community.index');
Route::post('/komunitas', [CommunityController::class, 'store'])->name('community.store')->middleware('auth');
Route::post('/komunitas/{post}/komentar', [CommunityController::class, 'comment'])->name('community.comment')->middleware('auth');
Route::post('/komunitas/{post}/suka', [CommunityController::class, 'like'])->name('community.like')->middleware('auth');

Route::get('/profil/{user}', [ProfileController::class, 'show'])->name('profile.show');
Route::patch('/profil', [ProfileController::class, 'update'])->name('creator.update')->middleware('auth');

Route::get('/tentang-kami', [AboutController::class, 'index'])->name('about');

Route::middleware('auth')->group(function () {
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');
    Route::get('/notifikasi', [NotificationController::class, 'index'])->name('notifications.index');
    Route::patch('/notifikasi/{notification}', [NotificationController::class, 'read'])->name('notifications.read');
    Route::post('/notifikasi/dibaca-semua', [NotificationController::class, 'readAll'])->name('notifications.readAll');
});

require __DIR__.'/settings.php';
