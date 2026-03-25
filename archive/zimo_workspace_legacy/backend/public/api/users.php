<?php

declare(strict_types=1);

require_once __DIR__ . '/_bootstrap.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    jsonResponse(405, ['ok' => false, 'message' => 'Method not allowed']);
}

try {
    $stmt = db()->query(
        'SELECT id, full_name, email, phone, address, document_number, role
         FROM users
         WHERE is_active = 1
         ORDER BY role, full_name'
    );
    $rows = $stmt->fetchAll();

    $users = array_map(static function (array $row): array {
        return [
            'id' => (string) $row['id'],
            'name' => (string) $row['full_name'],
            'email' => (string) $row['email'],
            'phone' => (string) $row['phone'],
            'address' => (string) $row['address'],
            'document' => (string) $row['document_number'],
            'role' => (string) $row['role'],
        ];
    }, $rows);

    jsonResponse(200, ['ok' => true, 'users' => $users]);
} catch (Throwable $e) {
    jsonResponse(500, ['ok' => false, 'message' => 'Erro ao listar usuarios.']);
}
