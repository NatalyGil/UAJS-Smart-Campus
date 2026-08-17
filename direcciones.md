# Mapa del Proyecto - UAJS Smart Campus

```
UAJS-Smart-Campus/
│
├── backend/                          # API REST (Node.js + Express)
│   ├── src/
│   │   ├── config/                   # Configuraciones del servidor
│   │   │   ├── db.js                 # Conexión a base de datos
│   │   │   ├── jwt.js                # Configuración de JWT
│   │   │   └── env.js                # Variables de entorno
│   │   │
│   │   ├── controllers/              # Lógica de las peticiones
│   │   │   ├── auth.controller.js    # Autenticación (login/registro)
│   │   │   ├── usuario.controller.js # Gestión de usuarios
│   │   │   ├── reserva.controller.js # Gestión de reservas
│   │   │   └── evento.controller.js  # Gestión de eventos
│   │   │
│   │   ├── routes/                   # Definición de rutas/endpoints
│   │   │   ├── auth.routes.js
│   │   │   ├── usuario.routes.js
│   │   │   ├── reserva.routes.js
│   │   │   └── evento.routes.js
│   │   │
│   │   ├── services/                 # Lógica de negocio
│   │   ├── middlewares/              # Middlewares del servidor
│   │   │   ├── auth.js               # Verificación de token
│   │   │   ├── roles.js              # Control de roles
│   │   │   └── errorHandler.js       # Manejo de errores
│   │   │
│   │   ├── models/                   # Modelos/estructuras de datos
│   │   ├── repositories/             # Acceso a base de datos
│   │   ├── utils/                    # Utilidades y helpers
│   │   ├── app.js                    # Configuración de Express
│   │   └── server.js                 # Punto de entrada del servidor
│   │
│   ├── package.json                  # Dependencias del backend
│   ├── package-lock.json
│   └── .env                          # Variables de entorno (no commitear)
│
├── frontend/                         # Cliente (React + Vite)
│   ├── public/                       # Archivos estáticos públicos
│   ├── src/
│   │   ├── assets/                   # Recursos estáticos
│   │   │   ├── icons/                # Iconos
│   │   │   ├── images/               # Imágenes
│   │   │   ├── logo/                 # Logotipos
│   │   │   ├── hero.png              # Imagen principal
│   │   │   ├── react.svg             # Logo de React
│   │   │   └── vite.svg              # Logo de Vite
│   │   │
│   │   ├── components/               # Componentes reutilizables
│   │   │   ├── Button/
│   │   │   ├── Card/
│   │   │   ├── Input/
│   │   │   ├── Loader/
│   │   │   ├── Modal/
│   │   │   ├── Navbar/
│   │   │   │   └── Navbar.jsx        # Barra de navegación
│   │   │   ├── Sidebar/
│   │   │   └── Table/
│   │   │
│   │   ├── context/                  # Contextos globales de React
│   │   ├── hooks/                    # Custom hooks
│   │   ├── layouts/                  # Layouts de la aplicación
│   │   │   └── DashboardLayout.jsx   # Layout del dashboard
│   │   ├── pages/                    # Páginas / vistas
│   │   │   ├── Configuracion/
│   │   │   ├── Dashboard/
│   │   │   │   └── Dashboard.jsx     # Vista principal
│   │   │   ├── Eventos/
│   │   │   │   ├── Calendario/
│   │   │   │   ├── Inscripciones/
│   │   │   │   └── Publicaciones/
│   │   │   ├── Facultades/
│   │   │   ├── Login/
│   │   │   ├── Notificaciones/
│   │   │   │   ├── Correos/
│   │   │   │   ├── Push/
│   │   │   │   └── Alertas/
│   │   │   ├── Perfil/
│   │   │   │   ├── Datos personales/
│   │   │   │   ├── Seguridad/
│   │   │   │   └── Cambio de contraseña/
│   │   │   ├── Programas/
│   │   │   ├── Reservas/
│   │   │   │   ├── Salones/
│   │   │   │   ├── Laboratorios/
│   │   │   │   ├── Auditorios/
│   │   │   │   └── Equipos/
│   │   │   ├── Roles/
│   │   │   ├── Solicitudes/
│   │   │   │   └── Solicitudes.jsx   # Solicitudes de reservas
│   │   │   └── Usuarios/
│   │   │       ├── CRUD usuarios/
│   │   │       ├── Roles/
│   │   │       └── Permisos/
│   │   │
│   │   ├── routes/                   # Configuración de rutas del frontend
│   │   │   └── AppRoutes.jsx         # Definición de rutas de la app
│   │   ├── services/                 # Llamadas a la API del backend
│   │   ├── styles/                   # Estilos globales
│   │   ├── utils/                    # Utilidades y helpers
│   │   │
│   │   ├── App.jsx                   # Componente raíz
│   │   ├── App.css
│   │   ├── index.css
│   │   └── main.jsx                  # Punto de entrada de React
│   │
│   ├── index.html                    # HTML principal
│   ├── package.json                  # Dependencias del frontend
│   ├── package-lock.json
│   ├── vite.config.js                # Configuración de Vite
│   ├── eslint.config.js              # Configuración de ESLint
│   └── README.md
│
└── .gitignore                        # Archivos ignorados por Git
```

## Descripción General

| Carpeta | Proyecto | Tecnología | Descripción |
|---------|----------|------------|-------------|
| `backend/` | API REST | Node.js + Express | Maneja autenticación, usuarios, reservas y eventos |
| `frontend/` | Cliente Web | React + Vite | Interfaz de usuario para estudiantes, docentes y administradores |

## Módulos del Sistema

- **Usuarios**: CRUD de usuarios, roles y permisos.
- **Reservas**: Salones, laboratorios, auditorios y equipos.
- **Eventos**: Calendario, inscripciones y publicaciones.
- **Notificaciones**: Correos, push y alertas.
- **Perfil**: Datos personales, seguridad y cambio de contraseña.

## Estado Actual

- La estructura de carpetas del **backend** y el **frontend** ya está creada.
- El frontend fue generado con **Vite** (`npm create vite`).
- Archivos implementados:
  - `frontend/src/components/Navbar/Navbar.jsx`
  - `frontend/src/layouts/DashboardLayout.jsx`
  - `frontend/src/pages/Dashboard/Dashboard.jsx`
  - `frontend/src/pages/Solicitudes/Solicitudes.jsx`
  - `frontend/src/routes/AppRoutes.jsx`
- El resto de los archivos de los módulos aún están por implementar.
