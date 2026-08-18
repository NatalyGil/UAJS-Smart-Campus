# Documentación - UAJS Smart Campus

## 1. Descripción del Proyecto

Plataforma web distribuida para la gestión y articulación de servicios universitarios de la Universidad Antonio José de Sucre. Integra servicios académicos y administrativos en una interfaz unificada usando arquitectura MVC y posterior evolución a microservicios con API REST.

**Tecnologías**
- Frontend: HTML5, CSS3, JavaScript ES6+, React, React Router, Axios/Fetch
- Backend: Node.js, Express.js
- Base de datos: MySQL
- Comunicación: REST, HTTP/HTTPS, JSON
- Seguridad: JWT, roles, permisos, middleware de autenticación

---

## 2. Lo que se ha hecho (Estado actual)

### 2.1 Backend (`backend/`)

- Estructura de carpetas creada bajo patrón MVC:
  - `src/config/` (db.js, jwt.js, env.js)
  - `src/controllers/` (auth, usuario, reserva, evento)
  - `src/routes/` (auth, usuario, reserva, evento)
  - `src/services/`, `src/middlewares/` (auth, roles, errorHandler), `src/models/`, `src/repositories/`, `src/utils/`
  - `src/app.js`, `src/server.js`
- `package.json` y `server.js` existentes.
- **Nota:** las carpetas están creadas pero **sin implementación** (archivos de controladores/rutas vacíos).

### 2.2 Frontend (`frontend/`)

**Estructura general creada:**
- `src/assets/` (icons, images, logo, hero.png)
- `src/components/` (Button, Card, Input, Loader, Modal, Navbar, Sidebar, Table)
- `src/layouts/`, `src/context/`, `src/hooks/`, `src/routes/`, `src/services/`, `src/styles/`, `src/utils/`
- `src/pages/` con las páginas de cada módulo

**Implementado (funcional):**
- **Layout del dashboard** (`layouts/DashboardLayout.jsx` + CSS) con Sidebar y Navbar.
- **Sidebar** (`components/Sidebar/Sidebar.jsx`): renderiza el menú desde `utils/menu.js` (9 items) usando React Router (`NavLink`).
- **Navbar** (`components/Navbar/Navbar.jsx` + CSS): con botón de menú, campana de notificaciones y perfil de usuario.
- **Rutas** (`routes/AppRoutes.jsx`): 9 rutas con React Router (Dashboard, Solicitudes, Reservas, Recursos, Eventos, Notificaciones, PQRS, Perfil, Configuración).
- **Menú centralizado** (`utils/menu.js`): 9 items, fuente única de verdad del menú.
- **Sistema de estilos ITCSS** (`src/styles/`): `main.css` + abstracts, base, blocks, components, pages, utils (~40 archivos).
- **Barra lateral expandible** (ver sección 2.3): colapsa de 250px a 70px con el botón ☰ del Navbar.

### 2.3 Barra lateral expandible

La barra lateral se puede contraer/expandir haciendo clic en el botón ☰ del Navbar.

**Archivos involucrados:**

| Archivo | Rol |
|---------|-----|
| `layouts/DashboardLayout.jsx` | Gestiona el estado `collapsed` con `useState(false)`. Aplica la clase `app--collapsed` al contenedor y pasa `collapsed` al Sidebar y `onToggle` al Navbar |
| `components/Navbar/Navbar.jsx` | El botón ☰ recibe `onToggle` como prop y lo ejecuta al hacer clic |
| `components/Sidebar/Sidebar.jsx` | Recibe `collapsed` y aplica la clase `sidebar--collapsed` cuando es `true` |
| `components/Sidebar/Sidebar.css` | `sidebar`: 250px → 70px al colapsar, con `transition: width 0.3s ease`. En modo colapsado el título y los items se centran y el texto se recorta con `overflow: hidden` |
| `layouts/DashboardLayout.css` | `app__main`: margen izquierdo 250px → 70px, con `transition: margin-left 0.3s ease` |

**Flujo del estado:**
1. `DashboardLayout` declara `const [collapsed, setCollapsed] = useState(false)`.
2. El Navbar recibe `onToggle={() => setCollapsed(!collapsed)}`.
3. Al hacer clic en ☰, `setCollapsed` invierte el valor.
4. El Sidebar recibe `collapsed` y cambia su clase CSS → se encoge a 70px.
5. El contenedor `.app` cambia a `.app--collapsed` → el contenido principal corre el margen a 70px.

Este estado usa **useState**, lo cual aporta al **Criterio 2** de la rúbrica.

**Páginas creadas pero como placeholders (solo título y texto estático):**
- Dashboard, Solicitudes, Reservas, Recursos, Eventos, Notificaciones, PQRS, Perfil, Configuración

**Correcciones aplicadas recientemente:**
- `utils/menu.js` tenía 4 items vs. 9 links hardcodeados en Sidebar → se centralizó en `menu.js` y el Sidebar ahora mapea la lista.
- `Recursos.jsx` y `Notificaciones.jsx` mostraban título incorrecto "PQRS" → corregido.

**Pendiente en el frontend:**
- `components/` (Button, Card, Input, Loader, Modal, Table) están **vacíos**.
- `context/`, `hooks/`, `services/` están **vacíos** (no hay llamadas a API).
- Subcarpetas de módulos vacías (Calendario, Inscripciones, Publicaciones, Correos, Push, Alertas, Datos personales, Seguridad, Cambiodecontraseña, CRUDusuarios, Roles, Permisos, Salones, Laboratorios, Auditorios, Equipos, MisPQRS, NuevaPQRS, Login, Facultades, Programas).
- No existe login funcional ni protección de rutas por rol.

