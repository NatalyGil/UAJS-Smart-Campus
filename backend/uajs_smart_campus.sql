-- ============================================================
-- UAJS Smart Campus — Esquema de base de datos
-- Derivado de las consultas reales de los 11 microservicios.
-- MySQL 8.0 · utf8mb4
-- ============================================================

CREATE DATABASE IF NOT EXISTS uajs_smart_campus
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE uajs_smart_campus;

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- ROLES
-- ============================================================
DROP TABLE IF EXISTS roles;
CREATE TABLE roles (
    id_rol       INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol   VARCHAR(50)  NOT NULL UNIQUE,
    descripcion  VARCHAR(255) DEFAULT NULL,
    created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- SERVICIOS
-- ============================================================
DROP TABLE IF EXISTS servicios;
CREATE TABLE servicios (
    id_servicio  INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(80)  NOT NULL UNIQUE,
    descripcion  VARCHAR(255) DEFAULT NULL,
    estado       VARCHAR(20)  DEFAULT 'Activo'
) ENGINE=InnoDB;

-- ============================================================
-- USUARIOS
-- Columnas usadas por users-service, auth-service y search-service.
-- cedula / cargo / campus preservan el contrato del frontend.
-- ============================================================
DROP TABLE IF EXISTS usuarios;
CREATE TABLE usuarios (
    id_usuario      INT AUTO_INCREMENT PRIMARY KEY,
    identificacion  VARCHAR(50)  NOT NULL UNIQUE,
    usuario         VARCHAR(50)  NOT NULL UNIQUE,
    cedula          VARCHAR(20)  DEFAULT NULL,
    contraseña      VARCHAR(120) NOT NULL,
    nombre          VARCHAR(80)  NOT NULL,
    apellido        VARCHAR(80)  NOT NULL DEFAULT '',
    correo          VARCHAR(120) NOT NULL UNIQUE,
    telefono        VARCHAR(30)  DEFAULT '',
    id_rol          INT          NOT NULL DEFAULT 2,
    tipo_usuario    VARCHAR(50)  DEFAULT 'Estudiante',
    programa        VARCHAR(120) DEFAULT '',
    cargo           VARCHAR(120) DEFAULT '',
    campus          VARCHAR(80)  DEFAULT 'Campus principal',
     foto_perfil     LONGTEXT DEFAULT NULL,
    estado          VARCHAR(20)  NOT NULL DEFAULT 'Activo',
    created_at      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuarios_rol FOREIGN KEY (id_rol) REFERENCES roles (id_rol),
    INDEX idx_usuarios_estado (estado),
    INDEX idx_usuarios_rol (id_rol),
    -- Compuesto para el filtro habitual "usuarios activos por rol".
    INDEX idx_usuarios_estado_rol (estado, id_rol)
) ENGINE=InnoDB;

-- ============================================================
-- RECURSOS
-- ============================================================
DROP TABLE IF EXISTS recursos;
CREATE TABLE recursos (
    id_recurso     INT AUTO_INCREMENT PRIMARY KEY,
    nombre_recurso VARCHAR(120) NOT NULL,
    codigo         VARCHAR(40)  DEFAULT '',
    tipo_recurso   ENUM('Salas', 'Laboratorios', 'Auditorios', 'Equipos') NOT NULL,
    descripcion    TEXT,
    ubicacion      VARCHAR(120) NOT NULL,
    capacidad      INT          DEFAULT NULL,
    estado         VARCHAR(30)  NOT NULL DEFAULT 'Disponible',
    disponibilidad VARCHAR(30)  NOT NULL DEFAULT 'Disponible',
    created_at     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_recursos_tipo (tipo_recurso),
    INDEX idx_recursos_disponibilidad (disponibilidad)
) ENGINE=InnoDB;

-- ============================================================
-- EVENTOS Y ACTIVIDADES
-- ============================================================
DROP TABLE IF EXISTS eventos_y_actividades;
CREATE TABLE eventos_y_actividades (
    id_evento      INT AUTO_INCREMENT PRIMARY KEY,
    nombre_evento  VARCHAR(150) NOT NULL,
    descripcion    TEXT,
    fecha          DATE         NOT NULL,
    hora_inicio    TIME         NOT NULL,
    hora_fin       TIME         NOT NULL,
    ubicacion      VARCHAR(120) NOT NULL,
    tipo_evento    ENUM('Académico', 'Cultural', 'Deportivo', 'Formación') NOT NULL,
    estado         VARCHAR(30)  NOT NULL DEFAULT 'Programado',
    id_usuario     INT          DEFAULT NULL,
    cupo           INT          DEFAULT 0,
    inscritos      INT          DEFAULT 0,
    created_at     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_eventos_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario),
    INDEX idx_eventos_fecha (fecha)
) ENGINE=InnoDB;

-- ============================================================
-- INSCRIPCIONES (N:N usuarios ↔ eventos)
-- ============================================================
DROP TABLE IF EXISTS inscripciones_eventos;
CREATE TABLE inscripciones_eventos (
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_evento      INT NOT NULL,
    id_usuario     INT NOT NULL,
    fecha_inscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_inscripciones_evento FOREIGN KEY (id_evento) REFERENCES eventos_y_actividades (id_evento) ON DELETE CASCADE,
    CONSTRAINT fk_inscripciones_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE,
    UNIQUE KEY uq_inscripcion (id_evento, id_usuario),
    -- Cubre el listado de inscritos por evento ordenado por fecha
    -- (events-service: WHERE id_evento = ? ORDER BY fecha_inscripcion).
    INDEX idx_inscripciones_evento_fecha (id_evento, fecha_inscripcion)
) ENGINE=InnoDB;

