# 📋 Análisis del Frontend React - UAJS Smart Campus

**Fecha de análisis:** 2026-09-01  
**Versión:** 1.0

---

## 1. 📑 MÓDULOS/PÁGINAS PRINCIPALES

El frontend está organizado en 18 módulos funcionales principales:

| Módulo | Ruta | Descripción | Rol Principal |
|--------|------|-------------|---|
| **Dashboard** | `/` | Panel de control personalizado | Todos |
| **Login** | `/login` | Autenticación de usuarios | Público |
| **Solicitudes** | `/solicitudes` | Gestión de solicitudes de servicios | Estudiante, Docente, Admin |
| **Reservas** | `/reservas` | Reserva de espacios y recursos | Todos |
| **Recursos** | `/recursos` | Catálogo de recursos disponibles | Todos |
| **Eventos** | `/eventos` | Registro de eventos y actividades | Todos |
| **Usuarios** | `/usuarios` | Gestión de usuarios (Admin) | Administrador |
| **Notificaciones** | `/notificaciones` | Centro de notificaciones | Todos |
| **PQRS** | `/pqrs` | Peticiones, Quejas, Reclamos, Sugerencias | Todos |
| **Perfil** | `/perfil` | Perfil del usuario actual | Todos |
| **Configuración** | `/configuracion` | Preferencias del usuario | Todos |
| **Info Académica** | `/info-academica` | Información académica y publicaciones | Docente, Admin |
| **Reportes** | `/reportes` | Generación de reportes y estadísticas | Admin, Administrativo |
| **Servicios** | `/servicios` | Catálogo de servicios disponibles | Todos |
| **Notificaciones (Detail)** | `/notificaciones/:id` | Detalle de notificación | Todos |
| **Landing** | `/landing` | Página de inicio | Público |
| **Recuperar (Contraseña)** | `/recuperar` | Recuperación de contraseña | Público |
| **NotFound** | `/404` | Página no encontrada | Todos |

---

## 2. 🔍 DATOS SINTÉTICOS POR MÓDULO

### 📌 **SOLICITUDES** (`/src/utils/solicitudes.js`)

```javascript
{
  id: "SOL-2026-001",              // Código único
  tipo: "Reserva de auditorio",     // Tipo de solicitud
  servicio: "Reservas",             // Servicio asociado
  fecha: "2026-09-01",              // Fecha de creación
  estado: "En proceso",             // Estado actual
  solicitante: "Natalia Rodríguez", // Nombre del solicitante
  descripcion: "Reserva del auditorio...", // Detalles
  historial: [                      // Seguimiento de cambios
    {
      estado: "Registrada",
      fecha: "2026-09-01",
      detalle: "Solicitud registrada por la estudiante."
    },
    // ... más registros
  ]
}
```

**Estados disponibles:**
- Registrada
- En revisión
- Asignada
- En proceso
- Resuelta
- Cerrada

**Servicios vinculados:**
- Reservas
- Solicitudes
- Eventos
- PQRS
- Recursos

**Datos sintéticos:** 6 solicitudes de ejemplo

---

### 🎪 **EVENTOS** (`/src/utils/eventos.js`)

```javascript
{
  id: 1,                            // ID único
  nombre: "Cátedra de inteligencia artificial aplicada",
  fecha: "2026-09-08",              // Fecha del evento
  hora: "09:30",                    // Hora inicio
  lugar: "Auditorio principal",     // Ubicación
  categoria: "Académico",           // Categoría
  descripcion: "Jornada académica con expertos...",
  estado: "Activo",                 // Estado
  cupo: 150,                        // Capacidad
  inscritos: 118,                   // Personas inscritas
  ponente: "Dra. Ana María López",  // Organizador
  modalidad: "Presencial"           // Tipo de modalidad
}
```

**Categorías de eventos:**
- Académico
- Cultural
- Formación
- Institucional

