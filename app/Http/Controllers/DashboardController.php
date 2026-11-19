<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use App\Models\Project;
use App\Models\ProjectMember;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class DashboardController extends Controller
{
    public function index(Request $request): Response
    {
        $user = $request->user();

        $myProjects = Project::where('user_id', $user->id)
            ->with('category:id,name,color')
            ->withCount(['acceptedMembers as members_count'])
            ->latest()
            ->take(5)
            ->get();

        $collaborations = ProjectMember::where('user_id', $user->id)
            ->where('status', 'accepted')
            ->with(['project' => fn ($q) => $q->with('category:id,name,color')->withCount(['acceptedMembers as members_count'])])
            ->latest()
            ->take(5)
            ->get();

        return Inertia::render('Dashboard', [
            'stats' => [
                'projects' => $user->projects()->count(),
                'collaborations' => $user->collaborations_count,
                'artworks' => $user->artworks()->count(),
                'unread' => $user->unread_notifications_count,
            ],
            'myProjects' => $myProjects,
            'collaborations' => $collaborations,
            'recentArtworks' => $user->artworks()
                ->withCount(['likes as likes_count'])
                ->latest()
                ->take(4)
                ->get(),
            'notifications' => Notification::where('user_id', $user->id)
                ->with('fromUser:id,name,avatar')
                ->latest()
                ->take(5)
                ->get(),
        ]);
    }
}
