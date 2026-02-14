-- ZIMO - MySQL schema + seed
-- Execute with:
--   mysql -u root -p < backend/database/001_zimo_schema_seed.sql

CREATE DATABASE IF NOT EXISTS zimo_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE zimo_db;

SET NAMES utf8mb4;
SET time_zone = '+00:00';

DROP TABLE IF EXISTS maintenance_requests;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS leases;
DROP TABLE IF EXISTS properties;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(160) NOT NULL,
  password_hash CHAR(64) NOT NULL,
  password_plain VARCHAR(80) NOT NULL,
  phone VARCHAR(30) NOT NULL,
  address VARCHAR(255) NOT NULL,
  document_number VARCHAR(60) NOT NULL,
  role ENUM('admin', 'proprietario', 'inquilino') NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_users_email (email),
  KEY idx_users_role (role)
) ENGINE=InnoDB;

CREATE TABLE properties (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  owner_id BIGINT UNSIGNED NOT NULL,
  title VARCHAR(160) NOT NULL,
  address VARCHAR(255) NOT NULL,
  city VARCHAR(80) NOT NULL,
  monthly_rent DECIMAL(12,2) NOT NULL,
  status ENUM('disponivel', 'ocupado', 'manutencao') NOT NULL DEFAULT 'disponivel',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_properties_owner (owner_id),
  CONSTRAINT fk_properties_owner FOREIGN KEY (owner_id) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE leases (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  property_id BIGINT UNSIGNED NOT NULL,
  tenant_id BIGINT UNSIGNED NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  monthly_rent DECIMAL(12,2) NOT NULL,
  status ENUM('ativo', 'encerrado', 'atrasado') NOT NULL DEFAULT 'ativo',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_leases_property_active (property_id, tenant_id, start_date),
  KEY idx_leases_tenant (tenant_id),
  CONSTRAINT fk_leases_property FOREIGN KEY (property_id) REFERENCES properties(id),
  CONSTRAINT fk_leases_tenant FOREIGN KEY (tenant_id) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE payments (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  lease_id BIGINT UNSIGNED NOT NULL,
  due_date DATE NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  status ENUM('pendente', 'pago', 'atrasado') NOT NULL DEFAULT 'pendente',
  paid_at DATETIME NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_payments_lease (lease_id),
  CONSTRAINT fk_payments_lease FOREIGN KEY (lease_id) REFERENCES leases(id)
) ENGINE=InnoDB;

CREATE TABLE maintenance_requests (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  property_id BIGINT UNSIGNED NOT NULL,
  tenant_id BIGINT UNSIGNED NOT NULL,
  title VARCHAR(180) NOT NULL,
  description TEXT NOT NULL,
  status ENUM('aberto', 'em_andamento', 'resolvido') NOT NULL DEFAULT 'aberto',
  requested_at DATETIME NOT NULL,
  resolved_at DATETIME NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_maintenance_property (property_id),
  KEY idx_maintenance_tenant (tenant_id),
  CONSTRAINT fk_maintenance_property FOREIGN KEY (property_id) REFERENCES properties(id),
  CONSTRAINT fk_maintenance_tenant FOREIGN KEY (tenant_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- Administrator (você)
INSERT INTO users (
  full_name, email, password_hash, password_plain, phone, address, document_number, role
) VALUES (
  'Michael Mabombe',
  'michael.admin@zimo.co.mz',
  SHA2('ZimoAdmin@2026!', 256),
  'ZimoAdmin@2026!',
  '+258840001001',
  'Maputo, Mozambique',
  'ADMIN-MABOMBE-01',
  'admin'
);

-- 20 proprietários
INSERT INTO users (
  full_name, email, password_hash, password_plain, phone, address, document_number, role
)
SELECT
  CONCAT('Proprietario ', LPAD(n, 2, '0')),
  CONCAT('proprietario', LPAD(n, 2, '0'), '@zimo.co.mz'),
  SHA2('ZimoUser@2026!', 256),
  'ZimoUser@2026!',
  CONCAT('+258840000', LPAD(n, 2, '0')),
  'Av. Eduardo Mondlane, Maputo',
  CONCAT('BI-PROP-', LPAD(n, 2, '0')),
  'proprietario'
FROM (
  SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
  UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
  UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15
  UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20
) AS seq;

-- 20 inquilinos
INSERT INTO users (
  full_name, email, password_hash, password_plain, phone, address, document_number, role
)
SELECT
  CONCAT('Inquilino ', LPAD(n, 2, '0')),
  CONCAT('inquilino', LPAD(n, 2, '0'), '@zimo.co.mz'),
  SHA2('ZimoUser@2026!', 256),
  'ZimoUser@2026!',
  CONCAT('+258850000', LPAD(n, 2, '0')),
  'Av. Julius Nyerere, Maputo',
  CONCAT('BI-INQ-', LPAD(n, 2, '0')),
  'inquilino'
FROM (
  SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
  UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
  UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15
  UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20
) AS seq;

-- 20 imóveis (1 por proprietário)
INSERT INTO properties (
  owner_id, title, address, city, monthly_rent, status
)
SELECT
  id,
  CONCAT('Imovel de ', full_name),
  CONCAT('Rua ', LPAD(id, 3, '0'), ', Bairro Central'),
  'Maputo',
  15000 + (id * 350),
  'ocupado'
FROM users
WHERE role = 'proprietario'
ORDER BY id;

-- 20 contratos (1 por imóvel/inquilino)
SET @row_num := 0;
CREATE TEMPORARY TABLE tmp_properties AS
SELECT id, monthly_rent, (@row_num := @row_num + 1) AS rn
FROM properties
ORDER BY id;

SET @row_num := 0;
CREATE TEMPORARY TABLE tmp_tenants AS
SELECT id, (@row_num := @row_num + 1) AS rn
FROM users
WHERE role = 'inquilino'
ORDER BY id;

INSERT INTO leases (
  property_id, tenant_id, start_date, end_date, monthly_rent, status
)
SELECT
  p.id,
  t.id,
  '2026-01-01',
  '2026-12-31',
  p.monthly_rent,
  'ativo'
FROM (
  SELECT id, monthly_rent, rn FROM tmp_properties
) p
JOIN (
  SELECT id, rn FROM tmp_tenants
) t ON p.rn = t.rn
ORDER BY p.id;

DROP TEMPORARY TABLE IF EXISTS tmp_properties;
DROP TEMPORARY TABLE IF EXISTS tmp_tenants;

-- Pagamentos (fev pago, mar pendente para cada contrato)
INSERT INTO payments (lease_id, due_date, amount, status, paid_at)
SELECT
  l.id,
  '2026-02-05',
  l.monthly_rent,
  'pago',
  '2026-02-03 10:00:00'
FROM leases l;

INSERT INTO payments (lease_id, due_date, amount, status, paid_at)
SELECT
  l.id,
  '2026-03-05',
  l.monthly_rent,
  'pendente',
  NULL
FROM leases l;

-- Alguns pedidos de manutenção
INSERT INTO maintenance_requests (
  property_id, tenant_id, title, description, status, requested_at, resolved_at
)
SELECT
  l.property_id,
  l.tenant_id,
  CONCAT('Manutencao #', l.id),
  'Verificar torneira com vazamento na cozinha.',
  CASE WHEN l.id % 3 = 0 THEN 'resolvido' ELSE 'aberto' END,
  '2026-02-10 09:30:00',
  CASE WHEN l.id % 3 = 0 THEN '2026-02-11 16:00:00' ELSE NULL END
FROM leases l
WHERE l.id <= 10;
