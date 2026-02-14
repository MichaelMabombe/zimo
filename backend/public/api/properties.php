<?php

declare(strict_types=1);

require_once __DIR__ . '/_bootstrap.php';

function ensurePropertiesSchema(): void
{
    $pdo = db();
    $hasPropertyType = $pdo->query("SHOW COLUMNS FROM properties LIKE 'property_type'")->fetch();
    if (!$hasPropertyType) {
        $pdo->exec(
            "ALTER TABLE properties
             ADD COLUMN property_type VARCHAR(80) NOT NULL DEFAULT 'Apartamento' AFTER title"
        );
    }

    $hasBedrooms = $pdo->query("SHOW COLUMNS FROM properties LIKE 'bedrooms'")->fetch();
    if (!$hasBedrooms) {
        $pdo->exec(
            "ALTER TABLE properties
             ADD COLUMN bedrooms INT UNSIGNED NOT NULL DEFAULT 1 AFTER property_type"
        );
    }

    $hasDescription = $pdo->query("SHOW COLUMNS FROM properties LIKE 'description'")->fetch();
    if (!$hasDescription) {
        $pdo->exec(
            "ALTER TABLE properties
             ADD COLUMN description TEXT NULL AFTER status"
        );
    }

    $tableCheck = $pdo->query("SHOW TABLES LIKE 'property_photos'")->fetch();
    if (!$tableCheck) {
        $pdo->exec(
            "CREATE TABLE property_photos (
                id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
                property_id BIGINT UNSIGNED NOT NULL,
                file_path VARCHAR(255) NOT NULL,
                is_primary TINYINT(1) NOT NULL DEFAULT 0,
                sort_order INT UNSIGNED NOT NULL DEFAULT 0,
                created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (id),
                KEY idx_property_photos_property (property_id),
                CONSTRAINT fk_property_photos_property
                  FOREIGN KEY (property_id) REFERENCES properties(id)
                  ON DELETE CASCADE
              ) ENGINE=InnoDB"
        );
    }

    $triggerCheck = $pdo->query(
        "SELECT TRIGGER_NAME
         FROM information_schema.TRIGGERS
         WHERE TRIGGER_SCHEMA = DATABASE()
           AND TRIGGER_NAME = 'trg_leases_mark_property_occupied'
         LIMIT 1"
    )->fetch();
    if (!$triggerCheck) {
        $pdo->exec(
            "CREATE TRIGGER trg_leases_mark_property_occupied
             AFTER INSERT ON leases
             FOR EACH ROW
             UPDATE properties
             SET status = 'ocupado'
             WHERE id = NEW.property_id"
        );
    }
}

function statusLabel(string $status): string
{
    return match ($status) {
        'ocupado' => 'Ocupado',
        'manutencao' => 'Em manutencao',
        default => 'Disponivel',
    };
}

function statusColor(string $status): string
{
    return match ($status) {
        'ocupado' => '#7A5C2E',
        'manutencao' => '#B6452C',
        default => '#0E6E6E',
    };
}

function fileUrl(string $filePath): string
{
    $scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
    $host = $_SERVER['HTTP_HOST'] ?? '127.0.0.1:8080';
    return $scheme . '://' . $host . '/' . ltrim($filePath, '/');
}

function normalizeProperty(array $row, array $photos): array
{
    $status = (string) ($row['status'] ?? 'disponivel');
    return [
        'id' => (string) $row['id'],
        'owner_id' => (string) $row['owner_id'],
        'name' => (string) $row['title'],
        'property_type' => (string) ($row['property_type'] ?? 'Apartamento'),
        'bedrooms' => (int) ($row['bedrooms'] ?? 1),
        'address' => (string) $row['address'],
        'city' => (string) ($row['city'] ?? ''),
        'rent' => number_format((float) $row['monthly_rent'], 0, '', '.'),
        'status' => statusLabel($status),
        'status_key' => $status,
        'status_color' => statusColor($status),
        'description' => (string) ($row['description'] ?? ''),
        'photos' => $photos,
    ];
}