**Modalidades:**
- Presencial
- Virtual
- Híbrido

**Estados:**
- Activo
- Finalizado
- Cancelado

**Datos sintéticos:** 6 eventos de ejemplo

---

### 👥 **USUARIOS** (`/src/utils/users.js`)

```javascript
{
  id: 1,                            // ID único
  usuario: "admin",                 // Nombre de usuario
  password: "admin123",             // Contraseña (demo)
  nombre: "Natalia",                // Nombre
  apellido: "Rodríguez",            // Apellido
  correo: "natalia.rodriguez@uajs.edu.co",
  rol: "Administrador",             // Rol asignado
  programa: "Dirección Académica",  // Programa/Departamento
  estado: "Activo",                 // Estado del usuario
  cargo: "Coordinadora general",    // Cargo/Posición
  campus: "Campus principal"        // Campus asignado
}
```

**Roles disponibles:**
- **Administrador:** Acceso total
- **Administrativo:** Gestión de servicios
- **Docente:** Académico y recursos
- **Estudiante:** Solicitudes, reservas, eventos

**Datos sintéticos:** 8 usuarios de ejemplo

**Permisos por rol:**

| Permiso | Admin | Admtivo | Docente | Estudiante |
|---------|:-----:|:-------:|:-------:|:----------:|
| Dashboard | ✓ | ✓ | ✓ | ✓ |
| Usuarios | ✓ | ✗ | ✗ | ✗ |
| Solicitudes | ✓ | ✓ | ✓ | ✓ |
| Reservas | ✓ | ✓ | ✓ | ✓ |
| Recursos | ✓ | ✓ | ✓ | ✓ |
| Eventos | ✓ | ✓ | ✓ | ✓ |
| PQRS | ✓ | ✓ | ✓ | ✓ |
| Reportes | ✓ | ✓ | ✗ | ✗ |

---

### 🏢 **RECURSOS** (`/src/utils/recursos.js`)

```javascript
{
  id: "R-001",                      // ID único
  codigo: "REC-101",                // Código del recurso
  nombre: "Salón 101",              // Nombre
  tipo: "Salas",                    // Tipo de recurso
  capacidad: 40,                    // Capacidad de personas
  ubicacion: "Bloque A · Piso 1",   // Ubicación
  estado: "Activo",                 // Estado
  disponibilidad: "Disponible"      // Disponibilidad
}
```

**Tipos de recursos:**
- Salas (aulas)
- Laboratorios
- Auditorios
- Equipos

**Estados:**
- Activo
- En mantenimiento
- Inactivo

**Disponibilidad:**
- Disponible
- En uso
- No disponible

**Datos sintéticos:** 10 recursos de ejemplo

---

### 📞 **NOTIFICACIONES** (`/src/utils/notificaciones.js`)

```javascript
{
  id: 1,                            // ID único
  tipo: "Solicitud",                // Tipo de notificación
  icono: "solicitudes",             // Icono asociado
  mensaje: "Tu solicitud SOL-2026-001 cambió a 'En proceso'...",
  fecha: "2026-09-03",              // Fecha de envío
  leida: false                      // Estado de lectura
}
```

**Tipos de notificaciones:**
- Solicitud
- Reserva
- Evento
- PQRS

**Datos sintéticos:** 6 notificaciones de ejemplo

---

### 📝 **PQRS** (`/src/utils/pqrs.js`)

```javascript
{
  id: "PQRS-2026-014",              // ID único
  tipo: "Queja",                    // Tipo de PQRS
  fecha: "2026-09-01",              // Fecha de creación
  estado: "En revisión",            // Estado
  descripcion: "Queja por demora en atención de certificados..."
}
```

**Tipos de PQRS:**
- Petición
- Queja
- Reclamo
- Sugerencia

**Estados:**
- En revisión
- Resuelta
- Cerrada
- Asignada

**Datos sintéticos:** 5 PQRS de ejemplo

