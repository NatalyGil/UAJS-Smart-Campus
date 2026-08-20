# Base de Datos - UAJS Smart Campus

## Índice
1. [Información General](#información-general)
2. [Diagrama Entidad-Relación](#diagrama-entidad-relación)
3. [Esquema SQL](#esquema-sql)
4. [Relaciones](#relaciones)
5. [Datos Iniciales](#datos-iniciales)

---

## Información General

- **Motor**: MySQL 8.0+
- **Charset**: utf8mb4
- **Collation**: utf8mb4_unicode_ci
- **Base de datos**: `uajs_smart_campus`

---

## Diagrama Entidad-Relación

```
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────────┐
│     usuarios    │───────│      roles      │       │    permisos_rol     │
├─────────────────┤       ├─────────────────┤       ├─────────────────────┤
│ id (PK)         │       │ id (PK)         │       │ id (PK)             │
│ usuario         │       │ nombre          │       │ rol_id (FK)         │
│ password_hash   │       │ created_at      │       │ permiso             │
│ nombre          │       │ updated_at      │       │ created_at          │
│ correo          │       └─────────────────┘       └─────────────────────┘
│ rol_id (FK)     │
│ programa        │
│ estado          │
│ created_at      │
│ updated_at      │
└─────────┬───────┘
          │
          │ 1:N
          ▼
┌─────────────────────┐       ┌─────────────────────┐
│    solicitudes      │       │ solicitudes_historial│
├─────────────────────┤       ├─────────────────────┤
│ id (PK)             │       │ id (PK)             │
│ codigo (UNIQUE)     │◄──────│ solicitud_id (FK)   │
│ tipo                │       │ estado              │
│ servicio            │       │ fecha               │
│ fecha               │       │ detalle             │
│ estado              │       │ created_at          │
│ solicitante_id (FK) │       └─────────────────────┘
│ descripcion         │
│ created_at          │
│ updated_at          │
└─────────┬───────────┘
          │
          │ 1:N
          ▼
┌─────────────────┐       ┌─────────────────────┐
│    reservas     │       │    notificaciones   │
├─────────────────┤       ├─────────────────────┤
│ id (PK)         │       │ id (PK)             │
│ recurso_id (FK) │       │ usuario_id (FK)     │
│ usuario_id (FK) │       │ tipo                │
│ fecha           │       │ icono               │
│ hora_inicio     │       │ mensaje             │
│ hora_fin        │       │ referencia_id       │
│ motivo          │       │ referencia_tabla    │
│ estado          │       │ leida               │
│ created_at      │       │ fecha               │
│ updated_at      │       │ created_at          │
└─────────────────┘       └─────────────────────┘
          │
          │ N:1
          ▼
┌─────────────────┐
│    recursos     │
├─────────────────┤
│ id (PK)         │
│ codigo (UNIQUE) │
│ nombre          │
│ tipo            │
│ capacidad       │
│ ubicacion       │
│ estado          │
│ disponibilidad  │
│ created_at      │
│ updated_at      │
└─────────────────┘

┌─────────────────┐       ┌─────────────────────┐
│    eventos      │       │        pqrs         │
├─────────────────┤       ├─────────────────────┤
│ id (PK)         │       │ id (PK)             │
│ nombre          │       │ codigo (UNIQUE)     │
│ fecha           │       │ tipo                │
│ hora            │       │ fecha               │
│ lugar           │       │ estado              │
│ categoria       │       │ usuario_id (FK)     │
│ descripcion     │       │ descripcion         │
│ created_at      │       │ created_at          │
│ updated_at      │       │ updated_at          │
└─────────────────┘       └─────────────────────┘
```

---

## Esquema SQL

```sql
-- ============================================
-- BASE DE DATOS: UAJS Smart Campus
-- ============================================

CREATE DATABASE IF NOT EXISTS uajs_smart_campus
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE uajs_smart_campus;

-- ============================================
-- TABLA: roles
-- ============================================
CREATE TABLE roles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================
-- TABLA: permisos_rol
-- ============================================
CREATE TABLE permisos_rol (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    rol_id BIGINT UNSIGNED NOT NULL,
    permiso VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rol_id) REFERENCES roles(id) ON DELETE CASCADE,
    UNIQUE KEY uk_rol_permiso (rol_id, permiso)
) ENGINE=InnoDB;

-- ============================================
-- TABLA: usuarios
-- ============================================
CREATE TABLE usuarios (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    rol_id BIGINT UNSIGNED NOT NULL,
    programa VARCHAR(100) DEFAULT NULL,
    estado ENUM('Activo', 'Inactivo') DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (rol_id) REFERENCES roles(id)
) ENGINE=InnoDB;

-- ============================================
-- TABLA: solicitudes
-- ============================================
CREATE TABLE solicitudes (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    tipo VARCHAR(100) NOT NULL,
    servicio VARCHAR(50) NOT NULL,
    fecha DATE NOT NULL,
    estado ENUM(
        'Registrada',
        'En revisión',
        'Asignada',
        'En proceso',
        'Resuelta',
        'Cerrada'
    ) DEFAULT 'Registrada',
    solicitante_id BIGINT UNSIGNED NOT NULL,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (solicitante_id) REFERENCES usuarios(id),
    INDEX idx_estado (estado),
    INDEX idx_servicio (servicio),
    INDEX idx_fecha (fecha)
) ENGINE=InnoDB;

-- ============================================
-- TABLA: solicitudes_historial
-- ============================================
CREATE TABLE solicitudes_historial (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    solicitud_id BIGINT UNSIGNED NOT NULL,
    estado VARCHAR(50) NOT NULL,
    fecha DATETIME NOT NULL,
    detalle TEXT,
    usuario_id BIGINT UNSIGNED DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (solicitud_id) REFERENCES solicitudes(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL,
    INDEX idx_solicitud_estado (solicitud_id, estado)
) ENGINE=InnoDB;

-- ============================================
-- TABLA: recursos
-- ============================================
CREATE TABLE recursos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    tipo ENUM('Salas', 'Laboratorios', 'Auditorios', 'Equipos') NOT NULL,
    capacidad INT UNSIGNED DEFAULT 1,
    ubicacion VARCHAR(150) NOT NULL,
    estado ENUM('Activo', 'Inactivo', 'En mantenimiento') DEFAULT 'Activo',
    disponibilidad ENUM('Disponible', 'Ocupado') DEFAULT 'Disponible',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_tipo (tipo),
    INDEX idx_estado (estado),
    INDEX idx_disponibilidad (disponibilidad)
) ENGINE=InnoDB;

-- ============================================
-- TABLA: reservas
-- ============================================
CREATE TABLE reservas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    recurso_id BIGINT UNSIGNED NOT NULL,
    usuario_id BIGINT UNSIGNED NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    motivo TEXT,
    estado ENUM('Pendiente', 'Confirmada', 'Cancelada', 'Finalizada') DEFAULT 'Pendiente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (recurso_id) REFERENCES recursos(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    INDEX idx_recurso_fecha (recurso_id, fecha),
    INDEX idx_usuario (usuario_id),
    INDEX idx_fecha (fecha)
) ENGINE=InnoDB;

-- ============================================
-- TABLA: notificaciones
-- ============================================
CREATE TABLE notificaciones (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    usuario_id BIGINT UNSIGNED NOT NULL,
    tipo ENUM('Solicitud', 'Reserva', 'Evento', 'Alerta', 'Comunicación') NOT NULL,
    icono VARCHAR(10) DEFAULT NULL,
    mensaje TEXT NOT NULL,
    referencia_id VARCHAR(50) DEFAULT NULL,
    referencia_tabla VARCHAR(50) DEFAULT NULL,
    leida BOOLEAN DEFAULT FALSE,
    fecha DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_usuario_leida (usuario_id, leida),
    INDEX idx_fecha (fecha)
) ENGINE=InnoDB;

-- ============================================
-- TABLA: eventos
-- ============================================
CREATE TABLE eventos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    lugar VARCHAR(150) NOT NULL,
    categoria ENUM('Académico', 'Cultural', 'Deportivo', 'Formación', 'Institucional') NOT NULL,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_fecha (fecha),
    INDEX idx_categoria (categoria)
) ENGINE=InnoDB;

-- ============================================
-- TABLA: pqrs
-- ============================================
CREATE TABLE pqrs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    tipo ENUM('Petición', 'Queja', 'Reclamo', 'Sugerencia') NOT NULL,
    fecha DATE NOT NULL,
    estado ENUM('Registrada', 'En revisión', 'Asignada', 'En proceso', 'Resuelta', 'Cerrada') DEFAULT 'Registrada',
    usuario_id BIGINT UNSIGNED NOT NULL,
    descripcion TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    INDEX idx_tipo (tipo),
    INDEX idx_estado (estado),
    INDEX idx_fecha (fecha)
) ENGINE=InnoDB;

-- ============================================
-- TABLA: configuracion
-- ============================================
CREATE TABLE configuracion (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    clave VARCHAR(100) NOT NULL UNIQUE,
    valor TEXT,
    tipo VARCHAR(50) DEFAULT 'string',
    descripcion TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================
-- VISTA: vista_solicitudes_completas
-- ============================================
CREATE OR REPLACE VIEW vista_solicitudes_completas AS
SELECT 
    s.id,
    s.codigo,
    s.tipo,
    s.servicio,
    s.fecha,
    s.estado,
    s.descripcion,
    s.created_at,
    u.nombre AS solicitante,
    u.correo AS correo_solicitante,
    u.usuario AS usuario_solicitante
FROM solicitudes s
INNER JOIN usuarios u ON s.solicitante_id = u.id;

-- ============================================
-- VISTA: vista_reservas_completas
-- ============================================
CREATE OR REPLACE VIEW vista_reservas_completas AS
SELECT 
    r.id,
    r.fecha,
    r.hora_inicio,
    r.hora_fin,
    r.motivo,
    r.estado,
    r.created_at,
    u.nombre AS usuario,
    u.correo AS correo_usuario,
    rec.codigo AS recurso_codigo,
    rec.nombre AS recurso_nombre,
    rec.tipo AS recurso_tipo,
    rec.ubicacion AS recurso_ubicacion
FROM reservas r
INNER JOIN usuarios u ON r.usuario_id = u.id
INNER JOIN recursos rec ON r.recurso_id = rec.id;
```

---

## Relaciones

| Tabla | Relación | Tabla | Tipo |
|-------|----------|-------|------|
| roles | 1:N | usuarios | Un rol tiene muchos usuarios |
| roles | 1:N | permisos_rol | Un rol tiene muchos permisos |
| usuarios | 1:N | solicitudes | Un usuario registra muchas solicitudes |
| usuarios | 1:N | reservas | Un usuario realiza muchas reservas |
| usuarios | 1:N | notificaciones | Un usuario tiene muchas notificaciones |
| usuarios | 1:N | pqrs | Un usuario registra muchos PQRS |
| solicitudes | 1:N | solicitudes_historial | Una solicitud tiene muchos estados en el historial |
| recursos | 1:N | reservas | Un recurso puede tener muchas reservas |

---

## Datos Iniciales

### Roles

```sql
INSERT INTO roles (id, nombre) VALUES
(1, 'Administrador'),
(2, 'Administrativo'),
(3, 'Docente'),
(4, 'Estudiante');
```

### Permisos por Rol

```sql
-- Administrador
INSERT INTO permisos_rol (rol_id, permiso) VALUES
(1, 'dashboard'), (1, 'usuarios'), (1, 'solicitudes'), (1, 'reservas'),
(1, 'recursos'), (1, 'eventos'), (1, 'notificaciones'), (1, 'pqrs'),
(1, 'perfil'), (1, 'configuracion');

-- Administrativo
INSERT INTO permisos_rol (rol_id, permiso) VALUES
(2, 'dashboard'), (2, 'solicitudes'), (2, 'reservas'), (2, 'recursos'),
(2, 'eventos'), (2, 'notificaciones'), (2, 'pqrs'), (2, 'perfil');

-- Docente
INSERT INTO permisos_rol (rol_id, permiso) VALUES
(3, 'dashboard'), (3, 'solicitudes'), (3, 'reservas'), (3, 'recursos'),
(3, 'eventos'), (3, 'notificaciones'), (3, 'pqrs'), (3, 'perfil');

-- Estudiante
INSERT INTO permisos_rol (rol_id, permiso) VALUES
(4, 'dashboard'), (4, 'solicitudes'), (4, 'reservas'), (4, 'recursos'),
(4, 'notificaciones'), (4, 'eventos'), (4, 'pqrs'), (4, 'perfil');
```

### Usuarios

```sql
INSERT INTO usuarios (id, usuario, password_hash, nombre, correo, rol_id, programa, estado) VALUES
(1, 'admin', '$2a$10$xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'Natalia Rodríguez', 'natalia.rodriguez@uajs.edu.co', 1, 'Ingeniería de Sistemas', 'Activo'),
(2, 'funcionario', '$2a$10$xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'Carlos Méndez', 'carlos.mendez@uajs.edu.co', 2, 'Bienestar Universitario', 'Activo'),
(3, 'profesor', '$2a$10$xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'Laura Gómez', 'laura.gomez@uajs.edu.co', 3, 'Matemáticas', 'Activo'),
(4, 'estudiante', '$2a$10$xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'Andrés Torres', 'andres.torres@uajs.edu.co', 4, 'Ingeniería de Sistemas', 'Activo');
```

> **Nota**: Los `password_hash` deben generarse con bcrypt. Los valores mostrados son placeholders.

### Recursos

```sql
INSERT INTO recursos (codigo, nombre, tipo, capacidad, ubicacion, estado, disponibilidad) VALUES
('REC-101', 'Salón 101', 'Salas', 40, 'Bloque A · Piso 1', 'Activo', 'Disponible'),
('REC-205', 'Salón 205', 'Salas', 30, 'Bloque A · Piso 2', 'Activo', 'Ocupado'),
('REC-LAB1', 'Laboratorio de informática 1', 'Laboratorios', 25, 'Bloque B · Piso 1', 'Activo', 'Disponible'),
('REC-LABQ', 'Laboratorio de química', 'Laboratorios', 20, 'Bloque B · Piso 2', 'En mantenimiento', 'Ocupado'),
('REC-AUD1', 'Auditorio principal', 'Auditorios', 300, 'Bloque C', 'Activo', 'Disponible'),
('REC-AUD2', 'Auditorio B', 'Auditorios', 120, 'Bloque C · Piso 2', 'Activo', 'Ocupado'),
('REC-EQ1', 'Video proyector', 'Equipos', 1, 'Bodega de tecnología', 'Activo', 'Disponible'),
('REC-EQ2', 'Computador portátil', 'Equipos', 1, 'Bodega de tecnología', 'Inactivo', 'Ocupado');
```

### Eventos

```sql
INSERT INTO eventos (nombre, fecha, hora, lugar, categoria, descripcion) VALUES
('Semana de la Ingeniería', '2026-08-20', '09:00', 'Auditorio principal', 'Académico', 'Jornada de conferencias y talleres con invitados del sector productivo.'),
('Seminario de investigación aplicada', '2026-08-22', '14:00', 'Salón 205', 'Académico', 'Presentación de proyectos de investigación de estudiantes y docentes.'),
('Foro estudiantil', '2026-08-25', '10:00', 'Auditorio B', 'Cultural', 'Espacio de diálogo sobre la vida universitaria y bienestar estudiantil.'),
('Feria universitaria 2026', '2026-08-28', '08:00', 'Patio central', 'Cultural', 'Exposición de programas académicos, servicios y emprendimientos estudiantiles.'),
('Taller de emprendimiento', '2026-09-02', '15:00', 'Laboratorio de informática 1', 'Formación', 'Taller práctico para la creación de planes de negocio.');
```

### Configuración Inicial

```sql
INSERT INTO configuracion (clave, valor, tipo, descripcion) VALUES
('nombre_institucion', 'Universidad Antonio José Camacho - UAJS', 'string', 'Nombre de la institución'),
('notificaciones_email', 'true', 'boolean', 'Activar notificaciones por correo'),
('modo_mantenimiento', 'false', 'boolean', 'Activar modo mantenimiento'),
('max_dias_reserva', '30', 'number', 'Días máximos de anticipación para reservas');
```

---

## Consideraciones

1. **Contraseñas**: Se debe usar bcrypt para hashear contraseñas. El campo `password_hash` almacena el hash, nunca la contraseña en texto plano.
2. **Soft delete**: En `usuarios` y `recursos` se usa el campo `estado` (Activo/Inactivo) en lugar de eliminar registros.
3. **Auditoría**: Las tablas principales incluyen `created_at` y `updated_at` para trazabilidad.
4. **Índices**: Se crearon índices en los campos más consultados (estado, fecha, tipo) para optimizar consultas.
5. **Vistas**: Las vistas `vista_solicitudes_completas` y `vista_reservas_completas` simplifican consultas frecuentes del frontend.
