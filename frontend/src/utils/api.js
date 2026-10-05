// ============================================================
// Cliente HTTP del API Gateway (http://localhost:3000/api)
// Todos los microservicios responden con { data } en exito y
// { error } en fallo, salvo search-service que usa { success }.
// ============================================================

const API = (import.meta.env.VITE_API_URL || "/api").replace(/\/$/, "");

export const API_HABILITADA = Boolean(API);

const TIMEOUT_MS = 15000;
const CLAVE_SESION = "uajs_session";

export function getToken() {
    try {
        const sesion = JSON.parse(localStorage.getItem(CLAVE_SESION) || "null");
        return sesion?.token || null;
    } catch {
        return null;
    }
}

/** Error de API con el status HTTP para que la UI pueda reacting (401 → logout). */
export class ApiError extends Error {
    constructor(mensaje, status) {
        super(mensaje);
        this.name = "ApiError";
        this.status = status;
    }
}

export async function apiFetch(path, { method = "GET", body, params } = {}) {
    if (!API) {
        throw new ApiError(
            "VITE_API_URL no está configurado. No se puede llamar al backend.",
            0
        );
    }

    const query = params
        ? `?${new URLSearchParams(
              Object.entries(params).filter(([, v]) => v !== undefined && v !== null && v !== "")
          )}`
        : "";

    const headers = { "Content-Type": "application/json" };
    const token = getToken();
    if (token) {
        headers.Authorization = `Bearer ${token}`;
    }

    const controller = new AbortController();
    const temporizador = setTimeout(() => controller.abort(), TIMEOUT_MS);

    let res;
    try {
        res = await fetch(`${API}${path}${query}`, {
            method,
            headers,
            signal: controller.signal,
            body: body ? JSON.stringify(body) : undefined
        });
    } catch (error) {
        if (error.name === "AbortError") {
            throw new ApiError("El servidor tardó demasiado en responder.", 0);
        }
        throw new ApiError(
            "No hay conexión con el servidor. Verifica que el gateway esté levantado.",
            0
        );
    } finally {
        clearTimeout(temporizador);
    }

    if (res.status === 204) {
        return null;
    }

    const json = await res.json().catch(() => ({}));

    if (!res.ok) {
        // El gateway devuelve 401 cuando el token falta o expiró: se avisa a
        // AuthContext para que cierre la sesión en lugar de dejar la UI con
        // datos viejos y errores por todos lados.
        if (res.status === 401 && typeof window !== "undefined") {
            window.dispatchEvent(
                new CustomEvent("uajs:sesion-expirada", { detail: { url: path } })
            );
        }
        throw new ApiError(json.error || `Error ${res.status}`, res.status);
    }

    return json.data !== undefined ? json.data : json;
}

// ==========================================
// AUTH
// ==========================================
export const authApi = {
    login: (identificacion, password) =>
        apiFetch("/auth/login", { method: "POST", body: { identificacion, password } }),
    register: (payload) => apiFetch("/auth/register", { method: "POST", body: payload }),
    me: () => apiFetch("/auth/me")
};

// ==========================================
// USERS
// ==========================================
export const usersApi = {
    list: () => apiFetch("/users"),
    get: (id) => apiFetch(`/users/${id}`),
    create: (data) => apiFetch("/users", { method: "POST", body: data }),
    update: (id, data) => apiFetch(`/users/${id}`, { method: "PUT", body: data }),
    // Soft delete: el servicio marca estado = 'Inactivo'
    deactivate: (id) => apiFetch(`/users/${id}`, { method: "DELETE" }),
    remove: (id) => apiFetch(`/users/${id}`, { method: "DELETE" })
};

// ==========================================
// REQUESTS (SOLICITUDES)
// ==========================================
export const requestsApi = {
    list: () => apiFetch("/requests"),
    get: (id) => apiFetch(`/requests/${id}`),
    create: (data) => apiFetch("/requests", { method: "POST", body: data }),
    update: (id, data) => apiFetch(`/requests/${id}`, { method: "PUT", body: data }),
    advance: (id, data) =>
        apiFetch(`/requests/${id}/avance`, { method: "POST", body: data }),
    addNote: (id, data) =>
        apiFetch(`/requests/${id}/notas`, { method: "POST", body: data }),
    remove: (id) => apiFetch(`/requests/${id}`, { method: "DELETE" })
};

// ==========================================
// EVENTS (EVENTOS)
// ==========================================
export const eventsApi = {
    list: () => apiFetch("/events"),
    get: (id) => apiFetch(`/events/${id}`),
    create: (data) => apiFetch("/events", { method: "POST", body: data }),
    update: (id, data) => apiFetch(`/events/${id}`, { method: "PUT", body: data }),
    remove: (id) => apiFetch(`/events/${id}`, { method: "DELETE" }),
    inscripciones: (id) => apiFetch(`/events/${id}/inscripciones`),
    register: (id, idUsuario) =>
        apiFetch(`/events/${id}/inscripciones`, {
            method: "POST",
            body: { id_usuario: idUsuario }
        }),
    unregister: (id, idUsuario) =>
        apiFetch(`/events/${id}/inscripciones/${idUsuario}`, { method: "DELETE" })
};

