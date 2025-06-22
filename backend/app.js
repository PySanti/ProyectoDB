const express = require('express');
const app = express();
const userRoutes = require('./routes/userRoutes.js');
const roleRoutes = require('./routes/roleRoutes.js');
const ordenesRoutes = require('./routes/ordenesRoutes.js');
const cors = require('cors');

// Configuración CORS para permitir peticiones desde archivos locales (file://)
app.use(cors({
  origin: function (origin, callback) {
    // Permitir peticiones desde archivos locales (sin origen o null)
    if (!origin || origin === 'null') {
      callback(null, true);
    } else {
      callback(null, true); // Puedes restringir aquí si lo deseas
    }
  },
  credentials: true, // Si usas cookies o autenticación
}));

// Middleware para parsear JSON
app.use(express.json());

// Asignar rutas
app.use('/user', userRoutes);
app.use('/roles', roleRoutes);
app.use('/ordenes', ordenesRoutes);

// Iniciar servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor en http://localhost:${PORT}`);
});
