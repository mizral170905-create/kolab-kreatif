<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Inertia\Response;

class ProfileController extends Controller
{
    public function show(User $user): Response
    {
        $user->load([
            'projects' => fn ($q) => $q->with('category:id,name,color')->withCount(['acceptedMembers as members_count'])->latest()->take(6),
            'artworks' => fn ($q) => $q->withCount(['likes as likes_count'])->latest()->take(6),
        ]);

        return Inertia::render('Profile', [
            'profile' => $user,
            'collaborations' => $user->projectMemberships()
                ->with(['project:id,title,slug,deadline,status', 'project.category:id,name,color'])
                ->where('status', 'accepted')
                ->latest()
                ->take(6)
                ->get(),
            'isOwn' => request()->user()?->id === $user->id,
        ]);
    }

    public function update(Request $request): RedirectResponse
    {
        $user = $request->user();

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => ['required', 'email', 'max:255', Rule::unique('users', 'email')->ignore($user->id)],
            'expertise' => 'nullable|string|max:100',
            'skills' => 'nullable|array',
            'skills.*' => 'string|max:50',
            'bio' => 'nullable|string|max:1000',
            'location' => 'nullable|string|max:100',
            'website' => 'nullable|string|max:255',
            'github' => 'nullable|string|max:255',
            'instagram' => 'nullable|string|max:255',
            'dribbble' => 'nullable|string|max:255',
            'avatar' => 'nullable|image|max:2048',
        ]);

        if ($request->hasFile('avatar')) {
            $validated['avatar'] = $request->file('avatar')->store('avatars', 'public');
        } else {
            unset($validated['avatar']);
        }

        $user->update($validated);

        return back()->with('success', 'Profil berhasil diperbarui.');
    }
}
