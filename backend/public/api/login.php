<?php

declare(strict_types=1);

require_once __DIR__ . '/_bootstrap.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    jsonResponse(405, ['ok' => false, 'message' => 'Method not allowed']);
}

$input = jsonBody();
$email = strtolower(trim((string) ($input['email'] ?? '')));
$password = (string) ($input['password'] ?? '');
$roleInput = trim((string) ($input['role'] ?? ''));

if ($email === '' || $password === '') {
    jsonResponse(422, ['ok' => false, 'message' => 'Email e senha sao obrigatorios.']);
}

try {
    $stmt = db()->prepare(
        'SELECT id, full_name, email, phone, address, document_number, role, password_hash, password_plain
         FROM users
         WHERE LOWER(email) = :email AND is_active = 1
         LIMIT 1'
    );
    $stmt->execute(['email' => $email]);
    $user = $stmt->fetch();

    if (!$user) {
        jsonResponse(401, ['ok' => false, 'message' => 'Credenciais invalidas.']);
    }

    $computedHash = hash('sha256', $password);
    $hashMatch = hash_equals((string) $user['password_hash'], $computedHash);
    $plainMatch = hash_equals((string) $user['password_plain'], $password);

    if (!$hashMatch && !$plainMatch) {
        jsonResponse(401, ['ok' => false, 'message' => 'Credenciais invalidas.']);
    }

    $dbRole = (string) $user['role'];
    if ($dbRole !== 'admin' && $roleInput !== '' && $dbRole !== $roleInput) {
        jsonResponse(401, ['ok' => false, 'message' => 'Tipo de usuario nao corresponde.']);
    }

    jsonResponse(200, [
        'ok' => true,
        'user' => [
            'id' => (string) $user['id'],
            'name' => (string) $user['full_name'],
            'email' => (string) $user['email'],
            'phone' => (string) $user['phone'],
            'address' => (string) $user['address'],
            'document' => (string) $user['document_number'],
            'role' => $dbRole,
        ],
    ]);
} catch (Throwable $e) {
    jsonResponse(500, ['ok' => false, 'message' => 'Erro interno no login.']);
}
