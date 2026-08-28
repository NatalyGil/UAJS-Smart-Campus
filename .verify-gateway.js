const http = require('http');
const app = require('./backend/gateway/src/app');
const server = app.listen(0, () => {
  http.get({ host: '127.0.0.1', port: server.address().port, path: '/' }, response => {
    let body = '';
    response.on('data', chunk => body += chunk);
    response.on('end', () => {
      const data = JSON.parse(body);
      console.log(`HTTP ${response.statusCode}`);
      console.log(`Tablas: ${Object.keys(data.tablas).join(', ')}`);
      for (const [table, rows] of Object.entries(data.tablas)) console.log(`${table}: ${rows.length} registros`);
      server.close();
      process.exitCode = response.statusCode === 200 && Object.keys(data.tablas).length === 8 ? 0 : 1;
    });
  }).on('error', error => { console.error(error.message); server.close(); process.exitCode = 1; });
});
