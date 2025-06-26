const express = require('express');
const cors = require('cors');
const path = require('path');
const app = express();
const userRoutes = require('./routes/userRoutes.js');
const roleRoutes = require('./routes/roleRoutes.js');
const cartRoutes = require('./routes/cartRoutes.js');
const productRoutes = require('./routes/productRoutes.js');
const ordenesRoutes = require('./routes/ordenesRoutes.js');
const puntosRoutes = require('./routes/puntosRoutes.js');

// Middleware para Favicon
app.get('/favicon.ico', (req, res) => res.status(204).send());

// Middlewares
app.use(cors());
app.use(express.json());

// Asignar rutas
app.use('/api/carrito', cartRoutes);
app.use('/api/productos', productRoutes);
app.use('/api/users', userRoutes);
app.use('/roles', roleRoutes);
app.use('/ordenes', ordenesRoutes);
app.use('/api/puntos', puntosRoutes);

// Iniciar servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor en http://localhost:${PORT}`);
});
