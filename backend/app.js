const express = require('express');
const app = express();
const PORT = 3000;

// Ruta de ejemplo
app.get('/', (req, res) => {
  console.log("Saludos desde la terminal")
  res.send('¡Hola Mundo con Express!');
});

// Iniciar el servidor
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
