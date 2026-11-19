<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('username')->nullable()->unique()->after('name');
            $table->string('expertise')->nullable()->after('email');
            $table->json('skills')->nullable()->after('expertise');
            $table->text('bio')->nullable()->after('skills');
            $table->string('avatar')->nullable()->after('bio');
            $table->string('location')->nullable()->after('avatar');
            $table->string('website')->nullable()->after('location');
            $table->string('github')->nullable()->after('website');
            $table->string('instagram')->nullable()->after('github');
            $table->string('dribbble')->nullable()->after('instagram');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'username', 'expertise', 'skills', 'bio', 'avatar',
                'location', 'website', 'github', 'instagram', 'dribbble',
            ]);
        });
    }
};
