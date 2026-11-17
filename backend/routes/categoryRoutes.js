// =============================================================================
// ARCHIVO: routes/categoryRoutes.js
// =============================================================================
//
// ANALOGÍA: Es la señal que dice "para ver categorías, ven por aquí".
//
// URL que crea:
// - GET /api/categories → función getCategories
//
// =============================================================================

const express = require('express');
const { getCategories } = require('../controllers/categoryController');

const router = express.Router();

// GET = pedir información (solo leer, no modificar)
router.get('/', getCategories);

module.exports = router;

// =============================================================================
// GLOSARIO
// - GET: método HTTP para obtener datos sin modificarlos
// =============================================================================
