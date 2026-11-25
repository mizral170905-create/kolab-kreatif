<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Route;

class WellKnownController extends Controller
{
    /**
     * Return the passkey endpoints used by authenticators.
     */
    public function passkeyEndpoints(): JsonResponse
    {
        $manage = Route::has('security.edit')
            ? route('security.edit')
            : route('profile.edit');

        return response()->json([
            'enroll' => $manage,
            'manage' => $manage,
        ]);
    }
}
