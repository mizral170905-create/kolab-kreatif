<?php

namespace App\Http\Controllers;

use App\Models\Artwork;
use App\Models\Project;
use App\Models\User;
use Inertia\Inertia;
use Inertia\Response;

class AboutController extends Controller
{
    public function index(): Response
    {
        return Inertia::render('About', [
            'stats' => [
                'projects' => Project::count(),
                'creators' => User::count(),
                'artworks' => Artwork::count(),
            ],
            'team' => User::select('id', 'name', 'expertise', 'avatar', 'bio')
                ->latest()
                ->take(4)
                ->get(),
        ]);
    }
}
