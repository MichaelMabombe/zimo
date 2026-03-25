<?php

declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');
echo json_encode([
    'ok' => true,
    'service' => 'zimo-backend',
    'routes' => [
        'GET /api/health.php',
        'POST /api/login.php',
        'GET /api/users.php',
    ],
], JSON_UNESCAPED_UNICODE);