-- ============================================================
-- SOLICITUDES
-- estado guarda el código en mayúsculas que usa el frontend
-- (REGISTRADA, EN_REVISION, ASIGNADA, EN_PROCESO, PAUSADA,
--  RESUELTA, CERRADA, RECHAZADA).
-- ============================================================
DROP TABLE IF EXISTS solicitudes;
CREATE TABLE solicitudes (
    id_solicitud    INT AUTO_INCREMENT PRIMARY KEY,
    codigo          VARCHAR(30)  DEFAULT '',
    tipo            VARCHAR(120) NOT NULL,
    id_usuario      INT          DEFAULT NULL,
    id_servicio     INT          DEFAULT NULL,
    id_responsable  INT          DEFAULT NULL,
    prioridad       ENUM('Baja', 'Media', 'Alta') DEFAULT 'Media',
    dependencia     VARCHAR(120) DEFAULT '',
    fecha_solicitud DATE         DEFAULT (CURRENT_DATE),
    descripcion     TEXT         NOT NULL,
    solicitante     VARCHAR(120) DEFAULT '',
    estado          VARCHAR(20)  NOT NULL DEFAULT 'REGISTRADA',
    respuesta       TEXT,
    created_at      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_solicitudes_usuario     FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE SET NULL,
    CONSTRAINT fk_solicitudes_servicio    FOREIGN KEY (id_servicio) REFERENCES servicios (id_servicio) ON DELETE SET NULL,
    CONSTRAINT fk_solicitudes_responsable FOREIGN KEY (id_responsable) REFERENCES usuarios (id_usuario) ON DELETE SET NULL,
    INDEX idx_solicitudes_estado (estado),
    INDEX idx_solicitudes_usuario (id_usuario)
) ENGINE=InnoDB;

-- ============================================================
-- HISTORIAL DE SOLICITUDES (auditoría de estados y notas)
-- ============================================================
DROP TABLE IF EXISTS historial_solicitudes;
CREATE TABLE historial_solicitudes (
    id_historial   INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud   INT          NOT NULL,
    tipo           VARCHAR(30)  NOT NULL,
    estado         VARCHAR(20)  DEFAULT NULL,
    responsable    VARCHAR(120) DEFAULT '',
    usuario        VARCHAR(120) DEFAULT '',
    fecha          DATETIME     DEFAULT CURRENT_TIMESTAMP,
    descripcion    VARCHAR(500) DEFAULT '',
    CONSTRAINT fk_historial_solicitud FOREIGN KEY (id_solicitud) REFERENCES solicitudes (id_solicitud) ON DELETE CASCADE,
    INDEX idx_historial_solicitud (id_solicitud)
) ENGINE=InnoDB;

-- ============================================================
-- RESERVAS
-- ============================================================
DROP TABLE IF EXISTS reservas;
CREATE TABLE reservas (
    id_reserva    INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario    INT         NOT NULL,
    id_recurso    INT         NOT NULL,
    fecha_reserva DATE        NOT NULL,
    hora_inicio   TIME        NOT NULL,
    hora_fin      TIME        NOT NULL,
    motivo        VARCHAR(500) DEFAULT '',
    observaciones VARCHAR(500) DEFAULT '',
    estado        VARCHAR(30) NOT NULL DEFAULT 'Confirmada',
    created_at    TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_reservas_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_reservas_recurso FOREIGN KEY (id_recurso) REFERENCES recursos (id_recurso) ON DELETE CASCADE,
    UNIQUE KEY uq_reserva (id_recurso, fecha_reserva, hora_inicio),
    INDEX idx_reservas_fecha (fecha_reserva)
) ENGINE=InnoDB;

-- ============================================================
-- NOTIFICACIONES
-- ============================================================
DROP TABLE IF EXISTS notificaciones;
CREATE TABLE notificaciones (
    id_notificacion    INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario         INT          NOT NULL,
    titulo             VARCHAR(150) NOT NULL,
    mensaje            TEXT         NOT NULL,
    tipo_notificacion  VARCHAR(40)  DEFAULT '',
    icono              VARCHAR(40)  DEFAULT '',
    leida              TINYINT(1)   NOT NULL DEFAULT 0,
    referencia_tabla   VARCHAR(40)  DEFAULT NULL,
    referencia_id      INT          DEFAULT NULL,
    fecha_envio        DATETIME     DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notificaciones_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE,
    INDEX idx_notificaciones_usuario_leida (id_usuario, leida),
    -- Cubre el listado por usuario ordenado por fecha
    -- (notifications-service: WHERE id_usuario = ? ORDER BY fecha_envio DESC).
    INDEX idx_notificaciones_usuario_fecha (id_usuario, fecha_envio)
) ENGINE=InnoDB;

