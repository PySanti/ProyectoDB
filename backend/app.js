const express = require('express');
const app = express();
const userRoutes = require('./routes/userRoutes.js');

// Middleware para parsear JSON
app.use(express.json());

// Asignar rutas
app.use('/user', userRoutes);  // Las rutas empezarán con /users

// Iniciar servidor
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor en http://localhost:${PORT}`);
});