function listProperties(): void
{
    $ownerId = (int) ($_GET['owner_id'] ?? 0);
    $statusFilter = trim((string) ($_GET['status'] ?? ''));
    $typeFilter = trim((string) ($_GET['type'] ?? ''));
    $locationFilter = trim((string) ($_GET['location'] ?? ''));
    $maxPrice = (float) ($_GET['max_price'] ?? 0);

    try {
        ensurePropertiesSchema();
        $whereParts = [];
        $params = [];

        if ($ownerId > 0) {
            $whereParts[] = 'owner_id = :ownerId';
            $params['ownerId'] = $ownerId;
        }
        if ($statusFilter !== '') {
            $whereParts[] = 'status = :status';
            $params['status'] = $statusFilter;
        }
        if ($typeFilter !== '') {
            $whereParts[] = 'property_type = :propertyType';
            $params['propertyType'] = $typeFilter;
        }
        if ($locationFilter !== '') {
            $whereParts[] = '(address LIKE :location OR city LIKE :location)';
            $params['location'] = '%' . $locationFilter . '%';
        }
        if ($maxPrice > 0) {
            $whereParts[] = 'monthly_rent <= :maxPrice';
            $params['maxPrice'] = $maxPrice;
        }

        $whereSql = count($whereParts) > 0 ? 'WHERE ' . implode(' AND ', $whereParts) : '';
        $stmt = db()->prepare(
            "SELECT id, owner_id, title, property_type, bedrooms, address, city, monthly_rent, status, description
             FROM properties
             $whereSql
             ORDER BY id DESC"
        );
        $stmt->execute($params);
        $rows = $stmt->fetchAll();

        $propertyIds = array_map(static fn(array $row): int => (int) $row['id'], $rows);
        $photosByProperty = [];
        if (count($propertyIds) > 0) {
            $placeholders = implode(',', array_fill(0, count($propertyIds), '?'));
            $photoStmt = db()->prepare(
                "SELECT property_id, file_path
                 FROM property_photos
                 WHERE property_id IN ($placeholders)
                 ORDER BY property_id, is_primary DESC, sort_order ASC, id ASC"
            );
            $photoStmt->execute($propertyIds);
            $photoRows = $photoStmt->fetchAll();

            foreach ($photoRows as $photoRow) {
                $propertyId = (int) $photoRow['property_id'];
                $photosByProperty[$propertyId] ??= [];
                $photosByProperty[$propertyId][] = fileUrl((string) $photoRow['file_path']);
            }
        }

        $properties = array_map(
            static fn(array $row): array => normalizeProperty(
                $row,
                $photosByProperty[(int) $row['id']] ?? []
            ),
            $rows
        );

        jsonResponse(200, ['ok' => true, 'properties' => $properties]);
    } catch (Throwable $e) {
        jsonResponse(500, ['ok' => false, 'message' => 'Erro ao listar imoveis.']);
    }
}