-- ============================================================
-- PQRS
-- id_pqrs es AUTO_INCREMENT: el feedback-service inserta y luego
-- consulta por result.insertId.
-- ============================================================
DROP TABLE IF EXISTS pqrs;
CREATE TABLE pqrs (
    id_pqrs        INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario     INT          DEFAULT NULL,
    tipo           ENUM('Petición', 'Queja', 'Reclamo', 'Sugerencia') NOT NULL,
    fecha          DATE         NOT NULL,
    estado         VARCHAR(30)  NOT NULL DEFAULT 'Abierta',
    descripcion    TEXT         NOT NULL,
    respuesta      TEXT,
    fecha_respuesta DATE        DEFAULT NULL,
    -- Campos de radicación que el frontend ya modela (utils/pqrs.js).
    sede            VARCHAR(40)  NOT NULL DEFAULT 'SINCELEJO',
    area            VARCHAR(120) NOT NULL DEFAULT 'PQRS',
    asunto          VARCHAR(200) NOT NULL DEFAULT '',
    tipo_perfil     VARCHAR(40)  NOT NULL DEFAULT 'Estudiante',
    tipo_documento  VARCHAR(80)  NOT NULL DEFAULT '',
    identificacion  VARCHAR(30)  NOT NULL DEFAULT '',
    nombre          VARCHAR(120) NOT NULL DEFAULT '',
    telefono        VARCHAR(30)  NOT NULL DEFAULT '',
    correo          VARCHAR(120) NOT NULL DEFAULT '',
    prioridad       VARCHAR(20)  NOT NULL DEFAULT 'Media',
    asignado_a      VARCHAR(120) NOT NULL DEFAULT '',
    adjunto         VARCHAR(255) DEFAULT NULL,
    created_at     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_pqrs_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE SET NULL,
    INDEX idx_pqrs_estado (estado)
) ENGINE=InnoDB;

-- ============================================================
-- INFO ACADÉMICA
-- ============================================================
DROP TABLE IF EXISTS info_academica;
CREATE TABLE info_academica (
    id_publicacion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario     INT          DEFAULT NULL,
    titulo         VARCHAR(200) NOT NULL,
    categoria      VARCHAR(80)  NOT NULL,
    fecha          DATE         NOT NULL,
    autor          VARCHAR(120) NOT NULL,
    contenido      TEXT         NOT NULL,
    imagen         VARCHAR(255) DEFAULT NULL,
    estado         VARCHAR(30)  NOT NULL DEFAULT 'Publicado',
    -- Campos que el frontend ya modela (utils/infoAcademica.js).
    programa       VARCHAR(120) NOT NULL DEFAULT 'Toda la comunidad',
    tipo_vigencia  VARCHAR(20)  NOT NULL DEFAULT 'Permanente',
    vigencia       DATE         DEFAULT NULL,
    destacado      TINYINT(1)   NOT NULL DEFAULT 0,
    created_at     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_info_academica_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE SET NULL,
    INDEX idx_info_academica_fecha (fecha)
) ENGINE=InnoDB;

-- ============================================================
-- CONFIGURACIÓN (clave/valor por usuario y sección)
-- ============================================================
DROP TABLE IF EXISTS configuracion;
CREATE TABLE configuracion (
    id_config   INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario  INT         DEFAULT NULL,
    seccion     VARCHAR(60) NOT NULL,
    valor       TEXT        NOT NULL,
    created_at  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_configuracion_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE,
    UNIQUE KEY uq_config (id_usuario, seccion)
) ENGINE=InnoDB;

