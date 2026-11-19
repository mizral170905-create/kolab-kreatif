<?php

namespace App\Http\Controllers;

use App\Models\CommunityPost;
use App\Models\Like;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class CommunityController extends Controller
{
    public function index(Request $request): Response
    {
        $posts = CommunityPost::query()
            ->with(['user:id,name,expertise,avatar'])
            ->withCount(['likes as likes_count', 'comments as comments_count'])
            ->when($request->string('topic')->toString(), function ($query, string $topic) {
                $query->where('topic', $topic);
            })
            ->when($request->string('search')->toString(), function ($query, string $search) {
                $query->where(function ($q) use ($search) {
                    $q->where('title', 'like', "%{$search}%")
                        ->orWhere('body', 'like', "%{$search}%");
                });
            })
            ->with('comments.user:id,name,avatar')
            ->latest()
            ->paginate(8)
            ->withQueryString();

        $likedIds = $request->user()
            ? Like::where('user_id', $request->user()->id)
                ->where('likeable_type', CommunityPost::class)
                ->pluck('likeable_id')
                ->all()
            : [];

        return Inertia::render('Community', [
            'posts' => $posts,
            'topics' => ['Diskusi Umum', 'Portofolio', 'Tips & Trik', 'Kolaborasi', 'Ide Proyek', 'Acara'],
            'members' => \App\Models\User::select('id', 'name', 'expertise', 'avatar')->latest()->take(8)->get(),
            'likedIds' => $likedIds,
            'filters' => $request->only(['topic', 'search']),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:150',
            'body' => 'required|string|min:10',
            'topic' => 'required|string|max:50',
        ]);

        $request->user()->communityPosts()->create($validated);

        return back()->with('success', 'Postingan berhasil diterbitkan!');
    }

    public function comment(Request $request, CommunityPost $post): RedirectResponse
    {
        $validated = $request->validate([
            'body' => 'required|string|max:1000',
        ]);

        $post->comments()->create([
            'user_id' => $request->user()->id,
            'body' => $validated['body'],
        ]);

        return back()->with('success', 'Komentar berhasil ditambahkan.');
    }

    public function like(Request $request, CommunityPost $post): RedirectResponse
    {
        $like = Like::where('user_id', $request->user()->id)
            ->where('likeable_type', CommunityPost::class)
            ->where('likeable_id', $post->id)
            ->first();

        if ($like) {
            $like->delete();
        } else {
            Like::create([
                'user_id' => $request->user()->id,
                'likeable_type' => CommunityPost::class,
                'likeable_id' => $post->id,
            ]);
        }

        return back()->with('success', 'Interaksi tersimpan.');
    }
}
