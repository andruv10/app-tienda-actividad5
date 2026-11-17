// =============================================================================
// ARCHIVO: index.js (punto de entrada del servidor)
// =============================================================================
//
// ANALOGÍA: Este archivo es la "recepción" del restaurante.
// Abre el local, organiza las mesas (rutas) y atiende a los clientes (peticiones).
//
// ¿Qué hace?
// - Crea el servidor con Express
// - Configura CORS (para que Flutter pueda conectarse)
// - Conecta todas las rutas: auth, categorías, productos, carrito
// - Enciende el servidor en el puerto 3000
//
// =============================================================================

// Express = framework para crear el servidor web
const express = require('express');
// CORS = permite peticiones desde otro origen (Flutter en Chrome)
const cors = require('cors');
// Carga variables del archivo .env
require('dotenv').config();

// Importamos los archivos de rutas (cada uno maneja un grupo de URLs)
const authRoutes = require('./routes/authRoutes');
const categoryRoutes = require('./routes/categoryRoutes');
const productRoutes = require('./routes/productRoutes');
const cartRoutes = require('./routes/cartRoutes');

// Creamos la aplicación Express
const app = express();
// Puerto donde escuchará (3000 por defecto, o el del .env)
const PORT = process.env.PORT || 3000;

// Middleware global: permite peticiones desde Flutter
app.use(cors());
// Middleware global: permite leer JSON en el cuerpo de las peticiones (req.body)
app.use(express.json());

// Ruta de prueba: al abrir http://localhost:3000 en el navegador
app.get('/', (req, res) => {
  res.json({ message: 'API E-commerce funcionando' });
});

// Conectamos cada grupo de rutas con su prefijo URL
app.use('/api/auth', authRoutes);           // /api/auth/register, /api/auth/login
app.use('/api/categories', categoryRoutes); // /api/categories
app.use('/api/products', productRoutes);    // /api/products, /api/products/:id
app.use('/api/cart', cartRoutes);           // /api/cart (requiere token)

// Encendemos el servidor y mostramos mensaje en la terminal
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});

// =============================================================================
// GLOSARIO
// - Express: librería para crear servidores web en Node.js
// - app.use(): registra middleware o rutas
// - Puerto: número donde el servidor "escucha" (3000)
// - JSON: formato de datos que usan app y servidor
// =============================================================================
