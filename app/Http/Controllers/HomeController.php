<?php

namespace App\Http\Controllers;

use App\Models\Artwork;
use App\Models\Category;
use App\Models\Project;
use App\Models\ProjectMember;
use App\Models\User;
use Inertia\Inertia;
use Inertia\Response;

class HomeController extends Controller
{
    public function index(): Response
    {
        return Inertia::render('Welcome', [
            'stats' => [
                'projects' => Project::count(),
                'creators' => User::count(),
                'artworks' => Artwork::count(),
                'collaborations' => ProjectMember::where('status', 'accepted')->count(),
            ],
            'categories' => Category::withCount('projects')->get(),
            'projects' => Project::with(['owner:id,name,expertise,avatar', 'category'])
                ->withCount(['acceptedMembers as members_count'])
                ->latest()
                ->take(6)
                ->get(),
            'artworks' => Artwork::with(['user:id,name,expertise,avatar', 'category'])
                ->withCount(['likes as likes_count', 'comments as comments_count'])
                ->where('is_featured', true)
                ->latest()
                ->take(6)
                ->get(),
        ]);
    }
}