---

### 📊 **REPORTES** (`/src/utils/reportes.js`)

**Contiene datos agregados:**
- KPIs principales (usuarios, solicitudes, recursos, reservas)
- Tendencias mensuales
- Recursos más utilizados
- Estadísticas por estado

**Datos sintéticos:** Datos calculados a partir de otras estructuras

---

### 🔗 **SERVICIOS** (`/src/utils/services.js`)

```javascript
{
  name: "Solicitudes",
  icon: "solicitudes",
  category: "Académico",
  path: "/solicitudes",
  description: "Gestiona trámites académicos...",
  resources: ["Constancias académicas", "Certificados de estudio", ...],
  options: ["Crear nueva solicitud", "Consultar estado", ...]
}
```

**Servicios principales:**
1. Solicitudes (Académico)
2. Reservas (Infraestructura)
3. Recursos (Infraestructura)
4. Eventos (Cultura)
5. Notificaciones (Comunicación)
6. PQRS (Atención)

---

## 3. 📦 ESTRUCTURA DE DATOS

### 🔑 Relaciones Principales

```
USUARIOS (1) ──────→ (N) SOLICITUDES
    ↓
    └─→ (N) RESERVAS
    └─→ (N) EVENTOS_Y_ACTIVIDADES
    └─→ (N) NOTIFICACIONES
    └─→ (N) INFO_ACADEMICA
    └─→ (1) CONFIGURACION
    └─→ (1) ROLES

RECURSOS (1) ────→ (N) RESERVAS

SERVICIOS (1) ───→ (N) SOLICITUDES

PQRS (1-N con USUARIOS implícitamente)
```

### 📊 Estructura de Solicitudes

**Campo de historial:** Cada solicitud mantiene un historial de cambios de estado

```javascript
historial: [
  {
    estado: String,
    fecha: Date,
    detalle: String
  }
]
```

### 📊 Estructura de Reservas

Vincula USUARIO + RECURSO + FRANJA HORARIA

```javascript
{
  id_usuario: Int,
  id_recurso: Int,
  fecha_reserva: Date,
  hora_inicio: Time,
  hora_fin: Time,
  motivo: String,
  estado: String
}
```

---

## 4. 🗄️ ESQUEMA MYSQL RECOMENDADO

### Base de Datos Completa

```sql
-- ==========================================
-- TABLA: ROLES
-- ==========================================
CREATE TABLE `roles` (
  `id_rol` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre_rol` VARCHAR(50) NOT NULL UNIQUE,
  `descripcion` VARCHAR(255),
  `estado` VARCHAR(20) DEFAULT 'Activo',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- TABLA: USUARIOS