// ==========================================
// NOTIFICATIONS (NOTIFICACIONES)
// ==========================================
export const notificationsApi = {
    list: (idUsuario) => apiFetch("/notifications", { params: { id_usuario: idUsuario } }),
    get: (id) => apiFetch(`/notifications/${id}`),
    create: (data) => apiFetch("/notifications", { method: "POST", body: data }),
    update: (id, data) => apiFetch(`/notifications/${id}`, { method: "PUT", body: data }),
    remove: (id) => apiFetch(`/notifications/${id}`, { method: "DELETE" }),
    markRead: (id, idUsuario) =>
        apiFetch(`/notifications/${id}`, {
            method: "PUT",
            body: { id_usuario: idUsuario, leida: 1 }
        }),
    markAllRead: async (idUsuario) => {
        const lista = await apiFetch("/notifications", {
            params: { id_usuario: idUsuario }
        });
        return Promise.all(
            lista
                .filter((n) => !Number(n.leida))
                .map((n) =>
                    apiFetch(`/notifications/${n.id_notificacion}`, {
                        method: "PUT",
                        body: { ...n, leida: 1 }
                    })
                )
        );
    }
};

// ==========================================
// FEEDBACK (PQRS)
// ==========================================
export const feedbackApi = {
    list: () => apiFetch("/feedback"),
    get: (id) => apiFetch(`/feedback/${id}`),
    create: (data) => apiFetch("/feedback", { method: "POST", body: data }),
    update: (id, data) => apiFetch(`/feedback/${id}`, { method: "PUT", body: data }),
    remove: (id) => apiFetch(`/feedback/${id}`, { method: "DELETE" })
};

// ==========================================
// RESOURCES (RECURSOS)
// ==========================================
export const resourcesApi = {
    list: () => apiFetch("/resources"),
    get: (id) => apiFetch(`/resources/${id}`),
    create: (data) => apiFetch("/resources", { method: "POST", body: data }),
    update: (id, data) => apiFetch(`/resources/${id}`, { method: "PUT", body: data }),
    remove: (id) => apiFetch(`/resources/${id}`, { method: "DELETE" })
};

// ==========================================
// RESERVATIONS (RESERVAS)
// ==========================================
export const reservationsApi = {
    list: () => apiFetch("/reservations"),
    get: (id) => apiFetch(`/reservations/${id}`),
    create: (data) => apiFetch("/reservations", { method: "POST", body: data }),
    update: (id, data) => apiFetch(`/reservations/${id}`, { method: "PUT", body: data }),
    remove: (id) => apiFetch(`/reservations/${id}`, { method: "DELETE" })
};

// ==========================================
// CONFIGURATION (CONFIGURACIÓN)
// ==========================================
export const configurationApi = {
    list: (idUsuario) =>
        apiFetch("/configuration", { params: { id_usuario: idUsuario } }),
    get: (id) => apiFetch(`/configuration/${id}`),
    getByUserAndSection: (idUsuario, seccion) =>
        apiFetch(`/configuration/usuario/${idUsuario}/seccion/${seccion}`),
    create: (data) => apiFetch("/configuration", { method: "POST", body: data }),
    update: (id, data) => apiFetch(`/configuration/${id}`, { method: "PUT", body: data }),
    remove: (id) => apiFetch(`/configuration/${id}`, { method: "DELETE" })
};

// ==========================================
// ACADEMIC INFO (INFORMACIÓN ACADÉMICA)
// ==========================================
export const academicInfoApi = {
    list: () => apiFetch("/academic-info"),
    get: (id) => apiFetch(`/academic-info/${id}`),
    create: (data) => apiFetch("/academic-info", { method: "POST", body: data }),
    update: (id, data) => apiFetch(`/academic-info/${id}`, { method: "PUT", body: data }),
    remove: (id) => apiFetch(`/academic-info/${id}`, { method: "DELETE" })
};

// ==========================================
// SEARCH (Elasticsearch)
// A diferencia del resto, no envuelve en { data }.
// ==========================================
export const searchApi = {
    all: (q, tipo, size = 10) => apiFetch("/search", { params: { q, tipo, size } }),
    byIndex: (indice, q, size = 20) =>
        apiFetch(`/search/${indice}`, { params: { q, size } }),
    suggest: (q, size = 5) => apiFetch("/search/suggest", { params: { q, size } }),
    indices: () => apiFetch("/search/indices")
};