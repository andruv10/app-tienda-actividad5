// =============================================================================
// ARCHIVO: config/db.js
// =============================================================================
//
// ANALOGÍA: Este archivo es como el "cable de red" entre el servidor y MySQL.
// Sin este cable, el backend no puede hablar con la base de datos.
//
// ¿Qué hace?
// - Lee la contraseña y datos de conexión desde el archivo .env
// - Crea un "pool" (grupo) de conexiones reutilizables a MySQL
// - Exporta ese pool para que otros archivos lo usen
//
// =============================================================================

// mysql2/promise permite usar async/await con MySQL (código más fácil de leer)
const mysql = require('mysql2/promise');

// dotenv carga las variables del archivo .env (DB_PASSWORD, DB_HOST, etc.)
require('dotenv').config();

// Pool = varias conexiones listas para usar (más eficiente que abrir/cerrar cada vez)
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',       // Dónde está MySQL (tu PC)
  user: process.env.DB_USER || 'root',            // Usuario de MySQL
  password: process.env.DB_PASSWORD || '',        // Contraseña (viene del .env)
  database: process.env.DB_NAME || 'ecommerceflutter', // Nombre de la BD
  waitForConnections: true,  // Si no hay conexión libre, espera en lugar de fallar
  connectionLimit: 10,         // Máximo 10 conexiones simultáneas
});

// Exportamos el pool para usarlo en controllers: const pool = require('../config/db')
module.exports = pool;

// =============================================================================
// GLOSARIO
// - pool: grupo de conexiones a la base de datos
// - process.env: variables de entorno leídas desde .env
// - module.exports: hace que este archivo se pueda importar en otros
// =============================================================================
