<?php

namespace App\Http\Controllers;

use App\Models\Artwork;
use App\Models\Category;
use App\Models\Like;
use App\Models\Notification;
use App\Models\Project;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class ArtworkController extends Controller
{
    public function index(Request $request): Response
    {
        $artworks = Artwork::query()
            ->with(['user:id,name,expertise,avatar', 'category'])
            ->withCount(['likes as likes_count', 'comments as comments_count'])
            ->when($request->string('search')->toString(), function ($query, string $search) {
                $query->where(function ($q) use ($search) {
                    $q->where('title', 'like', "%{$search}%")
                        ->orWhere('description', 'like', "%{$search}%");
                });
            })
            ->when($request->string('category')->toString(), function ($query, string $category) {
                $query->whereHas('category', fn ($q) => $q->where('slug', $category));
            })
            ->when($request->string('sort')->toString() === 'popular', function ($query) {
                $query->orderByDesc('likes_count');
            }, fn ($query) => $query->latest())
            ->paginate(12)
            ->withQueryString();

        $likedIds = $request->user()
            ? Like::where('user_id', $request->user()->id)
                ->where('likeable_type', Artwork::class)
                ->pluck('likeable_id')
                ->all()
            : [];

        return Inertia::render('Artworks/Index', [
            'artworks' => $artworks,
            'categories' => Category::withCount('artworks')->get(),
            'likedIds' => $likedIds,
            'filters' => $request->only(['search', 'category', 'sort']),
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('Artworks/Create', [
            'categories' => Category::orderBy('name')->get(),
            'projects' => request()->user()->projects()->select('id', 'title')->get(),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:150',
            'description' => 'required|string|min:10',
            'category_id' => 'nullable|exists:categories,id',
            'project_id' => 'nullable|exists:projects,id',
            'image' => 'nullable|image|max:5120',
            'image_url' => 'nullable|url|max:2048',
            'is_featured' => 'boolean',
        ]);

        if (! $request->hasFile('image') && ! $request->filled('image_url')) {
            return back()->withErrors(['image' => 'Silakan unggah gambar atau isi URL gambar.'])->withInput();
        }

        $imagePath = $request->hasFile('image')
            ? $request->file('image')->store('artworks', 'public')
            : $validated['image_url'];

        $artwork = $request->user()->artworks()->create([
            'title' => $validated['title'],
            'description' => $validated['description'],
            'category_id' => $validated['category_id'] ?? null,
            'project_id' => $validated['project_id'] ?? null,
            'image' => $imagePath,
            'is_featured' => $validated['is_featured'] ?? false,
        ]);

        return redirect()->route('artworks.show', $artwork->id)
            ->with('success', 'Karya berhasil dipublikasikan!');
    }

    public function show(Artwork $artwork): Response
    {
        $artwork->load([
            'user:id,name,expertise,avatar,bio,location',
            'category',
            'project:id,title,slug',
            'comments.user:id,name,avatar,expertise',
        ]);
        $artwork->increment('views');

        return Inertia::render('Artworks/Show', [
            'artwork' => $artwork,
            'likesCount' => $artwork->likes()->count(),
            'likedByMe' => request()->user()
                ? $artwork->likes()->where('user_id', request()->user()->id)->exists()
                : false,
            'related' => Artwork::where('category_id', $artwork->category_id)
                ->where('id', '!=', $artwork->id)
                ->with(['user:id,name,avatar'])
                ->withCount(['likes as likes_count'])
                ->take(4)
                ->get(),
        ]);
    }

    public function like(Request $request, Artwork $artwork): RedirectResponse
    {
        $like = Like::where('user_id', $request->user()->id)
            ->where('likeable_type', Artwork::class)
            ->where('likeable_id', $artwork->id)
            ->first();

        if ($like) {
            $like->delete();
            return back()->with('success', 'Suka dibatalkan.');
        }

        Like::create([
            'user_id' => $request->user()->id,
            'likeable_type' => Artwork::class,
            'likeable_id' => $artwork->id,
        ]);

        if ($artwork->user_id !== $request->user()->id) {
            Notification::create([
                'user_id' => $artwork->user_id,
                'from_user_id' => $request->user()->id,
                'type' => 'like',
                'title' => 'Karyamu disukai',
                'body' => "{$request->user()->name} menyukai karya \"{$artwork->title}\".",
                'link' => "/karya/{$artwork->id}",
            ]);
        }

        return back()->with('success', 'Kamu menyukai karya ini.');
    }

    public function comment(Request $request, Artwork $artwork): RedirectResponse
    {
        $validated = $request->validate([
            'body' => 'required|string|max:1000',
        ]);

        $artwork->comments()->create([
            'user_id' => $request->user()->id,
            'body' => $validated['body'],
        ]);

        if ($artwork->user_id !== $request->user()->id) {
            Notification::create([
                'user_id' => $artwork->user_id,
                'from_user_id' => $request->user()->id,
                'type' => 'comment',
                'title' => 'Komentar baru',
                'body' => "{$request->user()->name} berkomentar di karya \"{$artwork->title}\".",
                'link' => "/karya/{$artwork->id}",
            ]);
        }

        return back()->with('success', 'Komentar berhasil ditambahkan.');
    }
}
