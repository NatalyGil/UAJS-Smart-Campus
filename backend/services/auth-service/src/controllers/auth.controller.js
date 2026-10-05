const pool = require('../config/database');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

const JWT_SECRET = process.env.JWT_SECRET;
const JWT_EXPIRES = process.env.JWT_EXPIRES || '24h';
const SALT_ROUNDS = 10;

if (!JWT_SECRET) {
    throw new Error(
        'JWT_SECRET no está definido. Defínelo en el .env antes de arrancar auth-service.'
    );
}

/**
 * Compara un password contra lo almacenado y, si la fila venía en texto
 * plano (seed antiguo), la migra a hash en el mismo login.
 *
 * @returns {Promise<boolean>} true si el password coincide.
 */
async function verificarPassword(usuario, password) {
    const almacenado = usuario.contraseña;

    const esHash = typeof almacenado === 'string' &&
        /^\$2[aby]\$\d{2}\$[./A-Za-z0-9]{53}$/.test(almacenado);

    if (esHash) {
        return bcrypt.compare(password, almacenado);
    }

    // Migración transparente: la fila es de la semilla en texto plano.
    if (almacenado !== password) return false;
    const hash = await bcrypt.hash(password, SALT_ROUNDS);
    await pool.query('UPDATE usuarios SET contraseña = ? WHERE id_usuario = ?', [hash, usuario.id_usuario]);
    return true;
}

async function login(req, res, next) {
    try {
        const { identificacion, password } = req.body;
        if (!identificacion || !password) {
            return res.status(400).json({ error: 'Identificación y contraseña son requeridos' });
        }

        const [rows] = await pool.query(
            'SELECT id_usuario, nombre, apellido, correo, id_rol, tipo_usuario, contraseña, estado FROM usuarios WHERE identificacion = ? AND estado = ?',
            [identificacion, 'Activo']
        );

        const user = rows[0];
        // Mismo mensaje para usuario inexistente y password incorrecto, para no
        // revelar qué identificaciones existen.
        const coincide = user ? await verificarPassword(user, password) : false;
        if (!coincide) {
            return res.status(401).json({ error: 'Credenciales inválidas' });
        }

        const token = jwt.sign(
            { id: user.id_usuario, identificacion, rol: user.id_rol },
            JWT_SECRET,
            { expiresIn: JWT_EXPIRES }
        );

        const { contraseña, ...userSafe } = user;
        userSafe.identificacion = identificacion;
        userSafe.rol = user.id_rol;
        userSafe.token = token;

        res.json({ data: userSafe });
    } catch (error) {
        next(error);
    }
}

async function register(req, res, next) {
    try {
        const { nombre, apellido, correo, usuario, password, telefono, id_rol, tipo_usuario } = req.body;
        if (!nombre || !apellido || !correo || !usuario || !password) {
            return res.status(400).json({ error: 'Faltan campos requeridos' });
        }

        const [existente] = await pool.query(
            'SELECT id_usuario FROM usuarios WHERE identificacion = ? OR correo = ?',
            [usuario, correo]
        );
        if (existente.length) {
            return res.status(409).json({ error: 'El usuario o el correo ya están registrados' });
        }

        const hash = await bcrypt.hash(password, SALT_ROUNDS);

        const [result] = await pool.query(
            'INSERT INTO usuarios (nombre, apellido, correo, identificacion, contraseña, telefono, id_rol, tipo_usuario, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [nombre, apellido, correo, usuario, hash, telefono || '', id_rol || 2, tipo_usuario || 'Estudiante', 'Activo']
        );

        const [newUser] = await pool.query('SELECT id_usuario, nombre, apellido, correo, identificacion, id_rol, tipo_usuario, estado FROM usuarios WHERE id_usuario = ?', [result.insertId]);
        res.status(201).json({ data: newUser[0] });
    } catch (error) {
        next(error);
    }
}

async function me(req, res, next) {
    try {
        const user = req.user;
        const [rows] = await pool.query(
            'SELECT id_usuario, nombre, apellido, correo, id_rol, tipo_usuario, estado FROM usuarios WHERE id_usuario = ?',
            [user.id]
        );
        if (!rows.length) {
            return res.status(404).json({ error: 'Usuario no encontrado' });
        }
        res.json({ data: rows[0] });
    } catch (error) {
        next(error);
    }
}

module.exports = { login, register, me };
