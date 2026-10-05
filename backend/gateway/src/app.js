const express = require('express');
const cors = require('cors');
const { createProxyMiddleware } = require('http-proxy-middleware');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../../../.env') });

const routes = require('./config/routes');
const authMiddleware = require('./middlewares/auth');

const app = express();

app.use(cors());

app.get('/', (req, res) => {
	res.json({
		message: 'API Gateway funcionando correctamente'
	});
});

const proxyFor = (service, prefix) => createProxyMiddleware({
	target: routes[service],
	changeOrigin: true,
	pathRewrite: (path) => `${prefix}${path}`,
	// El token ya fue validado aquí; se reenvían sus claims para que cada
	// microservicio sepa quién es el usuario sin volver a verificar el JWT.
	on: {
		proxyReq: (proxyReq, req) => {
			const user = req.user;
			if (user) {
				proxyReq.setHeader('x-user-id', String(user.id));
				proxyReq.setHeader('x-user-rol', String(user.rol));
				proxyReq.setHeader('x-user-identificacion', user.identificacion || '');
			}
		}
	}
});

// Todo /api/* pasa por verificación de JWT salvo login y register.
app.use('/api', authMiddleware);

app.use('/api/auth', proxyFor('auth', '/api/auth'));
app.use('/api/users', proxyFor('users', '/api/users'));
app.use('/api/events', proxyFor('events', '/api/events'));
app.use('/api/reservations', proxyFor('reservations', '/api/reservations'));
app.use('/api/notifications', proxyFor('notifications', '/api/notifications'));
app.use('/api/requests', proxyFor('requests', '/api/requests'));
app.use('/api/resources', proxyFor('resources', '/api/resources'));
app.use('/api/feedback', proxyFor('feedback', '/api/feedback'));
app.use('/api/academic-info', proxyFor('academic-info', '/api/academic-info'));
app.use('/api/configuration', proxyFor('configuration', '/api/configuration'));
app.use('/api/search', proxyFor('search', '/api/search'));

module.exports = app;