-- ============================================================
-- AUDITORÍA
-- ============================================================
DROP TABLE IF EXISTS auditoria;
CREATE TABLE auditoria (
    id_auditoria BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario   INT          DEFAULT NULL,
    accion       VARCHAR(60)  NOT NULL,
    entidad      VARCHAR(60)  NOT NULL,
    id_entidad   VARCHAR(60)  DEFAULT NULL,
    detalle      VARCHAR(500) DEFAULT '',
    fecha        TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_auditoria_usuario (id_usuario),
    INDEX idx_auditoria_fecha (fecha)
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- DATOS SEMILLA
-- ============================================================
INSERT INTO roles (id_rol, nombre_rol, descripcion) VALUES
    (1, 'Administrador', 'Acceso total al sistema'),
    (2, 'Estudiante',      'Comunidad estudiantil'),
    (3, 'Docente',         'Personal docente'),
    (4, 'Administrativo',  'Personal administrativo');

INSERT INTO servicios (id_servicio, nombre, descripcion) VALUES
    (1, 'Solicitudes', 'Peticiones y trámites académicos'),
    (2, 'Reservas',    'Reservas de espacios y equipos'),
    (3, 'Eventos',     'Eventos y actividades institucionales'),
    (4, 'Recursos',    'Préstamos de recursos'),
    (5, 'PQRS',        'Peticiones, quejas y reclamos');

-- Contraseña = el identificacion del usuario + "123" en texto plano.
-- El auth-service migra cada fila a hash bcrypt en el primer login exitoso
-- (ver verificarPassword en auth.controller.js), así que la semilla no
-- necesita hashes pregenerados.
INSERT INTO usuarios
    (id_usuario, identificacion, usuario, cedula, contraseña, nombre, apellido,
     correo, telefono, id_rol, tipo_usuario, programa, cargo, campus, foto_perfil, estado)
VALUES
    (1,  'admin',      'admin',      '1023456789', 'admin123', 'Natalia',    'Rodríguez',    'natalia.rodriguez@uajs.edu.co',    '3001234501', 1, 'Administrador', 'Dirección Académica',     'Coordinadora general',      'Campus principal', 'https://api.dicebear.com/7.x/initials/svg?seed=NR', 'Activo'),
    (2,  'funcionario', 'funcionario', '1023456788', 'func123',  'Carlos',     'Méndez',       'carlos.mendez@uajs.edu.co',       '3001234502', 4, 'Administrativo', 'Bienestar Universitario',   'Analista de servicios',     'Campus Norte',     'https://api.dicebear.com/7.x/initials/svg?seed=CM', 'Activo'),
    (3,  'profesor',   'profesor',   '1023456787', 'prof123',  'Laura',      'Gómez',        'laura.gomez@uajs.edu.co',        '3001234503', 3, 'Docente',        'Matemáticas',              'Docente titular',           'Campus central',   'https://api.dicebear.com/7.x/initials/svg?seed=LG', 'Activo'),
    (4,  'estudiante', 'estudiante', '1023456786', 'est123',  'Andrés',     'Torres',       'andres.torres@uajs.edu.co',       '3001234504', 2, 'Estudiante',     'Ingeniería de Sistemas',    'Estudiante',                'Campus central',   'https://api.dicebear.com/7.x/initials/svg?seed=AT', 'Activo'),
    (5,  'docente2',   'docente2',   '1023456785', 'doc123',  'María Fernanda', 'Cárdenas', 'mf.cardenas@uajs.edu.co',        '3001234505', 3, 'Docente',        'Ingeniería de Software',    'Profesora de proyectos',    'Campus principal', 'https://api.dicebear.com/7.x/initials/svg?seed=MC', 'Activo'),
    (6,  'estudiante2','estudiante2','1023456784', 'stu123',  'Valentina',   'Morales',      'valentina.morales@uajs.edu.co',  '3001234506', 2, 'Estudiante',     'Administración de Empresas','Estudiante',               'Campus occidente', 'https://api.dicebear.com/7.x/initials/svg?seed=VM', 'Activo'),
    (7,  'admin2',     'admin2',     '1023456783', 'ua123',   'Javier',     'Álvarez',      'javier.alvarez@uajs.edu.co',     '3001234507', 1, 'Administrador', 'Tecnología e innovación',  'Director de operación',     'Campus principal', 'https://api.dicebear.com/7.x/initials/svg?seed=JA', 'Activo'),
    (8,  'admvo',      'admvo',      '1023456782', 'adm123',  'Sofía',      'Jiménez',      'sofia.jimenez@uajs.edu.co',       '3001234508', 4, 'Administrativo', 'Servicios estudiantiles',   'Coordinadora administrativa','Campus centro',  'https://api.dicebear.com/7.x/initials/svg?seed=SJ', 'Inactivo'),
    (9,  'docente3',   'docente3',   '1023456781', 'doc456',  'Ricardo',    'Torres',       'ricardo.torres@uajs.edu.co',     '3001234509', 3, 'Docente',        'Física',                   'Docente de laboratorio',    'Campus central',   'https://api.dicebear.com/7.x/initials/svg?seed=RT', 'Activo'),
    (10, 'estudiante3','estudiante3','1023456780', 'stu456',  'Isabella',   'Ramírez',      'isabella.ramirez@uajs.edu.co',   '3001234510', 2, 'Estudiante',     'Ingeniería Civil',         'Estudiante',                'Campus Norte',     'https://api.dicebear.com/7.x/initials/svg?seed=IR', 'Activo'),
    (11, 'admin3',     'admin3',     '1023456779', 'admin456','Andrés',     'Gutiérrez',    'andres.gutierrez@uajs.edu.co',   '3001234511', 1, 'Administrador', 'Tecnologías de la información','Director de sistemas',   'Campus principal', 'https://api.dicebear.com/7.x/initials/svg?seed=AG', 'Activo'),
    (12, 'admvo2',     'admvo2',     '1023456778', 'adm456',  'Paula',      'Vargas',       'paula.vargas@uajs.edu.co',       '3001234512', 4, 'Administrativo', 'Recursos Humanos',         'Analista de talento humano','Campus occidente','https://api.dicebear.com/7.x/initials/svg?seed=PV', 'Activo'),
    (13, 'docente4',   'docente4',   '1023456777', 'doc789',  'Fernando',   'Castillo',     'fernando.castillo@uajs.edu.co', '3001234513', 3, 'Docente',        'Economía',                 'Docente titular',           'Campus central',   'https://api.dicebear.com/7.x/initials/svg?seed=FC', 'Activo'),
    (14, 'estudiante4','estudiante4','1023456776', 'stu789',  'Camila',     'Herrera',      'camila.herrera@uajs.edu.co',    '3001234514', 2, 'Estudiante',     'Derecho',                  'Estudiante',                'Campus centro',    'https://api.dicebear.com/7.x/initials/svg?seed=CH', 'Activo'),
    (15, 'admin4',     'admin4',     '1023456775', 'admin789','Luisa',      'Cardona',      'luisa.cardona@uajs.edu.co',      '3001234515', 1, 'Administrador', 'Administración',           'Rectora',                   'Campus principal', 'https://api.dicebear.com/7.x/initials/svg?seed=LC', 'Activo'),
    (16, 'docente5',   'docente5',   '1023456774', 'doc000',  'Sebastián',   'Rojas',        'sebastian.rojas@uajs.edu.co',   '3001234516', 3, 'Docente',        'Idiomas',                  'Docente de inglés',        'Campus occidente', 'https://api.dicebear.com/7.x/initials/svg?seed=SR', 'Inactivo'),
    (17, 'estudiante5','estudiante5','1023456773', 'stu000',  'Daniela',    'Ortiz',        'daniela.ortiz@uajs.edu.co',     '3001234517', 2, 'Estudiante',     'Psicología',               'Estudiante',                'Campus Norte',     'https://api.dicebear.com/7.x/initials/svg?seed=DO', 'Activo'),
    (18, 'docente6',   'docente6',   '1023456772', 'doc111',  'Oscar',      'Navas',        'oscar.navas@uajs.edu.co',       '3001234518', 3, 'Docente',        'Ingeniería Industrial',    'Coordinador de laboratorio','Campus principal', 'https://api.dicebear.com/7.x/initials/svg?seed=ON', 'Activo'),
    (19, 'estudiante6','estudiante6','1023456771', 'stu222',  'Mateo',      'Rengifo',      'mateo.rengifo@uajs.edu.co',     '3001234519', 2, 'Estudiante',     'Administración de Empresas','Estudiante',              'Campus central',   'https://api.dicebear.com/7.x/initials/svg?seed=MR', 'Activo'),
    (20, 'estudiante7','estudiante7','1023456770', 'stu333',  'Catalina',   'Salinas',      'catalina.salinas@uajs.edu.co',  '3001234520', 2, 'Estudiante',     'Ingeniería de Sistemas',    'Estudiante',                'Campus Norte',     'https://api.dicebear.com/7.x/initials/svg?seed=CS', 'Activo');

INSERT INTO recursos
    (id_recurso, nombre_recurso, codigo, tipo_recurso, descripcion, ubicacion, capacidad, estado, disponibilidad)
VALUES
    (1,  'Auditorio Principal',      'REC-001', 'Auditorios',  'Auditorio para eventos institucionales', 'Edificio A - Piso 1', 300, 'Disponible', 'Disponible'),
    (2,  'Sala de Conferencias 1',   'REC-002', 'Salas',       'Sala para reuniones y talleres',         'Edificio B - Piso 2', 40,  'Disponible', 'Disponible'),
    (3,  'Sala de Conferencias 2',   'REC-003', 'Salas',       'Sala para reuniones',                    'Edificio B - Piso 2', 30,  'Ocupada',    'Ocupada'),
    (4,  'Laboratorio de Informatica 1', 'REC-004', 'Laboratorios', 'Laboratorio de computación',        'Edificio C - Piso 1', 30,  'Disponible', 'Disponible'),
    (5,  'Laboratorio de Fisica',    'REC-005', 'Laboratorios', 'Laboratorio de prácticas',               'Edificio C - Piso 2', 25,  'Disponible', 'Disponible'),
    (6,  'Proyector Portatil 1',     'REC-006', 'Equipos',     'Proyector para presentaciones',          'Bodega tecnológica', 1,     'Disponible', 'Disponible'),
    (7,  'Proyector Portatil 2',     'REC-007', 'Equipos',     'Proyector para presentaciones',          'Bodega tecnológica', 1,     'Disponible', 'Disponible'),
    (8,  'Sala de Estudio 1',        'REC-008', 'Salas',       'Sala de estudio individual',              'Biblioteca - Piso 3', 8,   'Disponible', 'Disponible'),
    (9,  'Sala de Estudio 2',        'REC-009', 'Salas',       'Sala de estudio individual',              'Biblioteca - Piso 3', 8,   'Mantenimiento','Mantenimiento'),
     (10, 'Auditorio VIP',            'REC-010', 'Auditorios',  'Auditorio pequeño para reuniones',         'Edificio A - Piso 3', 60,  'Disponible', 'Disponible'),
     (11, 'Sala de Estudio 3',        'REC-011', 'Salas',       'Sala de estudio grupal',                   'Biblioteca - Piso 4', 12,  'Disponible', 'Disponible'),
     (12, 'Laboratorio de Química',   'REC-012', 'Laboratorios', 'Laboratorio para prácticas de química',    'Edificio D - Piso 1', 20,  'Disponible', 'Disponible'),
     (13, 'Trípode de Audio',         'REC-013', 'Equipos',     'Micrófonos y mesa de sonido',              'Bodega tecnológica', 1,     'Disponible', 'Disponible'),
     (14, 'Kit Audiovisual',          'REC-014', 'Equipos',     'Cámara, micrófono y luces para eventos',    'Bodega tecnológica', 1,     'En mantenimiento', 'En mantenimiento');

INSERT INTO eventos_y_actividades
    (id_evento, nombre_evento, descripcion, fecha, hora_inicio, hora_fin, ubicacion, tipo_evento, estado, id_usuario, cupo, inscritos)
VALUES
    (1, 'Bienvenida a nuevos estudiantes', 'Acto de bienvenida para el periodo nuevo',      '2026-09-15', '08:00:00', '10:00:00', 'Auditorio Principal', 'Académico',   'Programado', 1, 300, 180),
    (2, 'Taller de Emprendimiento',        'Taller de ideas de negocio para estudiantes',   '2026-09-18', '14:00:00', '17:00:00', 'Sala de Conferencias 1', 'Formación', 'Programado', 1, 40,  35),
    (3, 'Feria de Empleabilidad',          'Encuentro con empresas aliadas',               '2026-09-22', '09:00:00', '13:00:00', 'Auditorio Principal', 'Cultural',     'Programado', 1, 300, 210),
    (4, 'Torneo Deportivo Intercampus',   'Encuentro deportivo entre facultades',          '2026-10-02', '07:00:00', '12:00:00', 'Cancha central',      'Deportivo',  'Programado', 1, 120, 60),
    (5, 'Seminario de Investigación',      'Presentación de resultados de investigación',  '2026-09-25', '10:00:00', '12:30:00', 'Auditorio VIP',       'Académico',   'Programado', 1, 60,  41),
    (6, 'Concierto de Música Andina',     'Presentación artística de fin de semestre',     '2026-10-10', '18:00:00', '21:00:00', 'Auditorio Principal', 'Cultural',    'Programado', 1, 300, 240),
    (7, 'Jornada de Puertas Abiertas',     'Recorrido por instalaciones y programas',      '2026-10-05', '09:00:00', '16:00:00', 'Campus principal',    'Académico',   'Programado', 1, 200, 120),
    (8, 'Taller de Ofimática',             'Introducción a herramientas de productividad',  '2026-10-12', '15:00:00', '18:00:00', 'Laboratorio de Informatica 1', 'Formación', 'Programado', 5, 25, 18);

INSERT INTO inscripciones_eventos (id_evento, id_usuario) VALUES
    (1, 4), (1, 6), (1, 10), (1, 14), (1, 17),
    (2, 4), (2, 6), (2, 14),
    (3, 4), (3, 10), (3, 17),
    (5, 6), (5, 14),
    (7, 4), (7, 10), (7, 19),
    (8, 6), (8, 19), (8, 20);

INSERT INTO solicitudes
    (id_solicitud, codigo, tipo, id_usuario, id_servicio, id_responsable, prioridad, dependencia, fecha_solicitud, descripcion, solicitante, estado, respuesta)
VALUES
    (1, 'SOL-2026-001', 'Reserva de auditorio',      4,  2, 2, 'Media', 'Bienestar Universitario',         '2026-09-01', 'Reserva del auditorio principal para la cátedra de inteligencia artificial aplicada.', 'Andrés Torres',    'EN_PROCESO', 'Se está confirmando agenda y recursos audiovisuales.'),
    (2, 'SOL-2026-002', 'Constancia académica',      6,  1, NULL, 'Alta', 'Registro y Control',          '2026-09-02', 'Solicitud de constancia de notas para trámites administrativos del semestre actual.',      'Valentina Morales','EN_REVISION', ''),
    (3, 'SOL-2026-003', 'Reserva de laboratorio',    10, 2, 2, 'Media', 'Laboratorios',                '2026-09-04', 'Uso del laboratorio de informática 3 para práctica de redes y configuración básica.',      'Isabella Ramírez', 'RESUELTA',    'Reserva cerrada sin incidencias.'),
    (4, 'SOL-2026-004', 'Inscripción a evento',      14, 3, NULL, 'Baja',  'Bienestar Universitario',         '2026-09-05', 'Inscripción al taller de emprendimiento y liderazgo del programa académico.',            'Camila Herrera',   'REGISTRADA',  ''),
    (5, 'SOL-2026-005', 'Soporte técnico',           17, 5, 2, 'Alta',  'Infraestructura Tecnológica',  '2026-09-06', 'Reporte de fallas en los equipos del laboratorio de sistemas y conexión a red.',              'Daniela Ortiz',    'PAUSADA',     'En espera de respuesta del proveedor de red.'),
    (6, 'SOL-2026-006', 'Préstamo de equipos',       4,  4, 2, 'Media', 'Logística',                   '2026-09-08', 'Préstamo de dos proyectores para la feria de empleabilidad y actividades de ingreso.',    'Andrés Torres',    'CERRADA',     'Equipos devueltos y revisados.');

INSERT INTO historial_solicitudes
    (id_solicitud, tipo, estado, responsable, usuario, fecha, descripcion)
VALUES
    (1, 'CREACION',  'REGISTRADA',  '',        'Andrés Torres',  '2026-09-01 09:00', 'Solicitud registrada.'),
    (1, 'ESTADO',    'EN_REVISION', 'Carlos Méndez', 'Carlos Méndez', '2026-09-01 09:15', 'Verificación de disponibilidad y logística del espacio.'),
    (1, 'ASIGNACION', 'ASIGNADA',   'Carlos Méndez', 'Carlos Méndez', '2026-09-02 10:30', 'Auditorio principal asignado como responsable.'),
    (1, 'ESTADO',    'EN_PROCESO', 'Carlos Méndez', 'Carlos Méndez', '2026-09-02 11:05', 'Se está confirmando agenda y recursos audiovisuales.'),

    (2, 'CREACION',  'REGISTRADA',  '',               'Valentina Morales', '2026-09-02 08:20', 'Solicitud registrada.'),
    (2, 'NOTA',      NULL,          '',               'Carlos Méndez',     '2026-09-02 09:00', 'Se solicita documento de identidad adicional.'),

    (3, 'CREACION',  'REGISTRADA',  '',               'Isabella Ramírez',  '2026-09-04 07:40', 'Solicitud registrada.'),
    (3, 'ESTADO',    'EN_REVISION', 'Carlos Méndez',  'Carlos Méndez',     '2026-09-04 08:00', 'Verificación de disponibilidad del laboratorio.'),
    (3, 'ASIGNACION', 'ASIGNADA',   'Carlos Méndez',  'Carlos Méndez',     '2026-09-05 09:10', 'Laboratorio asignado para la práctica.'),
    (3, 'ESTADO',    'EN_PROCESO',  'Carlos Méndez',  'Carlos Méndez',     '2026-09-06 14:00', 'Sesión ejecutada con equipos activos.'),
    (3, 'ESTADO',    'RESUELTA',    'Carlos Méndez',  'Carlos Méndez',     '2026-09-07 16:30', 'Reserva cerrada sin incidencias.'),

    (4, 'CREACION',  'REGISTRADA',  '',               'Camila Herrera',    '2026-09-05 10:10', 'Solicitud registrada.'),

    (5, 'CREACION',  'REGISTRADA',  '',               'Daniela Ortiz',     '2026-09-06 08:00', 'Solicitud registrada.'),
    (5, 'ESTADO',    'EN_REVISION', 'Carlos Méndez',  'Carlos Méndez',     '2026-09-06 08:30', 'Caso asignado a soporte tecnológico.'),
    (5, 'ASIGNACION', 'ASIGNADA',   'Carlos Méndez',  'Carlos Méndez',     '2026-09-07 09:00', 'Técnico responsable definido para la revisión.'),
    (5, 'ESTADO',    'EN_PROCESO',  'Carlos Méndez',  'Carlos Méndez',     '2026-09-07 11:20', 'Diagnóstico inicial de la falla.'),
    (5, 'PAUSA',     'PAUSADA',     'Carlos Méndez',  'Carlos Méndez',     '2026-09-08 10:00', 'En espera de respuesta del proveedor de red.'),

    (6, 'CREACION',  'REGISTRADA',  '',               'Andrés Torres',     '2026-09-08 06:50', 'Solicitud registrada.'),
    (6, 'ESTADO',    'EN_REVISION', 'Carlos Méndez',  'Carlos Méndez',     '2026-09-08 07:15', 'Verificación de disponibilidad de equipos.'),
    (6, 'ASIGNACION', 'ASIGNADA',   'Carlos Méndez',  'Carlos Méndez',     '2026-09-09 08:40', 'Dos equipos asignados al evento.'),
    (6, 'ESTADO',    'EN_PROCESO',  'Carlos Méndez',  'Carlos Méndez',     '2026-09-10 13:00', 'Entrega finalizada para la actividad.'),
    (6, 'ESTADO',    'RESUELTA',    'Carlos Méndez',  'Carlos Méndez',     '2026-09-12 17:20', 'Equipos devueltos y revisados.'),
    (6, 'ESTADO',    'CERRADA',     'Carlos Méndez',  'Carlos Méndez',     '2026-09-13 09:00', 'Solicitud cerrada por el sistema.');

INSERT INTO reservas
    (id_reserva, id_usuario, id_recurso, fecha_reserva, hora_inicio, hora_fin, motivo, estado)
VALUES
    (1,  4,  1,  '2026-09-16', '08:00:00', '11:00:00', 'Bienvenida a nuevos estudiantes',   'Confirmada'),
    (2,  6,  2,  '2026-09-18', '14:00:00', '17:00:00', 'Taller de emprendimiento',          'Confirmada'),
    (3,  10, 4,  '2026-09-19', '09:00:00', '12:00:00', 'Práctica de redes',                  'Confirmada'),
    (4,  14, 10, '2026-09-25', '10:00:00', '12:30:00', 'Seminario de investigación',        'Confirmada'),
    (5,  17, 3,  '2026-09-17', '09:00:00', '11:00:00', 'Reunión de proyecto',                'Pendiente'),
    (6,  4,  6,  '2026-09-22', '08:00:00', '18:00:00', 'Feria de empleabilidad',             'Confirmada'),
    (7,  6,  7,  '2026-09-22', '08:00:00', '18:00:00', 'Feria de empleabilidad',             'Confirmada'),
    (8,  10, 5,  '2026-09-21', '10:00:00', '13:00:00', 'Práctica de física',                 'Cancelada'),
    (9,  14, 8,  '2026-09-20', '07:00:00', '09:00:00', 'Sesión de estudio',                  'Confirmada'),
    (10, 17, 2,  '2026-09-23', '15:00:00', '17:00:00', 'Taller grupal',                      'Pendiente'),
    (11, 4,  10, '2026-09-24', '09:00:00', '11:00:00', 'Reunión de coordinación',           'Confirmada'),
    (12, 6,  4,  '2026-09-26', '14:00:00', '17:00:00', 'Práctica de bases de datos',         'Confirmada');

INSERT INTO notificaciones
    (id_usuario, titulo, mensaje, tipo_notificacion, icono, leida, fecha_envio)
VALUES
    (1, 'Solicitud recibida',      'Tu solicitud SOL-2026-001 fue registrada correctamente.',  'solicitud',  'check',  0, '2026-09-01 09:00:00'),
    (1, 'Reserva confirmada',      'La reserva del Auditorio Principal está confirmada.',        'reserva',    'calendar',0, '2026-09-01 12:30:00'),
    (4, 'Solicitud en revisión',   'Tu solicitud está siendo revisada por el área de registro.', 'solicitud',  'clock',  0, '2026-09-02 08:20:00'),
    (4, 'Evento próximo',          'La bienvenida a nuevos estudiantes será el 15 de septiembre.', 'evento',    'megaphone', 0, '2026-09-03 10:00:00'),
    (6, 'Recordatorio de taller',  'El taller de emprendimiento comienza a las 2:00 p. m.',      'evento',     'bell',   1, '2026-09-04 09:15:00'),
    (17,'Soporte en pausa',        'Tu caso está en espera del proveedor de red.',               'solicitud',  'pause',  0, '2026-09-08 10:05:00');

INSERT INTO pqrs
    (id_usuario, tipo, fecha, estado, descripcion, respuesta, fecha_respuesta,
     sede, area, asunto, tipo_perfil, tipo_documento, identificacion, nombre, telefono, correo, prioridad, asignado_a, adjunto)
VALUES
    (4,  'Petición',   '2026-09-03', 'Resuelta',   'Solicitud de actualización de la información académica en el portal.',  'Información actualizada.', '2026-09-05',
        'SINCELEJO', 'Admisiones y Registro', 'Actualización de datos académicos', 'Estudiante', 'Cédula de ciudadanía (CC)', '1023456786', 'Andrés Torres', '3001234504', 'andres.torres@uajs.edu.co', 'Media', 'Admisiones y Registro', NULL),
    (6,  'Queja',      '2026-09-04', 'En proceso', 'Los proyectores del salón no encienden durante las clases.',            NULL, NULL,
        'SINCELEJO', 'Sistemas e Infraestructura TI', 'Proyectores del salón no encienden', 'Estudiante', 'Cédula de ciudadanía (CC)', '1023456784', 'Valentina Morales', '3001234506', 'valentina.morales@uajs.edu.co', 'Alta', 'Sistemas e Infraestructura TI', NULL),
    (10, 'Reclamo',    '2026-09-06', 'Abierta',    'El laboratorio de física no tiene elementos de seguridad disponibles.',  NULL, NULL,
        'CARTAGENA', 'Facultad de Ciencias de la Ingeniería', 'Falta de elementos de seguridad en laboratorio', 'Estudiante', 'Cédula de ciudadanía (CC)', '1023456780', 'Isabella Ramírez', '3001234510', 'isabella.ramirez@uajs.edu.co', 'Alta', '', NULL),
    (14, 'Sugerencia', '2026-09-08', 'Resuelta',   'Habilitar un punto de recarga adicional en la biblioteca.',                'Punto habilitado en piso 2.', '2026-09-10',
        'SINCELEJO', 'Biblioteca', 'Punto de recarga adicional en biblioteca', 'Estudiante', 'Cédula de ciudadanía (CC)', '1023456776', 'Camila Herrera', '3001234514', 'camila.herrera@uajs.edu.co', 'Baja', 'Biblioteca', NULL),
    (17, 'Petición',   '2026-09-10', 'Abierta',    'Solicitar segunda salida del laboratorio por actividades CAMPUS.',       NULL, NULL,
        'SINCELEJO', 'Facultad de Ciencias de la Ingeniería', 'Segunda salida del laboratorio para actividades CAMPUS', 'Estudiante', 'Cédula de ciudadanía (CC)', '1023456773', 'Daniela Ortiz', '3001234517', 'daniela.ortiz@uajs.edu.co', 'Media', '', NULL);

INSERT INTO info_academica
    (id_usuario, titulo, categoria, fecha, autor, contenido, programa, tipo_vigencia, vigencia, destacado)
VALUES
    (3,  'Calendario Académico 2026-2', 'Calendario', '2026-09-01', 'Laura Gómez',    'Fechas oficiales del calendario académico del segundo semestre de 2026.', 'Toda la comunidad', 'Hasta', '2026-12-20', 1),
    (5,  'Lineamientos de Proyectos',   'Normatividad','2026-08-20', 'María Fernanda Cárdenas', 'Lineamientos metodológicos para el desarrollo de proyectos de grado.', 'Ingeniería de Software', 'Permanente', NULL, 0),
    (1,  'Protocolo de Uso de Espacios','Normatividad','2026-07-15', 'Natalia Rodríguez', 'Protocolo de reserva y uso de espacios académicos de la institución.', 'Toda la comunidad', 'Permanente', NULL, 0);

INSERT INTO configuracion (id_usuario, seccion, valor) VALUES
    (1, 'general',      '{"tema":"claro","notificaciones":true}'),
    (1, 'notificaciones','{"email":true,"push":true,"resumen":"diario"}'),
    (1, 'apariencia',   '{"fuente":"media","densidad":"normal"}');

-- ============================================================
-- VISTAS DE APOYO
-- ============================================================
CREATE OR REPLACE VIEW v_solicitudes_detalle AS
SELECT s.*,
       u.nombre  AS usuario_nombre,
       u.apellido AS usuario_apellido,
       sv.nombre AS servicio_nombre
FROM solicitudes s
LEFT JOIN usuarios  u  ON s.id_usuario     = u.id_usuario
LEFT JOIN servicios sv ON s.id_servicio    = sv.id_servicio;

CREATE OR REPLACE VIEW v_reservas_detalle AS
SELECT r.*,
       u.nombre AS usuario_nombre,
       rec.nombre_recurso,
       rec.tipo_recurso
FROM reservas r
LEFT JOIN usuarios u   ON r.id_usuario = u.id_usuario
LEFT JOIN recursos rec ON r.id_recurso = rec.id_recurso;