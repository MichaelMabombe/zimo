<?php

declare(strict_types=1);

require_once __DIR__ . '/_bootstrap.php';

jsonResponse(200, [
    'ok' => true,
    'service' => 'zimo-backend',
    'timestamp' => gmdate('c'),
]);
