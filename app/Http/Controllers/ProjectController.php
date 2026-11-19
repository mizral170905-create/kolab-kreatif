<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Comment;
use App\Models\Notification;
use App\Models\Project;
use App\Models\ProjectMember;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class ProjectController extends Controller
{
    public function index(Request $request): Response
    {
        $projects = Project::query()
            ->with(['owner:id,name,expertise,avatar', 'category'])
            ->withCount(['acceptedMembers as members_count'])
            ->when($request->string('search')->toString(), function ($query, string $search) {
                $query->where(function ($q) use ($search) {
                    $q->where('title', 'like', "%{$search}%")
                        ->orWhere('description', 'like', "%{$search}%");
                });
            })
            ->when($request->string('category')->toString(), function ($query, string $category) {
                $query->whereHas('category', fn ($q) => $q->where('slug', $category));
            })
            ->when($request->string('status')->toString(), function ($query, string $status) {
                $query->where('status', $status);
            })
            ->latest()
            ->paginate(9)
            ->withQueryString();

        return Inertia::render('Projects/Index', [
            'projects' => $projects,
            'categories' => Category::withCount('projects')->get(),
            'filters' => $request->only(['search', 'category', 'status']),
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('Projects/Create', [
            'categories' => Category::orderBy('name')->get(),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:150',
            'description' => 'required|string|min:20',
            'category_id' => 'required|exists:categories,id',
            'required_skills' => 'nullable|array',
            'required_skills.*' => 'string|max:50',
            'team_size' => 'required|integer|min:1|max:20',
            'deadline' => 'nullable|date|after:today',
            'cover_image' => 'nullable|url|max:2048',
        ]);

        $project = $request->user()->projects()->create($validated);

        ProjectMember::create([
            'project_id' => $project->id,
            'user_id' => $request->user()->id,
            'status' => 'accepted',
            'role' => 'Pemilik Proyek',
        ]);

        return redirect()->route('projects.show', $project->slug)
            ->with('success', 'Proyek berhasil dibuat! Sekarang kamu bisa mencari anggota tim.');
    }

    public function show(Project $project): Response
    {
        $user = request()->user();

        $project->load([
            'owner:id,name,expertise,avatar,bio,location',
            'category',
            'acceptedMembers.user:id,name,expertise,avatar',
            'comments.user:id,name,avatar',
            'artworks' => fn ($q) => $q->withCount(['likes as likes_count'])->take(4),
        ]);

        $project->increment('views');

        $myMembership = $user
            ? $project->members()->where('user_id', $user->id)->first()
            : null;

        return Inertia::render('Projects/Show', [
            'project' => $project,
            'myMembership' => $myMembership,
            'pendingMembers' => $user && $project->user_id === $user->id
                ? $project->pendingMembers()->with('user:id,name,expertise,avatar')->get()
                : [],
            'canManage' => $user && $project->user_id === $user->id,
            'related' => Project::where('category_id', $project->category_id)
                ->where('id', '!=', $project->id)
                ->with(['owner:id,name,avatar', 'category'])
                ->take(3)
                ->get(),
        ]);
    }

    public function join(Request $request, Project $project): RedirectResponse
    {
        $user = $request->user();

        if ($project->user_id === $user->id) {
            return back()->with('error', 'Kamu adalah pemilik proyek ini.');
        }

        if ($project->status === 'completed') {
            return back()->with('error', 'Proyek ini sudah selesai.');
        }

        if ($project->is_full) {
            return back()->with('error', 'Tim proyek ini sudah penuh.');
        }

        $existing = $project->members()->where('user_id', $user->id)->first();

        if ($existing) {
            return back()->with('error', match ($existing->status) {
                'pending' => 'Pengajuanmu masih menunggu persetujuan.',
                'rejected' => 'Pengajuanmu sebelumnya ditolak.',
                default => 'Kamu sudah menjadi anggota proyek ini.',
            });
        }

        $validated = $request->validate([
            'message' => 'nullable|string|max:500',
        ]);

        $project->members()->create([
            'user_id' => $user->id,
            'status' => 'pending',
            'role' => $user->expertise ?? 'Anggota Tim',
            'message' => $validated['message'] ?? null,
        ]);

        Notification::create([
            'user_id' => $project->user_id,
            'from_user_id' => $user->id,
            'type' => 'project',
            'title' => 'Permintaan bergabung',
            'body' => "{$user->name} ingin bergabung dengan proyek \"{$project->title}\".",
            'link' => "/proyek/{$project->slug}",
        ]);

        return back()->with('success', 'Pengajuan terkirim! Pemilik proyek akan meninjau permintaanmu.');
    }

    public function updateMember(Request $request, Project $project, ProjectMember $member): RedirectResponse
    {
        if ($project->user_id !== $request->user()->id) {
            abort(403);
        }

        $validated = $request->validate([
            'status' => 'required|in:accepted,rejected',
        ]);

        $member->update($validated);

        Notification::create([
            'user_id' => $member->user_id,
            'from_user_id' => $request->user()->id,
            'type' => 'project',
            'title' => $validated['status'] === 'accepted' ? 'Kamu diterima!' : 'Pengajuan ditolak',
            'body' => $validated['status'] === 'accepted'
                ? "Selamat! Kamu diterima sebagai anggota proyek \"{$project->title}\"."
                : "Pengajuanmu untuk proyek \"{$project->title}\" belum disetujui.",
            'link' => "/proyek/{$project->slug}",
        ]);

        return back()->with('success', 'Status anggota berhasil diperbarui.');
    }

    public function updateStatus(Request $request, Project $project): RedirectResponse
    {
        if ($project->user_id !== $request->user()->id) {
            abort(403);
        }

        $validated = $request->validate([
            'status' => 'required|in:open,in_progress,completed',
        ]);

        $project->update($validated);

        return back()->with('success', 'Status proyek berhasil diperbarui.');
    }

    public function comment(Request $request, Project $project): RedirectResponse
    {
        $validated = $request->validate([
            'body' => 'required|string|max:1000',
        ]);

        $project->comments()->create([
            'user_id' => $request->user()->id,
            'body' => $validated['body'],
        ]);

        return back()->with('success', 'Komentar berhasil ditambahkan.');
    }

    public function destroy(Request $request, Project $project): RedirectResponse
    {
        if ($project->user_id !== $request->user()->id) {
            abort(403);
        }

        $project->delete();

        return redirect()->route('projects.index')->with('success', 'Proyek berhasil dihapus.');
    }
}
