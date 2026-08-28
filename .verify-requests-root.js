const http = require('http');
const app = require('./backend/services/requests-service/src/app');
const server = app.listen(0, () => {
  http.get({ host: '127.0.0.1', port: server.address().port, path: '/' }, response => {
    let body = '';
    response.on('data', chunk => body += chunk);
    response.on('end', () => {
      const data = JSON.parse(body);
      console.log(`HTTP ${response.statusCode}`);
      console.log(`tabla: ${data.tabla}`);
      console.log(`registros: ${data.datos.length}`);
      console.log(JSON.stringify(data.datos, null, 2));
      server.close();
      process.exitCode = response.statusCode === 200 && data.datos.length === 3 ? 0 : 1;
    });
  }).on('error', error => { console.error(error.message); server.close(); process.exitCode = 1; });
});
