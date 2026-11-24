<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Artisan;

class SeedIfDatabaseEmpty extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'kolab:seed-if-empty';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Isi database dengan data demo hanya jika tabel users masih kosong.';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        if (User::query()->exists()) {
            $this->info('Database sudah berisi data. Seeder dilewati.');

            return self::SUCCESS;
        }

        $this->info('Database kosong. Menjalankan seeder...');
        Artisan::call('db:seed', ['--force' => true]);
        $this->line(Artisan::output());

        return self::SUCCESS;
    }
}
