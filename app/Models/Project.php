<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\MorphMany;
use Illuminate\Support\Str;

class Project extends Model
{
    protected $fillable = [
        'user_id', 'category_id', 'title', 'slug', 'description',
        'required_skills', 'team_size', 'deadline', 'cover_image', 'status',
    ];

    protected $casts = [
        'required_skills' => 'array',
        'deadline' => 'date',
    ];

    protected static function booted(): void
    {
        static::creating(function (Project $project) {
            if (! $project->slug) {
                $project->slug = Str::slug($project->title).'-'.Str::lower(Str::random(5));
            }
        });
    }

    public function owner(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function members(): HasMany
    {
        return $this->hasMany(ProjectMember::class);
    }

    public function acceptedMembers(): HasMany
    {
        return $this->hasMany(ProjectMember::class)->where('status', 'accepted');
    }

    public function pendingMembers(): HasMany
    {
        return $this->hasMany(ProjectMember::class)->where('status', 'pending');
    }

    public function artworks(): HasMany
    {
        return $this->hasMany(Artwork::class);
    }

    public function comments(): MorphMany
    {
        return $this->morphMany(Comment::class, 'commentable')->latest();
    }

    public function getTotalAcceptedAttribute(): int
    {
        return $this->acceptedMembers()->count();
    }

    public function getTotalCommentsAttribute(): int
    {
        return $this->comments()->count();
    }

    public function getIsFullAttribute(): bool
    {
        return $this->total_accepted >= $this->team_size;
    }
}
