// =============================================================================
// ARCHIVO: controllers/categoryController.js
// =============================================================================
//
// ANALOGÍA: Es el empleado del pasillo de "categorías" en el supermercado.
// Cuando alguien pregunta "¿qué tipos de productos hay?", él consulta la BD y responde.
//
// ¿Qué hace?
// - getCategories: devuelve todas las categorías (Electrónica, Ropa, Hogar, Deportes)
//
// =============================================================================

const pool = require('../config/db');

async function getCategories(req, res) {
  try {
    // Consulta SQL: traer todas las filas de la tabla categories, ordenadas por nombre
    const [categories] = await pool.query('SELECT * FROM categories ORDER BY name');

    // Enviar el resultado como JSON a la app Flutter
    res.json(categories);
  } catch (error) {
    console.error('Error en getCategories:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
}

module.exports = { getCategories };

// =============================================================================
// GLOSARIO
// - SELECT *: traer todas las columnas de la tabla
// - ORDER BY name: ordenar alfabéticamente por el campo name
// - res.json(): enviar respuesta en formato JSON
// =============================================================================