---

## 3. Lo que se tiene que hacer (Pendiente)

### 3.1 Vistas obligatorias de la Actividad Integrativa (Criterio 6 = 45%)

| # | Vista | Requisito |
|---|-------|-----------|
| 1 | **Landing de acceso** | Nombre de la plataforma, descripción de servicios y perfiles de usuario. Redirección automática a la página principal a los **5 segundos** si no hay acción |
| 2 | **Página principal (Dashboard)** | Servicios disponibles (Solicitudes, Reservas, Recursos, Eventos, Notificaciones, PQRS) + **barra de búsqueda** por nombre/categoría |
| 3 | **Vista de servicio** | Detalle de un servicio: descripción, recursos disponibles, opciones (ej. Reservas) |
| 4 | **Vista de solicitudes** | Listado con número de solicitud, tipo de servicio, fecha, estado y descripción. Consultar detalle y seguimiento |
| 5 | **Vista de detalle de solicitud** | Información completa + evolución del estado: Registrada → En revisión → Asignada → En proceso → Resuelta → Cerrada |
| 6 | **Vista de reservas** | Recursos disponibles (salas, laboratorios, equipos, espacios), seleccionar recurso, consultar disponibilidad y registrar reserva |
| 7 | **Vista de notificaciones** | Comunicaciones de la plataforma (cambios de estado, confirmaciones de reserva, nuevos eventos) |
| 8 | **Vista de eventos** | Nombre, fecha, hora, lugar y descripción de las actividades |
| 9 | **Vista de perfil** | Nombre, tipo de usuario, programa o dependencia y otros datos del prototipo |
| 10 | **Dashboard de indicadores** | Solicitudes pendientes, reservas realizadas, notificaciones no leídas, eventos próximos y servicios disponibles |

### 3.2 Criterios de la rúbrica

| Criterio | Requisito | Peso |
|----------|-----------|------|
| 1 | **≥ 10 componentes funcionales** con JSX | 5% |
| 2 | Uso de **useState y useEffect** | 5% |
| 3 | **Custom hook** utilizado en un componente | 10% |
| 4 | **React Router** (mínimo 4 rutas) — ya hay 9 ✓ | 10% |
| 5 | **CSS con metodología BEM** | 10% |
| 6 | **Vistas funcionales** (sección 3.1) | 45% |
| 7 | **Videomemoria** (10 min, MP4) explicando componentes, hooks, vistas y despliegue | 10% |
| 8 | **Despliegue en Vercel** | 5% |

**Estado de la rúbrica:**
- ✅ Criterio 4 (React Router): cumplido (9 rutas).
- ✅ Criterio 5 parcial: CSS aplicado, falta verificar BEM completo en todos los componentes.
- ❌ Criterio 1: solo ~4 componentes funcionales (Sidebar, Navbar, DashboardLayout, AppRoutes + 9 páginas) — faltan más.
- ⚠️ Criterio 2 parcial: **useState** ya se usa en `DashboardLayout.jsx` (barra lateral expandible). Falta usar **useEffect** en algún componente.
- ❌ Criterio 3: no hay custom hooks.
- ❌ Criterio 6: faltan todas las vistas funcionales.
- ❌ Criterios 7 y 8: pendientes.

### 3.3 Backend pendiente

- Implementar los archivos de config, controllers, routes, services, middlewares, models y repositories.
- Crear conexión a **MySQL**.
- Implementar **API REST** con JWT, roles y permisos.
- Arquitectura orientada a **microservicios** (mínimo 6):
  1. Microservicio de Usuarios (usuarios, roles, autenticación)
  2. Microservicio de Solicitudes
  3. Microservicio de Reservas
  4. Microservicio de Recursos
  5. Microservicio de Eventos
  6. Microservicio de Notificaciones
- Base de datos con: Usuarios, Roles, Servicios, Solicitudes, Reservas, Recursos, Eventos, Notificaciones.
- Comunicación: Frontend React → API Gateway → Microservicios → Base de datos.

### 3.4 Entrega final (archivo ZIP)

1. Videomemoria en **MP4** (máximo 10 minutos).
2. Archivo **TXT** con la URL del proyecto desplegado en Vercel.
3. Código de la aplicación **sin node_modules**.

---

## 4. Resumen ejecutivo

| Área | Estado |
|------|--------|
| Estructura frontend/backend | ✅ Completa |
| Layout + navegación | ✅ Funcional |
| Estilos ITCSS + BEM | ✅ Base creada |
| Rutas React Router | ✅ 9 rutas |
| Páginas con contenido real | ❌ Solo placeholders |
| Backend funcional | ❌ Solo estructura |
| Base de datos | ❌ No creada |
| Autenticación/roles | ❌ No implementada |
| Landing + buscador + indicadores | ❌ No implementados |
| Hooks (useState/useEffect/custom) | ❌ No usados |
| Despliegue Vercel + videomemoria | ❌ Pendiente |

**Prioridad de trabajo recomendada:**
1. Landing de acceso (vista 1) — 5% del frontend clave
2. Dashboard con servicios + barra de búsqueda (vista 2)
3. Vista de servicio (vista 3)
4. Solicitudes + detalle con estados (vistas 4 y 5)
5. Reservas, Eventos, Notificaciones, Perfil (vistas 6-9)
6. Dashboard de indicadores (vista 10)
7. Usar useState/useEffect y crear custom hooks (criterios 2 y 3)
8. Completar ≥10 componentes funcionales (criterio 1)
9. Backend con MySQL, API REST y autenticación
10. Despliegue en Vercel y videomemoria