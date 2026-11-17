// =============================================================================
// ARCHIVO: routes/cartRoutes.js
// =============================================================================
//
// ANALOGÍA: Es la fila exclusiva del carrito. Solo entras si muestras tu pase (JWT).
// El guardia (authMiddleware) revisa el token antes de cada operación.
//
// URLs que crea (TODAS requieren token JWT):
// - GET    /api/cart     → ver carrito
// - POST   /api/cart     → agregar producto
// - PUT    /api/cart/:id → cambiar cantidad
// - DELETE /api/cart/:id → eliminar producto
//
// =============================================================================

const express = require('express');
const authMiddleware = require('../middlewares/authMiddleware');
const {
  getCart,
  addToCart,
  updateCartItem,
  removeCartItem,
} = require('../controllers/cartController');

const router = express.Router();

// router.use aplica el middleware a TODAS las rutas de este archivo
router.use(authMiddleware);

router.get('/', getCart);
router.post('/', addToCart);
router.put('/:id', updateCartItem);    // PUT = actualizar datos existentes
router.delete('/:id', removeCartItem); // DELETE = eliminar

module.exports = router;

// =============================================================================
// GLOSARIO
// - router.use(middleware): ejecuta el middleware en todas las rutas siguientes
// - PUT: método HTTP para actualizar
// - DELETE: método HTTP para eliminar
// =============================================================================
