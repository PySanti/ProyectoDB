const express = require('express');
const app = express();
const userRoutes = require('./routes/userRoutes.js');
const cors = require('cors');

// Habilitar CORS para todas las rutas
app.use(cors()); // ← Así de simple

// O con configuración personalizada (recomendado para producción)
app.use(cors({
  origin: 'file://', // Reemplaza con tu URL frontend
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Tus rutas
app.post('/user/login', (req, res) => {
  res.json({ message: "Login exitoso" });
});

app.listen(3000, () => console.log('Server running on port 3000'));

// Middleware para parsear JSON
app.use(express.json());

// Asignar rutas
app.use('/user', userRoutes);  // Las rutas empezarán con /users

// Iniciar servidor
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor en http://localhost:${PORT}`);
});
