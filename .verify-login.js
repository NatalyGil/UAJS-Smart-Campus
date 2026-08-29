const http = require('http');

const HOST = '127.0.0.1';
const PORT = 3001;
const CREDENCIALES = { usuario: 'admin', password: 'admin123' };

function login(body) {
    return new Promise((resolve, reject) => {
        const postData = JSON.stringify(body);
        const options = {
            host: HOST,
            port: PORT,
            path: '/api/auth/login',
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': Buffer.byteLength(postData)
            }
        };

        const req = http.request(options, response => {
            let data = '';
            response.on('data', chunk => data += chunk);
            response.on('end', () => {
                try {
                    resolve({ status: response.statusCode, json: JSON.parse(data) });
                } catch (e) {
                    reject(e);
                }
            });
        });

        req.on('error', reject);
        req.write(postData);
        req.end();
    });
}

function me(token) {
    return new Promise((resolve, reject) => {
        const options = {
            host: HOST,
            port: PORT,
            path: '/api/auth/me',
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${token}`
            }
        };

        const req = http.request(options, response => {
            let data = '';
            response.on('data', chunk => data += chunk);
            response.on('end', () => {
                try {
                    resolve({ status: response.statusCode, json: JSON.parse(data) });
                } catch (e) {
                    reject(e);
                }
            });
        });

        req.on('error', reject);
        req.end();
    });
}

(async () => {
    try {
        // 1. Login
        const res = await login(CREDENCIALES);
        console.log(`LOGIN - HTTP ${res.status}`);

        if (res.status !== 200 || !res.json.data || !res.json.data.token) {
            console.log('LOGIN: FALLÓ - no se obtuvo token');
            process.exitCode = 1;
            return;
        }

        const data = res.json.data;
        console.log(`  usuario: ${data.usuario}`);
        console.log(`  nombre: ${data.nombre} ${data.apellido}`);
        console.log(`  rol: ${data.id_rol}`);
        console.log(`  token: ${data.token.substring(0, 30)}...`);

        // 2. Me (verify token)
        const resMe = await me(data.token);
        console.log(`ME - HTTP ${resMe.status}`);

        if (resMe.status !== 200 || !resMe.json.data) {
            console.log('ME: FALLÓ - token no válido');
            process.exitCode = 1;
            return;
        }

        console.log(`  id_usuario: ${resMe.json.data.id_usuario}`);
        console.log(`  nombre: ${resMe.json.data.nombre} ${resMe.json.data.apellido}`);
        console.log(`  correo: ${resMe.json.data.correo}`);

        console.log('LOGIN VERIFICADO OK');
        process.exitCode = 0;
    } catch (error) {
        console.error('Error:', error.message);
        process.exitCode = 1;
    }
})();
