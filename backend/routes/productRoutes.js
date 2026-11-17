// =============================================================================
// ARCHIVO: routes/productRoutes.js
// =============================================================================
//
// ANALOGÍA: Es el mapa del catálogo de productos.
// Te dice qué URL usar para ver todos, uno solo, o filtrar por categoría.
//
// URLs que crea:
// - GET /api/products                    → todos los productos
// - GET /api/products/category/:categoryId → productos de una categoría
// - GET /api/products/:id                → detalle de un producto
//
// =============================================================================

const express = require('express');
const {
  getProducts,
  getProductById,
  getProductsByCategory,
} = require('../controllers/productController');

const router = express.Router();

router.get('/', getProducts);
// IMPORTANTE: /category/:id debe ir ANTES de /:id (si no, "category" se tomaría como id)
router.get('/category/:categoryId', getProductsByCategory);
router.get('/:id', getProductById);

module.exports = router;

// =============================================================================
// GLOSARIO
// - :id, :categoryId: parámetros dinámicos en la URL (cambian según el producto)
// - Orden de rutas: las más específicas van primero
// =============================================================================