-- ==========================================
CREATE TABLE `usuarios` (
  `id_usuario` INT PRIMARY KEY AUTO_INCREMENT,
  `identificacion` VARCHAR(20) NOT NULL UNIQUE,
  `usuario` VARCHAR(50) NOT NULL UNIQUE,
  `contraseña` VARCHAR(255) NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `apellido` VARCHAR(50) NOT NULL,
  `correo` VARCHAR(100) NOT NULL UNIQUE,
  `telefono` VARCHAR(20),
  `id_rol` INT NOT NULL,
  `programa` VARCHAR(100),
  `cargo` VARCHAR(100),
  `campus` VARCHAR(100),
  `tipo_usuario` ENUM('Administrador', 'Docente', 'Estudiante', 'Administrativo'),
  `estado` VARCHAR(20) DEFAULT 'Activo',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `ultimo_acceso` DATETIME,
  
  FOREIGN KEY (`id_rol`) REFERENCES `roles`(`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- TABLA: SERVICIOS
-- ==========================================
CREATE TABLE `servicios` (
  `id_servicio` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(255),
  `icono` VARCHAR(50),
  `categoria` VARCHAR(50),
  `estado` VARCHAR(20) DEFAULT 'Activo',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- TABLA: SOLICITUDES
-- ==========================================
CREATE TABLE `solicitudes` (
  `id_solicitud` INT PRIMARY KEY AUTO_INCREMENT,
  `codigo` VARCHAR(50) NOT NULL UNIQUE,
  `id_usuario` INT,
  `id_servicio` INT,
  `tipo` VARCHAR(100) NOT NULL,
  `descripcion` TEXT,
  `solicitante` VARCHAR(100),
  `prioridad` ENUM('Alta', 'Media', 'Baja') DEFAULT 'Media',
  `estado` VARCHAR(30) DEFAULT 'Registrada',
  `respuesta` TEXT,
  `fecha_solicitud` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `fecha_resolucion` DATETIME,
  
  FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id_usuario`),
  FOREIGN KEY (`id_servicio`) REFERENCES `servicios`(`id_servicio`),
  INDEX `idx_estado` (`estado`),
  INDEX `idx_fecha` (`fecha_solicitud`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- TABLA: HISTORIAL_SOLICITUDES
-- ==========================================
CREATE TABLE `historial_solicitudes` (
  `id_historial` INT PRIMARY KEY AUTO_INCREMENT,
  `id_solicitud` INT NOT NULL,
  `estado_anterior` VARCHAR(30),
  `estado_nuevo` VARCHAR(30),
  `detalle` TEXT,
  `fecha_cambio` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `realizado_por` INT,
  
  FOREIGN KEY (`id_solicitud`) REFERENCES `solicitudes`(`id_solicitud`),
  FOREIGN KEY (`realizado_por`) REFERENCES `usuarios`(`id_usuario`),
  INDEX `idx_solicitud` (`id_solicitud`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- TABLA: RECURSOS
-- ==========================================
CREATE TABLE `recursos` (
  `id_recurso` INT PRIMARY KEY AUTO_INCREMENT,
  `codigo` VARCHAR(50) NOT NULL UNIQUE,
  `nombre_recurso` VARCHAR(100) NOT NULL,
  `tipo_recurso` ENUM('Salas', 'Laboratorios', 'Auditorios', 'Equipos'),
  `descripcion` VARCHAR(255),
  `ubicacion` VARCHAR(100),
  `capacidad` INT,
  `estado` ENUM('Activo', 'En mantenimiento', 'Inactivo') DEFAULT 'Activo',
  `disponibilidad` ENUM('Disponible', 'En uso', 'No disponible') DEFAULT 'Disponible',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  INDEX `idx_tipo` (`tipo_recurso`),
  INDEX `idx_disponibilidad` (`disponibilidad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- TABLA: RESERVAS
-- ==========================================
CREATE TABLE `reservas` (
  `id_reserva` INT PRIMARY KEY AUTO_INCREMENT,
  `id_usuario` INT NOT NULL,
  `id_recurso` INT NOT NULL,
  `fecha_reserva` DATE NOT NULL,
  `hora_inicio` TIME NOT NULL,
  `hora_fin` TIME NOT NULL,
  `motivo` VARCHAR(255),
  `estado` ENUM('Confirmada', 'Pendiente', 'Cancelada') DEFAULT 'Pendiente',
  `fecha_creacion` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `fecha_cancelacion` DATETIME,
  
  FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id_usuario`),
  FOREIGN KEY (`id_recurso`) REFERENCES `recursos`(`id_recurso`),
  INDEX `idx_usuario` (`id_usuario`),
  INDEX `idx_recurso` (`id_recurso`),
  INDEX `idx_fecha` (`fecha_reserva`),
  INDEX `idx_estado` (`estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- TABLA: EVENTOS_Y_ACTIVIDADES
-- ==========================================
CREATE TABLE `eventos_y_actividades` (
  `id_evento` INT PRIMARY KEY AUTO_INCREMENT,
  `id_usuario` INT NOT NULL,
  `nombre_evento` VARCHAR(100) NOT NULL,
  `descripcion` TEXT,
  `categoria` ENUM('Académico', 'Cultural', 'Formación', 'Institucional'),
  `modalidad` ENUM('Presencial', 'Virtual', 'Híbrido') DEFAULT 'Presencial',
  `fecha` DATE NOT NULL,
  `hora_inicio` TIME NOT NULL,
  `hora_fin` TIME NOT NULL,
  `ubicacion` VARCHAR(100),
  `cupo` INT,
  `inscritos` INT DEFAULT 0,
  `ponente` VARCHAR(100),
  `tipo_evento` VARCHAR(50),
  `estado` ENUM('Activo', 'Finalizado', 'Cancelado') DEFAULT 'Activo',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id_usuario`),
  INDEX `idx_fecha` (`fecha`),
  INDEX `idx_estado` (`estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- TABLA: INSCRIPCIONES_EVENTOS
-- ==========================================
CREATE TABLE `inscripciones_eventos` (
  `id_inscripcion` INT PRIMARY KEY AUTO_INCREMENT,
  `id_evento` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  `fecha_inscripcion` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `estado` ENUM('Activa', 'Cancelada') DEFAULT 'Activa',
  
  FOREIGN KEY (`id_evento`) REFERENCES `eventos_y_actividades`(`id_evento`),
  FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id_usuario`),
  UNIQUE KEY `unique_inscripcion` (`id_evento`, `id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- TABLA: NOTIFICACIONES
-- ==========================================
CREATE TABLE `notificaciones` (
  `id_notificacion` INT PRIMARY KEY AUTO_INCREMENT,
  `id_usuario` INT NOT NULL,
  `titulo` VARCHAR(100),
  `mensaje` TEXT NOT NULL,
  `tipo_notificacion` ENUM('Solicitud', 'Reserva', 'Evento', 'PQRS', 'Sistema'),
  `icono` VARCHAR(50),
  `leida` BOOLEAN DEFAULT FALSE,
  `fecha_envio` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `referencia_id` INT,
  `referencia_tipo` VARCHAR(50),
  
  FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id_usuario`),
  INDEX `idx_usuario` (`id_usuario`),
  INDEX `idx_leida` (`leida`),
  INDEX `idx_fecha` (`fecha_envio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- TABLA: PQRS
-- ==========================================
CREATE TABLE `pqrs` (
  `id_pqrs` VARCHAR(20) PRIMARY KEY,
  `id_usuario` INT,
  `tipo` ENUM('Petición', 'Queja', 'Reclamo', 'Sugerencia'),
  `descripcion` TEXT NOT NULL,
  `respuesta` TEXT,
  `estado` ENUM('En revisión', 'Resuelta', 'Cerrada', 'Asignada') DEFAULT 'En revisión',
  `fecha` DATE DEFAULT CURRENT_DATE,
  `fecha_resolucion` DATETIME,
  `asignado_a` INT,
  
  FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id_usuario`),
  FOREIGN KEY (`asignado_a`) REFERENCES `usuarios`(`id_usuario`),
  INDEX `idx_estado` (`estado`),
  INDEX `idx_fecha` (`fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- TABLA: INFO_ACADEMICA
-- ==========================================
CREATE TABLE `info_academica` (
  `id_publicacion` INT PRIMARY KEY AUTO_INCREMENT,
  `id_usuario` INT NOT NULL,
  `titulo` VARCHAR(150) NOT NULL,
  `categoria` VARCHAR(50),
  `contenido` TEXT NOT NULL,
  `autor` VARCHAR(100),
  `fecha` DATE DEFAULT CURRENT_DATE,
  `estado` VARCHAR(20) DEFAULT 'Activo',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id_usuario`),
  INDEX `idx_categoria` (`categoria`),
  INDEX `idx_fecha` (`fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- TABLA: CONFIGURACION
-- ==========================================
CREATE TABLE `configuracion` (
  `id_config` INT PRIMARY KEY AUTO_INCREMENT,
  `id_usuario` INT NOT NULL,
  `seccion` VARCHAR(50),
  `clave` VARCHAR(100),
  `valor` LONGTEXT,
  `fecha_actualizacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id_usuario`),
  INDEX `idx_usuario_seccion` (`id_usuario`, `seccion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 5. 📋 RESUMEN DE ENTIDADES PRINCIPALES

### **USUARIOS**
| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|---|
| id_usuario | INT | PK, AUTO | Identificador único |
| identificacion | VARCHAR(20) | UNIQUE, NOT NULL | Cédula o ID |
| usuario | VARCHAR(50) | UNIQUE, NOT NULL | Usuario login |
| contraseña | VARCHAR(255) | NOT NULL | Hash de contraseña |
| nombre | VARCHAR(50) | NOT NULL | Nombre del usuario |
| apellido | VARCHAR(50) | NOT NULL | Apellido |
| correo | VARCHAR(100) | UNIQUE, NOT NULL | Email |
| id_rol | INT | FK → roles | Rol asignado |
| programa | VARCHAR(100) | | Programa/Departamento |
| cargo | VARCHAR(100) | | Posición |
| campus | VARCHAR(100) | | Campus |
| estado | VARCHAR(20) | | Activo/Inactivo |

### **SOLICITUDES**
| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|---|
| id_solicitud | INT | PK, AUTO | Identificador |
| codigo | VARCHAR(50) | UNIQUE | Código SOL-YYYY-XXX |
| id_usuario | INT | FK → usuarios | Usuario solicitante |
| id_servicio | INT | FK → servicios | Servicio relacionado |
| tipo | VARCHAR(100) | NOT NULL | Tipo solicitud |
| descripcion | TEXT | | Detalles |
| estado | VARCHAR(30) | | Registrada/En proceso/Resuelta |
| prioridad | ENUM | | Alta/Media/Baja |
| fecha_solicitud | DATETIME | DEFAULT NOW | Fecha creación |
| fecha_resolucion | DATETIME | | Fecha resolución |

### **RESERVAS**
| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|---|
| id_reserva | INT | PK, AUTO | Identificador |
| id_usuario | INT | FK → usuarios | Usuario |
| id_recurso | INT | FK → recursos | Recurso reservado |
| fecha_reserva | DATE | NOT NULL | Fecha de uso |
| hora_inicio | TIME | NOT NULL | Hora inicio |
| hora_fin | TIME | NOT NULL | Hora fin |
| motivo | VARCHAR(255) | | Razón de reserva |
| estado | ENUM | | Confirmada/Pendiente/Cancelada |
| fecha_creacion | DATETIME | DEFAULT NOW | Fecha registro |

### **RECURSOS**
| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|---|
| id_recurso | INT | PK, AUTO | Identificador |
| codigo | VARCHAR(50) | UNIQUE | Código REC-XXX |
| nombre_recurso | VARCHAR(100) | NOT NULL | Nombre |
| tipo_recurso | ENUM | | Salas/Labs/Auditorios/Equipos |
| ubicacion | VARCHAR(100) | | Bloque y piso |
| capacidad | INT | | Máximo de personas |
| estado | ENUM | | Activo/Mantenimiento/Inactivo |
| disponibilidad | ENUM | | Disponible/En uso |

### **EVENTOS_Y_ACTIVIDADES**
| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|---|
| id_evento | INT | PK, AUTO | Identificador |
| id_usuario | INT | FK → usuarios | Organizador |
| nombre_evento | VARCHAR(100) | NOT NULL | Nombre |
| categoria | ENUM | | Académico/Cultural/Formación |
| modalidad | ENUM | | Presencial/Virtual/Híbrido |
| fecha | DATE | NOT NULL | Fecha evento |
| hora_inicio | TIME | NOT NULL | Hora inicio |
| hora_fin | TIME | NOT NULL | Hora fin |
| ubicacion | VARCHAR(100) | | Lugar |
| cupo | INT | | Capacidad máxima |
| inscritos | INT | DEFAULT 0 | Inscritos actuales |
| estado | ENUM | | Activo/Finalizado/Cancelado |

### **NOTIFICACIONES**
| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|---|
| id_notificacion | INT | PK, AUTO | Identificador |
| id_usuario | INT | FK → usuarios | Usuario receptor |
| titulo | VARCHAR(100) | | Título notif |
| mensaje | TEXT | NOT NULL | Mensaje |
| tipo_notificacion | ENUM | | Solicitud/Reserva/Evento/PQRS |
| leida | BOOLEAN | DEFAULT FALSE | Estado lectura |
| fecha_envio | DATETIME | DEFAULT NOW | Fecha envío |
| referencia_id | INT | | ID del objeto relacionado |
| referencia_tipo | VARCHAR(50) | | Tipo objeto (solicitud, evento, etc) |

### **PQRS**
| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|---|
| id_pqrs | VARCHAR(20) | PK | Código PQRS-YYYY-XXX |
| id_usuario | INT | FK → usuarios | Usuario |
| tipo | ENUM | | Petición/Queja/Reclamo/Sugerencia |
| descripcion | TEXT | NOT NULL | Detalle |
| respuesta | TEXT | | Respuesta/Resolución |
| estado | ENUM | | En revisión/Resuelta/Cerrada |
| asignado_a | INT | FK → usuarios | Responsable |
| fecha | DATE | DEFAULT TODAY | Fecha creación |
| fecha_resolucion | DATETIME | | Fecha resolución |

### **INFO_ACADEMICA**
| Campo | Tipo | Restricción | Descripción |
|-------|------|-------------|---|
| id_publicacion | INT | PK, AUTO | Identificador |
| id_usuario | INT | FK → usuarios | Docente/Admin |
| titulo | VARCHAR(150) | NOT NULL | Título |
| categoria | VARCHAR(50) | | Convocatoria/Taller/Resultado |
| contenido | TEXT | NOT NULL | Contenido |
| autor | VARCHAR(100) | | Nombre autor |
| fecha | DATE | | Fecha publicación |
| estado | VARCHAR(20) | | Activo/Inactivo |

---

## 6. 🔐 ENUMERACIONES PRINCIPALES

```sql
-- TIPOS_USUARIO
'Administrador', 'Docente', 'Estudiante', 'Administrativo'

-- ESTADO_USUARIO
'Activo', 'Inactivo', 'Bloqueado'

-- ESTADO_SOLICITUD
'Registrada', 'En revisión', 'Asignada', 'En proceso', 'Resuelta', 'Cerrada'

-- PRIORIDAD_SOLICITUD
'Alta', 'Media', 'Baja'

-- TIPO_RECURSO
'Salas', 'Laboratorios', 'Auditorios', 'Equipos'

-- ESTADO_RECURSO
'Activo', 'En mantenimiento', 'Inactivo'

-- DISPONIBILIDAD_RECURSO
'Disponible', 'En uso', 'No disponible'

-- ESTADO_RESERVA
'Confirmada', 'Pendiente', 'Cancelada'

-- CATEGORIA_EVENTO
'Académico', 'Cultural', 'Formación', 'Institucional'

-- MODALIDAD_EVENTO
'Presencial', 'Virtual', 'Híbrido'

-- ESTADO_EVENTO
'Activo', 'Finalizado', 'Cancelado'

-- TIPO_NOTIFICACION
'Solicitud', 'Reserva', 'Evento', 'PQRS', 'Sistema'

-- TIPO_PQRS
'Petición', 'Queja', 'Reclamo', 'Sugerencia'

-- ESTADO_PQRS
'En revisión', 'Resuelta', 'Cerrada', 'Asignada'
```

---

## 7. 📊 RELACIONES Y CONSTRAINTS

### Relaciones One-to-Many (1:N)

```
ROLES (1) ──→ (N) USUARIOS
USUARIOS (1) ──→ (N) SOLICITUDES
USUARIOS (1) ──→ (N) RESERVAS
USUARIOS (1) ──→ (N) EVENTOS_Y_ACTIVIDADES
USUARIOS (1) ──→ (N) NOTIFICACIONES
USUARIOS (1) ──→ (N) INFO_ACADEMICA
USUARIOS (1) ──→ (N) PQRS (como creador)
USUARIOS (1) ──→ (N) PQRS (como asignado)
USUARIOS (1) ──→ (N) CONFIGURACION

SERVICIOS (1) ──→ (N) SOLICITUDES
RECURSOS (1) ──→ (N) RESERVAS
EVENTOS_Y_ACTIVIDADES (1) ──→ (N) INSCRIPCIONES_EVENTOS
USUARIOS (1) ──→ (N) INSCRIPCIONES_EVENTOS
SOLICITUDES (1) ──→ (N) HISTORIAL_SOLICITUDES
```

### Relaciones Many-to-Many (N:N)

```
USUARIOS (N) ──→ (N) EVENTOS_Y_ACTIVIDADES (through INSCRIPCIONES_EVENTOS)
```

---

## 8. 🎯 ÍNDICES RECOMENDADOS

```sql
-- Optimización de búsquedas y filtros
CREATE INDEX idx_usuario_solicitudes ON solicitudes(id_usuario, estado);
CREATE INDEX idx_recurso_reservas ON reservas(id_recurso, fecha_reserva);
CREATE INDEX idx_evento_categoria ON eventos_y_actividades(categoria, estado);
CREATE INDEX idx_notificaciones_usuario ON notificaciones(id_usuario, leida, fecha_envio);
CREATE INDEX idx_pqrs_estado ON pqrs(estado, fecha);
CREATE INDEX idx_info_academica_fecha ON info_academica(fecha, categoria);

-- Búsquedas de texto
ALTER TABLE solicitudes ADD FULLTEXT idx_busqueda_solicitudes (descripcion, tipo);
ALTER TABLE eventos_y_actividades ADD FULLTEXT idx_busqueda_eventos (nombre_evento, descripcion);
ALTER TABLE pqrs ADD FULLTEXT idx_busqueda_pqrs (descripcion);
```

---

## 9. 🔗 NOTAS IMPORTANTES

### Campos Obligatorios Recomendados
- `fecha_creacion`: Auditoria
- `id_usuario` en solicitudes/reservas/eventos: Trazabilidad
- `estado`: Control de flujo
- `id_rol`: Autorización en usuarios

### Consideraciones de Seguridad
- Implementar bcrypt/Argon2 para contraseñas (NO texto plano)
- Auditar cambios de estado (historial_solicitudes)
- Controlar permisos por rol
- Cifrar datos sensibles en configuracion

### Mejoras Futuras
- Agregar tabla de `integraciones` para APIs externas
- Tabla de `auditoría` para todas las operaciones críticas
- Tabla de `horarios_bloqueados` para recursos
- Tabla de `archivos_adjuntos` para solicitudes/PQRS
- Implementar soft deletes con `fecha_eliminacion`

---

## 10. 🚀 RESUMEN DE ESTADÍSTICAS

| Métrica | Cantidad |
|---------|----------|
| Módulos principales | 18 |
| Tablas en BD | 14 |
| Roles de usuario | 4 |
| Servicios principales | 6 |
| Estados de solicitud | 6 |
| Tipos de PQRS | 4 |
| Tipos de recurso | 4 |
| Categorías evento | 4 |

---

**Generado por:** Análisis de Frontend React  
**Fecha:** 2026-09-01  
**Versión:** 1.0