function createProperty(): void
{
    $ownerId = (int) ($_POST['owner_id'] ?? 0);
    $name = trim((string) ($_POST['name'] ?? ''));
    $propertyType = trim((string) ($_POST['property_type'] ?? ''));
    $address = trim((string) ($_POST['address'] ?? ''));
    $city = trim((string) ($_POST['city'] ?? 'Maputo'));
    $rentRaw = str_replace([' ', '.'], '', (string) ($_POST['rent'] ?? ''));
    $rent = (float) str_replace(',', '.', $rentRaw);
    $bedrooms = (int) ($_POST['bedrooms'] ?? 0);
    $description = trim((string) ($_POST['description'] ?? ''));

    if ($ownerId <= 0 || $name === '' || $propertyType === '' || $address === '' || $rent <= 0 || $bedrooms <= 0) {
        jsonResponse(422, ['ok' => false, 'message' => 'Preencha todos os campos obrigatorios do imovel.']);
    }

    $pdo = db();
    try {
        ensurePropertiesSchema();
        $pdo->beginTransaction();

        $insert = $pdo->prepare(
            'INSERT INTO properties (owner_id, title, property_type, bedrooms, address, city, monthly_rent, status, description)
             VALUES (:owner_id, :title, :property_type, :bedrooms, :address, :city, :monthly_rent, :status, :description)'
        );
        $insert->execute([
            'owner_id' => $ownerId,
            'title' => $name,
            'property_type' => $propertyType,
            'bedrooms' => $bedrooms,
            'address' => $address,
            'city' => $city,
            'monthly_rent' => $rent,
            'status' => 'disponivel',
            'description' => $description === '' ? null : $description,
        ]);
        $propertyId = (int) $pdo->lastInsertId();

        $uploadDir = realpath(__DIR__ . '/..') . DIRECTORY_SEPARATOR . 'uploads' . DIRECTORY_SEPARATOR . 'properties';
        if ($uploadDir === false) {
            throw new RuntimeException('Diretorio base de upload indisponivel.');
        }
        if (!is_dir($uploadDir) && !mkdir($uploadDir, 0775, true) && !is_dir($uploadDir)) {
            throw new RuntimeException('Nao foi possivel criar pasta de uploads.');
        }

        $savedPhotos = [];
        if (isset($_FILES['photos']) && is_array($_FILES['photos']['name'] ?? null)) {
            $total = count($_FILES['photos']['name']);
            for ($i = 0; $i < $total; $i++) {
                $error = (int) ($_FILES['photos']['error'][$i] ?? UPLOAD_ERR_NO_FILE);
                if ($error !== UPLOAD_ERR_OK) {
                    continue;
                }

                $tmpName = (string) ($_FILES['photos']['tmp_name'][$i] ?? '');
                $originalName = (string) ($_FILES['photos']['name'][$i] ?? '');
                if ($tmpName === '' || $originalName === '') {
                    continue;
                }

                $extension = strtolower(pathinfo($originalName, PATHINFO_EXTENSION));
                if (!in_array($extension, ['jpg', 'jpeg', 'png', 'webp'], true)) {
                    continue;
                }

                $fileName = sprintf(
                    'property_%d_%s.%s',
                    $propertyId,
                    bin2hex(random_bytes(8)),
                    $extension
                );
                $relativePath = 'uploads/properties/' . $fileName;
                $targetPath = $uploadDir . DIRECTORY_SEPARATOR . $fileName;

                if (!move_uploaded_file($tmpName, $targetPath)) {
                    continue;
                }

                $photoInsert = $pdo->prepare(
                    'INSERT INTO property_photos (property_id, file_path, is_primary, sort_order)
                     VALUES (:property_id, :file_path, :is_primary, :sort_order)'
                );
                $photoInsert->execute([
                    'property_id' => $propertyId,
                    'file_path' => $relativePath,
                    'is_primary' => $i === 0 ? 1 : 0,
                    'sort_order' => $i,
                ]);

                $savedPhotos[] = fileUrl($relativePath);
            }
        }

        $stmt = $pdo->prepare(
            'SELECT id, owner_id, title, property_type, bedrooms, address, city, monthly_rent, status, description
             FROM properties
             WHERE id = :id
             LIMIT 1'
        );
        $stmt->execute(['id' => $propertyId]);
        $row = $stmt->fetch();
        if (!$row) {
            throw new RuntimeException('Imovel nao encontrado apos cadastro.');
        }

        $pdo->commit();
        jsonResponse(201, [
            'ok' => true,
            'message' => 'Imovel cadastrado com sucesso.',
            'property' => normalizeProperty($row, $savedPhotos),
        ]);
    } catch (Throwable $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        jsonResponse(500, ['ok' => false, 'message' => 'Erro ao salvar imovel.']);
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    listProperties();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    createProperty();
}

jsonResponse(405, ['ok' => false, 'message' => 'Method not allowed']);
