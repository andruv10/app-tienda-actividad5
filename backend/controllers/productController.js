// =============================================================================
// ARCHIVO: controllers/productController.js
// =============================================================================
//
// ANALOGÍA: Es el encargado del catálogo de productos.
// Puede mostrarte todos los productos, uno específico, o solo los de una categoría.
//
// ¿Qué hace?
// - getProducts: lista todos los productos con el nombre de su categoría
// - getProductById: muestra el detalle de un producto por su ID
// - getProductsByCategory: filtra productos por categoría
//
// =============================================================================

const pool = require('../config/db');

// ─── TODOS LOS PRODUCTOS ─────────────────────────────────────────────────────
async function getProducts(req, res) {
  try {
    // JOIN une la tabla products (p) con categories (c) para traer el nombre de categoría
    const [products] = await pool.query(`
      SELECT p.*, c.name AS category_name
      FROM products p
      JOIN categories c ON p.category_id = c.id
      ORDER BY p.name
    `);
    res.json(products);
  } catch (error) {
    console.error('Error en getProducts:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
}

// ─── UN PRODUCTO POR ID ──────────────────────────────────────────────────────
async function getProductById(req, res) {
  try {
    // req.params.id viene de la URL: /api/products/5 → id = 5
    const { id } = req.params;

    const [products] = await pool.query(`
      SELECT p.*, c.name AS category_name
      FROM products p
      JOIN categories c ON p.category_id = c.id
      WHERE p.id = ?
    `, [id]); // El ? evita inyección SQL (seguridad)

    if (products.length === 0) {
      return res.status(404).json({ message: 'Producto no encontrado' });
    }

    res.json(products[0]); // Devolvemos solo el primer (y único) resultado
  } catch (error) {
    console.error('Error en getProductById:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
}

// ─── PRODUCTOS POR CATEGORÍA ─────────────────────────────────────────────────
async function getProductsByCategory(req, res) {
  try {
    const { categoryId } = req.params; // Viene de /api/products/category/1

    const [products] = await pool.query(`
      SELECT p.*, c.name AS category_name
      FROM products p
      JOIN categories c ON p.category_id = c.id
      WHERE p.category_id = ?
      ORDER BY p.name
    `, [categoryId]);

    res.json(products);
  } catch (error) {
    console.error('Error en getProductsByCategory:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
}

module.exports = { getProducts, getProductById, getProductsByCategory };

// =============================================================================
// GLOSARIO
// - JOIN: une dos tablas relacionadas en una sola consulta
// - req.params: valores de la URL (ej: :id, :categoryId)
// - WHERE: filtra filas que cumplan una condición
// - 404: código HTTP "no encontrado"
// =============================================================================
