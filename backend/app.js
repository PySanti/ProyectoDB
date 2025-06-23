const express = require('express');
const cors = require('cors');
const path = require('path');
const app = express();
const userRoutes = require('./routes/userRoutes.js');
const roleRoutes = require('./routes/roleRoutes.js');
const cartRoutes = require('./routes/cartRoutes.js');
const productRoutes = require('./routes/productRoutes.js');

// Middleware para Favicon
app.get('/favicon.ico', (req, res) => res.status(204).send());

// Middlewares
app.use(cors());
app.use(express.json());

// Asignar rutas
app.use('/api/user', userRoutes);
app.use('/api/roles', roleRoutes);
app.use('/api/carrito', cartRoutes);
app.use('/api/productos', productRoutes);

// Iniciar servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor en http://localhost:${PORT}`);
});
